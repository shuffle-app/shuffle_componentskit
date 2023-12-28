import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SpinnerComponent extends StatelessWidget {
  final UiSpinnerModel spinner;
  final VoidCallback? onHowItWorksPoped;
  final PagingController<int, String> categoriesController;
  final PagingController<int, UiEventModel> itemsController;
  final Function? onEventTap;
  final Function? onFavoriteTap;
  final Function? favoriteStream;
  final VoidCallback? onAdvertisementTap;

  const SpinnerComponent(
      {Key? key,
      required this.spinner,
      this.onEventTap,
      this.onHowItWorksPoped,
      this.onFavoriteTap,
      this.onAdvertisementTap,
      required this.categoriesController,
      required this.itemsController,
      this.favoriteStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacing = SpacingFoundation.verticalSpace16;
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final model = ComponentSpinnerModel.fromJson(config['spinner']);
    final ads = model.content.body?[ContentItemType.advertisement]?.properties;

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: model.positionModel?.titleAlignment?.crossAxisAlignment ?? CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: MediaQuery.of(context).viewPadding.top),
        spacing,
        Stack(
          children: [
            Text(
              spinner.title,
              style: context.uiKitTheme?.boldTextTheme.title1,
              textAlign: TextAlign.center,
            ),
            if (spinner.showHowItWorks)
              HowItWorksWidget(
                  customOffset: Offset(0.78.sw, 35),
                  element: model.content.title![ContentItemType.hintDialog]!,
                  onPop: onHowItWorksPoped),
          ],
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, size) {
              final itemsCount = itemsController.itemList?.length;
              final centerSingleItem = itemsCount == 1 && !kIsWeb;

              return UiKitHorizontalScrollableList<UiEventModel>(
                pagingController: itemsController,
                scrollController: spinner.cardsScrollController,
                spacing: SpacingFoundation.horizontalSpacing12,
                shimmerLoadingChild: UiKitSpinnerCard(
                  availableHeight: size.maxHeight,
                ),
                itemBuilder: (_, item, index) {
                  if (item.isAdvertisement && (ads?.entries.isNotEmpty ?? false)) {
                    final advertisement = ads?.entries.first;

                    return Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          SpacingFoundation.verticalSpace8,
                          context
                              .advertisementBanner(
                                data: BaseUiKitAdvertisementBannerData(
                                  availableWidth: 0.75.sw,
                                  customHeight: size.maxHeight * 0.76,
                                  imageLink: item.bannerPicture,
                                  title: advertisement?.key ?? '',
                                  onPressed: onAdvertisementTap,
                                  size: AdvertisementBannerSize.values.byName(advertisement?.value.type ?? 'small'),
                                ),
                              )
                              .paddingOnly(
                                left: index == 0 ? SpacingFoundation.horizontalSpacing16 : 0,
                                right: itemsController.itemList?.length == index + 1 ? SpacingFoundation.horizontalSpacing16 : 0,
                              ),
                        ],
                      ),
                    );
                  }

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
                      availableHeight: size.maxHeight,
                      title: item.title,
                      date: item.date,
                      time: item.time,
                      timeTo: item.timeTo,
                      weekdays: item.weekdays,
                      dateTo: item.dateTo,
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
                      right: centerSingleItem
                          ? 0.125.sw
                          : itemsCount == index + 1
                              ? SpacingFoundation.horizontalSpacing16
                              : 0,
                    ),
                  );
                },
              );
            },
          ),
        ),
        spacing,
        UiKitSpinner(
          pagingController: categoriesController,
          scrollController: spinner.categoriesScrollController,
          onSpinChangedCategory: spinner.onSpinChangedCategory,
        ),
      ],
    );
  }
}
