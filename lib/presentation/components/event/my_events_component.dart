import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class MyEventsComponent extends StatelessWidget {
  const MyEventsComponent({
    super.key,
    required this.title,
    required this.onEventTap,
    required this.onTap,
    required this.events,
    this.buttonText,
    this.remainsToCreate,
  });

  final String title;
  final Function(UiEventModel) onEventTap;
  final VoidCallback onTap;
  final String? buttonText;
  final List<UiEventModel> events;
  final int? remainsToCreate;

  @override
  Widget build(BuildContext context) {
    final height = ((events.isNotEmpty ? events.length : 1) * 70.h) + 80.h;
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final regularTextTheme = theme?.regularTextTheme;

    return UiKitCardWrapper(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: boldTextTheme?.title1),
              SpacingFoundation.horizontalSpace4,
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () => showUiKitPopover(
                      context,
                      customMinHeight: 30.h,
                      showButton: false,
                      title: Text(
                        S.current.HintNumberEventsForPro,
                        style: regularTextTheme?.body.copyWith(
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    child: ImageWidget(
                      iconData: ShuffleUiKitIcons.info,
                      width: 16.w,
                      color: theme?.colorScheme.darkNeutral900,
                    ),
                  );
                },
              ),
              const Spacer(),
            ],
          ),
          SpacingFoundation.verticalSpace16,
          if (events.isEmpty)
            Text(
              S.of(context).CreateYourEventAndInvitePeople,
              style: boldTextTheme?.subHeadline,
            ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16)
          else
            for (var event in events)
              event.reviewStatus != null
                  ? InkWell(
                      onTap: () => onEventTap(event),
                      borderRadius: BorderRadiusFoundation.all24,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadiusFoundation.all24,
                              gradient: LinearGradient(
                                  colors: [theme!.colorScheme.inversePrimary.withOpacity(0.3), Colors.transparent])),
                          child: Center(
                            child: Text(
                              event.reviewStatus!,
                              style: boldTextTheme?.caption1Bold.copyWith(color: Colors.white),
                            ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing8),
                          ))).paddingOnly(bottom: SpacingFoundation.verticalSpacing16)
                  : ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: BorderedUserCircleAvatar(
                        imageUrl: event.media.firstWhereOrNull((element) => element.type == UiKitMediaType.image)?.link,
                        size: 40.w,
                      ),
                      title: Text(
                        event.title ?? '',
                        style: boldTextTheme?.caption1Bold,
                      ),
                      //TODO restore schedules
                      subtitle: event.startDate != null
                          ? Text(
                              DateFormat('d MMMM').format(event.startDate!),
                              style: boldTextTheme?.caption1Medium.copyWith(
                                color: theme?.colorScheme.darkNeutral500,
                              ),
                            )
                          : const SizedBox.shrink(),
                      trailing: context.smallButton(
                        data: BaseUiKitButtonData(
                          onPressed: () => onEventTap(event),
                          iconInfo: BaseUiKitButtonIconData(
                            iconData: CupertinoIcons.right_chevron,
                            size: 20.w,
                          ),
                        ),
                      ),
                    ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
          if (remainsToCreate != null && events.isNotEmpty)
            AutoSizeText(
              '${S.of(context).RemainsToCreate}: $remainsToCreate',
              style: regularTextTheme?.subHeadline,
              maxLines: 1,
            ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
          context.gradientButton(
            data: BaseUiKitButtonData(
                onPressed: onTap, text: buttonText ?? S.of(context).CreateEvent, fit: ButtonFit.fitWidth),
          ),
        ],
      ).paddingAll(EdgeInsetsFoundation.all16),
    );
  }
}
