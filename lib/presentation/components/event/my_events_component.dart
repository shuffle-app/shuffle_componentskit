import 'package:collection/collection.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  });

  final String title;
  final Function(UiEventModel) onEventTap;
  final VoidCallback onTap;
  final String? buttonText;
  final List<UiEventModel> events;

  @override
  Widget build(BuildContext context) {
    final height = ((events.isNotEmpty ? events.length : 1) * 70.h) + 80.h;
    final theme = context.uiKitTheme;

    return UiKitCardWrapper(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: theme?.boldTextTheme.title1),
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
                        style: theme?.regularTextTheme.body.copyWith(
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
              // if (events.isNotEmpty)
              //   context.smallOutlinedButton(
              //       data: BaseUiKitButtonData(
              //           onPressed: onTap,
              //           iconInfo: BaseUiKitButtonIconData(
              //             iconData: CupertinoIcons.right_chevron,
              //             size: 20.w,
              //             color: theme?.colorScheme.inversePrimary,
              //           )))
            ],
          ),
          SpacingFoundation.verticalSpace16,
          // Expanded(
          //   child:
          if (events.isEmpty)
            Text(
              S.of(context).CreateYourEventAndInvitePeople,
              style: theme?.boldTextTheme.subHeadline,
            ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16)
          else
            // ListView.separated(
            //                 padding: EdgeInsets.zero,
            //                 physics: const NeverScrollableScrollPhysics(),
            //                 itemCount: min(events.length, 2),
            //                 itemBuilder: (context, index) {
            for (var event in events)
              // final event = events[index];

              event.reviewStatus != null
                  ? DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusFoundation.all24,
                          gradient: LinearGradient(
                              colors: [theme!.colorScheme.inversePrimary.withOpacity(0.3), Colors.transparent])),
                      child: Center(
                        child: Text(
                          event.reviewStatus!,
                          style: theme.boldTextTheme.caption1Bold.copyWith(color: Colors.white),
                        ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing8),
                      )).paddingOnly(bottom: SpacingFoundation.verticalSpacing16)
                  : ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: BorderedUserCircleAvatar(
                        imageUrl: event.media.firstWhereOrNull((element) => element.type == UiKitMediaType.image)?.link,
                        size: 40.w,
                      ),
                      title: Text(
                        event.title ?? '',
                        style: theme?.boldTextTheme.caption1Bold,
                      ),
                      //TODO restore schedules
                      subtitle: event.date != null
                          ? Text(
                              DateFormat('MMMM d').format(event.date!),
                              style: theme?.boldTextTheme.caption1Medium.copyWith(
                                color: theme.colorScheme.darkNeutral500,
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
          // ;
          //                 },
          //                 separatorBuilder: (_, __) => SpacingFoundation.verticalSpace4,
          //               ),
          //       ),
          context.gradientButton(
            data: BaseUiKitButtonData(
                onPressed: onTap, text: buttonText ?? S.of(context).CreateEvent, fit: ButtonFit.fitWidth),
          ),
        ],
      ).paddingAll(EdgeInsetsFoundation.all16),
    );
  }
}
