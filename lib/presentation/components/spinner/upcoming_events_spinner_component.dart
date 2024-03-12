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
    Key? key,
    required this.uiModel,
    required this.itemsController,
    required this.categoriesController,
    this.onEventTap,
    this.onFavoriteTap,
    this.favoriteStream,
    this.onAdvertisementTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    // print(config.containsKey('upcoming_events_spinner'));
    // final model = ComponentSpinnerModel.fromJson(config['upcoming_events_spinner']);
    // final ads = model.content.body?[ContentItemType.advertisement]?.properties;
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
            shimmerLoadingChild: UiKitSpinnerCard(availableHeight: cardsListHeight).paddingOnly(left: 0.125.sw),
            itemBuilder: (_, item, index) {
              final itemsCount = itemsController.itemList?.length;
              final centerSingleItem = itemsCount == 1 && !kIsWeb;
              // if (item.isAdvertisement && (ads?.entries.isNotEmpty ?? false)) {
              //   final advertisement = ads?.entries.first;
              //
              //   return Align(
              //     alignment: Alignment.topCenter,
              //     child: Column(
              //       children: [
              //         SpacingFoundation.verticalSpace8,
              //         context
              //             .advertisementBanner(
              //               data: BaseUiKitAdvertisementBannerData(
              //                 availableWidth: 0.75.sw,
              //                 customHeight: size.maxHeight * 0.76,
              //                 imageLink: item.bannerPicture,
              //                 title: advertisement?.key ?? '',
              //                 onPressed: onAdvertisementTap,
              //                 size: AdvertisementBannerSize.values.byName(advertisement?.value.type ?? 'small'),
              //               ),
              //             )
              //             .paddingOnly(
              //               left: index == 0 ? SpacingFoundation.horizontalSpacing16 : 0,
              //               right: itemsController.itemList?.length == index + 1 ? SpacingFoundation.horizontalSpacing16 : 0,
              //             ),
              //       ],
              //     ),
              //   );
              // }

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
                builder: (_, favoriteValue) => UiKitSpinnerCard(
                  availableHeight: cardsListHeight,
                  title: item.title,
                  scheduleString: item.scheduleString?.replaceAll('\n', ', '),
                  favourite: favoriteValue.data as bool? ?? item.favorite,
                  photoLink: item.media.firstWhere((element) => element.type == UiKitMediaType.image).link,
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
