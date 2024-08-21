import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'bookings_control_event_item.dart';

class BookingsControlComponent extends StatelessWidget {
  final List<BookingsEventUiModel>? events;
  final List<BookingsPlaceOrEventUiModel>? places;
  final ValueChanged<BookingsPlaceOrEventUiModel?>? onPlaceItemTap;
  final ValueChanged<BookingsPlaceOrEventUiModel?>? onEventItemTap;

  BookingsControlComponent({
    super.key,
    this.places,
    this.events,
    this.onPlaceItemTap,
    this.onEventItemTap,
  });

  final ValueNotifier<bool> tabChange = ValueNotifier(true);

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
          UiKitCustomTabBar(
            onTappedTab: (index) {
              if (index == 0) {
                tabChange.value = true;
              } else {
                tabChange.value = false;
              }
            },
            tabs: [
              UiKitCustomTab(
                title: S.of(context).Place.toUpperCase(),
              ),
              UiKitCustomTab(
                title: S.of(context).Events.toUpperCase(),
              ),
            ],
          ),
          SpacingFoundation.verticalSpace24,
          ValueListenableBuilder(
            valueListenable: tabChange,
            builder: (context, value, child) {
              return tabChange.value == true
                  ? ListView.separated(
                      itemCount: places!.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      controller: ScrollController(),
                      separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
                      itemBuilder: (context, index) {
                        final element = places![index];

                        return BookingsControlPlaceItemUiKit(
                          title: element.title,
                          description: element.description,
                          imageUrl: element.imageUrl,
                          onTap: () => onPlaceItemTap?.call(element),
                        );
                      },
                    )
                  : ListView.separated(
                      itemCount: events!.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      controller: ScrollController(),
                      separatorBuilder: (context, index) => Divider(
                        color: theme?.colorScheme.surface2,
                        thickness: 2.0,
                      ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
                      itemBuilder: (context, index) {
                        final element = events![index];

                        return BookingsControlEventUiKit(
                          title: element.title,
                          description: element.description,
                          events: element.events,
                          onTap: (id) {
                            onEventItemTap?.call(
                              element.events?.firstWhere((element) => element.id == id),
                            );
                          },
                        );
                      },
                    );
            },
          ),
        ],
      ),
    );
  }
}
