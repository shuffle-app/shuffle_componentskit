import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UpcomingEventsSpinnerComponent extends StatelessWidget {
  final UiUpcomingEventsSpinnerModel uiModel;
  final PagingController<int, UiEventModel> itemsController;
  final PagingController<int, String> categoriesController;
  final Function? onEventTap;
  final Function? onFavoriteTap;
  final Function? favoriteStream;
  final VoidCallback? onAdvertisementTap;

  const UpcomingEventsSpinnerComponent({
    super.key,
    required this.uiModel,
    required this.itemsController,
    required this.categoriesController,
    this.onEventTap,
    this.onFavoriteTap,
    this.favoriteStream,
    this.onAdvertisementTap,
  });

  factory UpcomingEventsSpinnerComponent.simple(
      {required List<UiEventModel> events, Function? onEventTap, Function? onFavoriteTap, Function? favoriteStream}) {
    final PagingController<int, UiEventModel> itemsController =
    PagingController<int, UiEventModel>(firstPageKey: 1, invisibleItemsThreshold: 1);
    final PagingController<int, String> categoriesController =
    PagingController<int, String>(firstPageKey: 1, invisibleItemsThreshold: 1);
    Future.delayed(const Duration(seconds: 1), () {
      categoriesController.appendLastPage(events.map((event) => event.eventType?.title ?? 'category').toSet().toList());
      itemsController
          .appendLastPage(events.where((element) => element.eventType?.title == categoriesController.itemList?.first).toList());
    });
    final cardsScroll = ScrollController();
    final UiUpcomingEventsSpinnerModel uiModel = UiUpcomingEventsSpinnerModel(
        categoriesScrollController: ScrollController(),
        cardsScrollController: cardsScroll,
        onSpinChangedCategory: (value) {
          itemsController.refresh();
          itemsController.appendLastPage(events.where((element) => element.eventType?.title == value).toList());
          cardsScroll.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.bounceIn);
        });

    return UpcomingEventsSpinnerComponent(
      onEventTap: onEventTap,
      uiModel: uiModel,
      onFavoriteTap: onFavoriteTap,
      favoriteStream: favoriteStream,
      itemsController: itemsController,
      categoriesController: categoriesController,
    );
  }

  @override
  Widget build(BuildContext context) {
    final spinnerWheelHeight = 0.25.sh;
    final cardsListHeight = 1.sh -
        (context.uiKitTheme?.customAppBapTheme.toolbarHeight ?? 0) -
        spinnerWheelHeight -
        SpacingFoundation.verticalSpacing16;

    return BlurredAppBarPage(
      physics: const NeverScrollableScrollPhysics(),
      autoImplyLeading: true,
      centerTitle: true,
      title: S.current.Events,
      children: [
        SizedBox(
          width: 1.sw,
          height: cardsListHeight,
          child: UiKitHorizontalScrollableList<UiEventModel>(
            pagingController: itemsController,
            scrollController: uiModel.cardsScrollController,
            spacing: SpacingFoundation.horizontalSpacing12,
            shimmerLoadingChild: UiKitSpinnerCard(availableHeight: cardsListHeight).paddingOnly(
                left: SpacingFoundation.horizontalSpacing16),
            itemBuilder: (_, item, index) {
              final itemsCount = itemsController.itemList?.length;
              final centerSingleItem = itemsCount == 1 && !kIsWeb;

              late final Widget? ownerTrailing;
              switch (item.owner?.type ?? UserTileType.ordinary) {
                case UserTileType.ordinary:
                  ownerTrailing = null;
                  break;
                case UserTileType.pro:
                  ownerTrailing = ProAccountMark();
                  break;
                case UserTileType.premium:
                  ownerTrailing = PremiumAccountMark();
                  break;
                case UserTileType.influencer:
                  ownerTrailing = InfluencerAccountMark();
                  break;
                default:
                  ownerTrailing = null;
              }

              return StreamBuilder(
                stream: favoriteStream?.call(item.id),
                builder: (_, favoriteValue) =>
                    UiKitSpinnerCard(
                      availableHeight: cardsListHeight,
                      title: item.title,
                      scheduleString: item.scheduleString?.replaceAll('\n', ', '),
                      favourite: favoriteValue.data as bool? ?? item.favorite,
                      photoLink: item.verticalPreview?.link ?? item.media
                          .firstWhere((element) => element.type == UiKitMediaType.image)
                          .link,
                      ownerTileTitle: item.owner?.name,
                      ownerPhotoLink: item.owner?.logo,
                      ownerTileSubtitle: item.owner?.username,
                      ownerTileTitleTrailing: ownerTrailing,
                      onTap: () => onEventTap?.call(item.id),
                      onFavoriteTap: () => onFavoriteTap?.call(item.id),
                    ).paddingOnly(
                      left: centerSingleItem
                          ? 0.125.sw
                          : index == 0
                          ? SpacingFoundation.horizontalSpacing16
                          : 0,
                      right: centerSingleItem ? 0.125.sw : SpacingFoundation.horizontalSpacing16,
                    ),
              );
            },
          ),
        ),
        SpacingFoundation.verticalSpace16,
        SizedBox(
          width: 1.sw,
          height: spinnerWheelHeight,
          child: UiKitSpinner(
            pagingController: categoriesController,
            scrollController: uiModel.categoriesScrollController,
            onSpinChangedCategory: uiModel.onSpinChangedCategory,
          ),
        ),
      ],
    );
  }
}
