import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'bookings_control_event_item.dart';

class BookingsControlComponent extends StatelessWidget {
  final List<BookingsPlaceOrEventUiModel>? placesOrEvents;
  final ValueChanged<BookingsPlaceOrEventUiModel?>? onPlaceItemTap;
  final ValueChanged<BookingsPlaceOrEventUiModel?>? onEventItemTap;
  final bool isCompany;
  final bool isLoading;

  BookingsControlComponent({
    super.key,
    this.placesOrEvents,
    this.onPlaceItemTap,
    this.onEventItemTap,
    this.isCompany = false,
    this.isLoading = false,
  });

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isCompany)
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
                    ).paddingOnly(bottom: SpacingFoundation.verticalSpacing12),
                  SpacingFoundation.verticalSpace12,
                  if (isLoading)
                    const Center(child: CircularProgressIndicator.adaptive())
                  else
                    ...tabValue.value
                        ? placesOrEvents != null && placesOrEvents!.isNotEmpty
                            ? placesOrEvents!.map(
                                (element) {
                                  return BookingsControlPlaceItemUiKit(
                                    title: element.title,
                                    description: element.description,
                                    imageUrl: element.imageUrl,
                                    onTap: () => onPlaceItemTap?.call(element),
                                  ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16);
                                },
                              ).toList()
                            : [
                                Center(
                                  child: Text(
                                    isCompany ? S.of(context).ThereNoPlacesYet : S.of(context).ThereNoEventsYet,
                                    style: theme?.boldTextTheme.body,
                                  ),
                                ),
                              ]
                        : isCompany
                            ? placesOrEvents != null && placesOrEvents!.isNotEmpty
                                ? placesOrEvents!.map(
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
                                          if (element != placesOrEvents!.last)
                                            Divider(
                                              color: theme?.colorScheme.surface2,
                                              thickness: 2.0,
                                            ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
                                        ],
                                      );
                                    },
                                  ).toList()
                                : [
                                    Center(
                                      child: Text(
                                        S.of(context).ThereNoEventsYet,
                                        style: theme?.boldTextTheme.body,
                                      ),
                                    ),
                                  ]
                            : [],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
