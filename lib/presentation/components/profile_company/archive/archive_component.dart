import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:collection/collection.dart';

class ArchiveComponent extends StatelessWidget {
  final List<UiEventModel> events;
  final List<UiPlaceModel> places;
  final Function(int) onTap;
  final Function(int) onDelete;
  final String selectedTab;
  final ValueChanged<int> tabChanged;

  const ArchiveComponent(
      {super.key,
      required this.events,
      required this.onTap,
      required this.onDelete,
      required this.places,
      required this.selectedTab,
      required this.tabChanged});

  int get _countChildren {
    if (selectedTab == 'event') {
      return events.isEmpty ? 1 : events.length;
    } else {
      return places.isEmpty ? 1 : places.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return BlurredAppBarPage(autoImplyLeading: true, title: S.of(context).Archive, centerTitle: true, children: [
      UiKitCustomTabBar(
        selectedTab: selectedTab,
        onTappedTab: tabChanged,
        tabs: [
          UiKitCustomTab(
            title: S.of(context).Events.toUpperCase(),
            customValue: 'event',
          ),
          UiKitCustomTab(
            title: S.of(context).Places.toUpperCase(),
            customValue: 'place',
          ),
        ],
      ).paddingSymmetric(
          vertical: SpacingFoundation.verticalSpacing8, horizontal: SpacingFoundation.horizontalSpacing16),
      SizedBox(
          height: 0.75.sh,
          child: ListView.builder(
            // shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: SpacingFoundation.verticalSpacing8),
            itemCount: _countChildren,
            itemBuilder: (context, index) {
              if (places.isEmpty) {
                return Center(
                  child: Text(S.of(context).NothingFound, style: theme?.boldTextTheme.caption1Bold).paddingSymmetric(
                      horizontal: SpacingFoundation.horizontalSpacing16, vertical: SpacingFoundation.verticalSpacing8),
                );
              }

              if (events.isEmpty) {
                return Center(
                  child: Text(S.of(context).NothingFound, style: theme?.boldTextTheme.caption1Bold).paddingSymmetric(
                      horizontal: SpacingFoundation.horizontalSpacing16, vertical: SpacingFoundation.verticalSpacing8),
                );
              }
              if (selectedTab == 'event') {
                final event = events[index];
                return Dismissible(
                    key: ValueKey(event.id),
                    onDismissed: (_) => onDelete(event.id),
                    direction: DismissDirection.endToStart,
                    background: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadiusFoundation.all24,
                        child: ColoredBox(
                            color: UiKitColors.red,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: const ImageWidget(
                                  iconData: ShuffleUiKitIcons.trash,
                                  color: Colors.white,
                                ).paddingOnly(right: 5.w)))),
                    child: UiKitCardWrapper(
                            padding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
                            child: event.reviewStatus != null
                                ? DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadiusFoundation.all24,
                                        gradient: LinearGradient(colors: [
                                          theme!.colorScheme.inversePrimary.withOpacity(0.3),
                                          Colors.transparent
                                        ])),
                                    child: Center(
                                      child: Text(
                                        event.reviewStatus!,
                                        style: theme.boldTextTheme.caption1Bold.copyWith(color: Colors.white),
                                      ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing8),
                                    ))
                                : ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: BorderedUserCircleAvatar(
                                      imageUrl: event.media
                                          .firstWhereOrNull((element) => element.type == UiKitMediaType.image)
                                          ?.link,
                                      size: 40.w,
                                    ),
                                    title: Text(
                                      event.title ?? '',
                                      style: theme?.boldTextTheme.caption1Bold,
                                    ),
                                    subtitle: event.startDate != null
                                        ? Text(
                                            DateFormat('MMMM d').format(event.startDate!),
                                            style: theme?.boldTextTheme.caption1Medium.copyWith(
                                              color: theme.colorScheme.darkNeutral500,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    trailing: context.smallButton(
                                      data: BaseUiKitButtonData(
                                        backgroundColor: theme?.colorScheme.surface1,
                                        onPressed: () => onTap(event.id),
                                        iconInfo: BaseUiKitButtonIconData(
                                          color: theme?.colorScheme.inversePrimary,
                                          iconData: CupertinoIcons.right_chevron,
                                          size: 20.w,
                                        ),
                                      ),
                                    ),
                                  ))
                        .paddingSymmetric(
                            horizontal: SpacingFoundation.horizontalSpacing16,
                            vertical: SpacingFoundation.verticalSpacing8));
              } else {
                final place = places[index];
                return Dismissible(
                    key: ValueKey(place.id),
                    onDismissed: (_) => onDelete(place.id),
                    direction: DismissDirection.endToStart,
                    background: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadiusFoundation.all24,
                        child: ColoredBox(
                            color: UiKitColors.red,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: const ImageWidget(
                                  iconData: ShuffleUiKitIcons.trash,
                                  color: Colors.white,
                                ).paddingOnly(right: 5.w)))),
                    child: UiKitCardWrapper(
                            padding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
                            child: place.moderationStatus != null
                                ? DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadiusFoundation.all24,
                                        gradient: LinearGradient(colors: [
                                          theme!.colorScheme.inversePrimary.withOpacity(0.3),
                                          Colors.transparent
                                        ])),
                                    child: Center(
                                      child: Text(
                                        place.moderationStatus!,
                                        style: theme.boldTextTheme.caption1Bold.copyWith(color: Colors.white),
                                      ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing8),
                                    ))
                                : ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: BorderedUserCircleAvatar(
                                      imageUrl: place.logo,
                                      size: 40.w,
                                    ),
                                    title: Text(
                                      place.title ?? '',
                                      style: theme?.boldTextTheme.caption1Bold,
                                    ),
                                    subtitle: Text(place.placeType?.title ?? ''),
                                    trailing: context.smallButton(
                                      data: BaseUiKitButtonData(
                                        backgroundColor: theme?.colorScheme.surface1,
                                        onPressed: () => onTap(place.id),
                                        iconInfo: BaseUiKitButtonIconData(
                                          color: theme?.colorScheme.inversePrimary,
                                          iconData: CupertinoIcons.right_chevron,
                                          size: 20.w,
                                        ),
                                      ),
                                    ),
                                  ))
                        .paddingSymmetric(
                            horizontal: SpacingFoundation.horizontalSpacing16,
                            vertical: SpacingFoundation.verticalSpacing8));
              }
            },
          ))
    ]);
  }
}
