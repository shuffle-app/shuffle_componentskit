import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class MyEventsComponent extends StatelessWidget {
  const MyEventsComponent({
    super.key,
    required this.title,
    required this.onTap,
    required this.events,
  });

  final String title;
  final Function(UiEventModel) onTap;
  final List<UiEventModel> events;

  @override
  Widget build(BuildContext context) {
    final height = 0.9.sw * 0.65;
    final theme = context.uiKitTheme;

    return UiKitCardWrapper(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme?.boldTextTheme.title1),
          SpacingFoundation.verticalSpace16,
          Expanded(
            child: ListView.separated(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];

                return ListTile(
                  isThreeLine: true,
                  contentPadding: EdgeInsets.zero,
                  leading: BorderedUserCircleAvatar(
                    imageUrl: event.media.firstWhere((element) => element.type == UiKitMediaType.image).link,
                    size: 40.w,
                  ),
                  title: Text(
                    event.title ?? '',
                    style: theme?.boldTextTheme.caption1Bold,
                  ),
                  //TODO restore schedules
                  // subtitle: event.date != null
                  //     ? Text(
                  //         DateFormat('MMMM d').format(event.date!),
                  //         style: theme?.boldTextTheme.caption1Medium.copyWith(
                  //           color: theme.colorScheme.darkNeutral500,
                  //         ),
                  //       )
                  //     : const SizedBox.shrink(),
                  trailing: context.smallButton(
                    data: BaseUiKitButtonData(
                      onPressed: onTap(event),
                      iconInfo: BaseUiKitButtonIconData(
                        iconData: CupertinoIcons.right_chevron,
                        size: 20.w,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => SpacingFoundation.verticalSpace4,
            ),
          ),
        ],
      ).paddingAll(EdgeInsetsFoundation.all16),
    );
  }
}
