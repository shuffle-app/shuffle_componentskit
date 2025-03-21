import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/bookings_control/bookings_control_event_item.dart';
import 'package:shuffle_components_kit/presentation/components/bookings_control/bookings_control_ui_models/bookings_place_or_even_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AddPromotionsComponent extends StatefulWidget {
  final List<BookingsPlaceOrEventUiModel> placesOrEvents;
  final ValueChanged<BookingsPlaceOrEventUiModel?>? onPlaceItemTap;
  final ValueChanged<BookingsPlaceOrEventUiModel?>? onEventItemTap;
  final bool isLoading;
  final bool isPro;

  late final List<BookingsPlaceOrEventUiModel> placeForEvent;

  AddPromotionsComponent({
    super.key,
    this.placesOrEvents = const [],
    this.onPlaceItemTap,
    this.onEventItemTap,
    this.isPro = false,
    this.isLoading = false,
  }) {
    placeForEvent = placesOrEvents.where((element) => element.events != null && element.events!.isNotEmpty).toList();
  }

  @override
  State<AddPromotionsComponent> createState() => _AddPromotionsComponentState();
}

class _AddPromotionsComponentState extends State<AddPromotionsComponent> with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return BlurredAppBarPage(
      customTitle: Flexible(
        child: AutoSizeText(
          S.current.AddPromotion,
          style: theme?.boldTextTheme.title1,
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
      autoImplyLeading: true,
      physics: NeverScrollableScrollPhysics(),
      children: widget.isPro
          ? widget.placesOrEvents.where((e) => !e.isPlace).isNotEmpty
              ? widget.placesOrEvents
                  .where((e) => !e.isPlace)
                  .map(
                    (e) => BookingsControlPlaceItemUiKit(
                      title: e.title,
                      description: e.description,
                      imageUrl: e.imageUrl,
                      onTap: () => widget.onEventItemTap?.call(e),
                    ).paddingSymmetric(
                      horizontal: SpacingFoundation.horizontalSpacing16,
                      vertical: SpacingFoundation.verticalSpacing6,
                    ),
                  )
                  .toList()
              : [
                  Center(
                    child: Text(
                      S.of(context).AddAtLeastOneXToPromoteIt(S.of(context).Event.toLowerCase()),
                      style: theme?.boldTextTheme.body,
                    ).paddingAll(SpacingFoundation.horizontalSpacing16),
                  ),
                ]
          : [
              SpacingFoundation.verticalSpace16,
              UiKitCustomTabBar(
                tabController: tabController,
                tabs: [
                  UiKitCustomTab(title: S.current.Place.toUpperCase(), height: 25.h),
                  UiKitCustomTab(title: S.current.Events.toUpperCase(), height: 25.h),
                ],
                onTappedTab: (index) {},
              ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
              SpacingFoundation.verticalSpace24,
              SizedBox(
                height: 1.sw <= 380 ? 0.7.sh : 0.8.sh,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ListView(
                      padding: EdgeInsets.all(0),
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      children: widget.placesOrEvents.where((e) => e.isPlace).isNotEmpty
                          ? widget.placesOrEvents
                              .where((e) => e.isPlace)
                              .map(
                                (e) => BookingsControlPlaceItemUiKit(
                                  title: e.title,
                                  description: e.description,
                                  imageUrl: e.imageUrl,
                                  onTap: () => widget.onPlaceItemTap?.call(e),
                                ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
                              )
                              .toList()
                          : [
                              Center(
                                child: Text(
                                  S.of(context).AddAtLeastOneXToPromoteIt(S.of(context).Place.toLowerCase()),
                                  style: theme?.boldTextTheme.body,
                                ),
                              ),
                            ],
                    ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
                    ListView(
                      padding: EdgeInsets.all(0),
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      children: widget.placeForEvent.isNotEmpty
                          ? widget.placeForEvent
                              .map((e) => Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      BookingsControlEventItem(
                                        title: e.title,
                                        description: e.description,
                                        events: e.events,
                                        onTap: (id) {
                                          widget.onEventItemTap?.call(
                                            e.events?.firstWhere((e) => e.id == id),
                                          );
                                        },
                                      ),
                                      if (e != widget.placeForEvent.last)
                                        Divider(
                                          color: theme?.colorScheme.surface2,
                                          thickness: 2.0,
                                        ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
                                    ],
                                  ))
                              .toList()
                          : [
                              Center(
                                child: Text(
                                  S.of(context).AddAtLeastOneXToPromoteIt(S.of(context).Event.toLowerCase()),
                                  style: theme?.boldTextTheme.body,
                                ),
                              ),
                            ],
                    ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
                  ],
                ),
              )
            ],
    );
  }
}
