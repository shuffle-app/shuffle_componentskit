import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'bookings_control_event_item.dart';

class BookingsControlComponent extends StatelessWidget {
  final List<BookingsPlaceOrEventUiModel>? placesOrEvents;
  final ValueChanged<BookingsPlaceOrEventUiModel?>? onPlaceItemTap;
  final ValueChanged<BookingsPlaceOrEventUiModel?>? onEventItemTap;

  BookingsControlComponent({
    super.key,
    this.placesOrEvents,
    this.onPlaceItemTap,
    this.onEventItemTap,
  });

  final ValueNotifier<bool> tabValue = ValueNotifier(true);
  final List<BookingsPlaceOrEventUiModel> places = [];
  final List<BookingsPlaceOrEventUiModel> events = [];

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    for (var element in placesOrEvents ?? []) {
      element.events != null ? events.add(element) : places.add(element);
    }

    return Scaffold(
      body: BlurredAppBarPage(
        title: S.of(context).BookingsHeading,
        autoImplyLeading: true,
        centerTitle: true,
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        children: [
          SpacingFoundation.verticalSpace16,
          ValueListenableBuilder(
            valueListenable: tabValue,
            builder: (context, value, child) {
              return Column(
                children: [
                  UiKitCustomTabBar(
                    selectedTab: tabValue.value.toString(),
                    onTappedTab: (index) => tabValue.value = index == 0,
                    tabs: [
                      UiKitCustomTab(
                        title: S.of(context).Place.toUpperCase(),
                        customValue: 'true',
                      ),
                      UiKitCustomTab(
                        title: S.of(context).Events.toUpperCase(),
                        customValue: 'false',
                      ),
                    ],
                  ),
                  SpacingFoundation.verticalSpace24,
                  ListView.separated(
                    itemCount: tabValue.value ? places.length : events.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    controller: ScrollController(),
                    separatorBuilder: (context, index) => tabValue.value
                        ? SpacingFoundation.verticalSpace16
                        : Divider(
                            color: theme?.colorScheme.surface2,
                            thickness: 2.0,
                          ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
                    itemBuilder: (context, index) {
                      if (tabValue.value) {
                        final element = places[index];

                        return BookingsControlPlaceItemUiKit(
                          title: element.title,
                          description: element.description,
                          imageUrl: element.imageUrl,
                          onTap: () => onPlaceItemTap?.call(element),
                        );
                      } else {
                        final element = events[index];

                        return BookingsControlEventItem(
                          title: element.title,
                          description: element.description,
                          events: element.events,
                          onTap: (id) {
                            onEventItemTap?.call(
                              element.events?.firstWhere((element) => element.id == id),
                            );
                          },
                        );
                      }
                    },
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}