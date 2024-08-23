import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'bookings_control_event_item.dart';

class BookingsControlComponent extends StatelessWidget {
  final List<BookingsPlaceOrEventUiModel>? placesOrEvents;
  final ValueChanged<BookingsPlaceOrEventUiModel?>? onPlaceItemTap;
  final ValueChanged<BookingsPlaceOrEventUiModel?>? onEventItemTap;

  late final List<BookingsPlaceOrEventUiModel> places;
  late final List<BookingsPlaceOrEventUiModel> events;

  BookingsControlComponent({
    super.key,
    this.placesOrEvents,
    this.onPlaceItemTap,
    this.onEventItemTap,
  }) {
    places = List.empty(growable: true);
    events = List.empty(growable: true);

    for (var element in placesOrEvents ?? []) {
      element.events != null ? events.add(element) : places.add(element);
    }
  }

  final ValueNotifier<bool> tabValue = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

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
                  ...tabValue.value
                      ? places.map(
                          (element) {
                            return BookingsControlPlaceItemUiKit(
                              title: element.title,
                              description: element.description,
                              imageUrl: element.imageUrl,
                              onTap: () => onPlaceItemTap?.call(element),
                            ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16);
                          },
                        ).toList()
                      : events.map(
                          (element) {
                            return Column(
                              children: [
                                BookingsControlEventItem(
                                  title: element.title,
                                  description: element.description,
                                  events: element.events,
                                  onTap: (id) {
                                    onEventItemTap?.call(
                                      element.events?.firstWhere((element) => element.id == id),
                                    );
                                  },
                                ),
                                if (element != events.last)
                                  Divider(
                                    color: theme?.colorScheme.surface2,
                                    thickness: 2.0,
                                  ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
                              ],
                            );
                          },
                        ).toList(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
