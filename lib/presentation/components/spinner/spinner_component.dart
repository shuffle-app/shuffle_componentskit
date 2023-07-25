import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class SpinnerComponent extends StatelessWidget {
  final UiSpinnerModel spinner;
  final PagingController<int, String> categoriesController;
  final PagingController<int, UiEventModel> itemsController;
  final Function? onEventTap;
  final Function? onFavoriteTap;
  final favoriteStream;

  const SpinnerComponent(
      {Key? key,
      required this.spinner,
      this.onEventTap,
      this.onFavoriteTap,
      required this.categoriesController,
      required this.itemsController, this.favoriteStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacing = SpacingFoundation.verticalSpace16;
    // final spacing = SizesFoundation.screenWidth <= 375
    //     ? SpacingFoundation.verticalSpace16
    //     : SpacingFoundation.verticalSpace24;

    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final model = ComponentShuffleModel.fromJson(config['shuffle']);

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment:
          model.positionModel?.titleAlignment?.crossAxisAlignment ??
              CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: MediaQuery.of(context).viewPadding.top,
        ),
        spacing,
        Text(
          spinner.title,
          style: context.uiKitTheme?.boldTextTheme.title1,
          textAlign: TextAlign.center,
        ),
        // SizesFoundation.screenWidth <= 375 ?SpacingFoundation.verticalSpace2 :SpacingFoundation.verticalSpace4,
        Expanded(
          child: LayoutBuilder(
            builder: (context, size) {
              return
                  // PagedListView.separated(pagingController: pagingController, builderDelegate: builderDelegate, separatorBuilder: separatorBuilder)
                  UiKitHorizontalScrollableList<UiEventModel>(
                      pagingController: itemsController,
                      scrollController: spinner.cardsScrollController,
                      // leftPadding: SpacingFoundation.horizontalSpacing16,
                      spacing: SpacingFoundation.horizontalSpacing12,
                      itemBuilder: (_, item, index) {
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
                        }

                        return StreamBuilder(
                            stream: favoriteStream(item.id),
                            builder: (_, favoriteValue) => UiKitSpinnerCard(
                                  availableHeight: size.maxHeight,
                                  // availableHeight: 0.56.sh,
                                  title: item.title,
                                  date: item.date,
                                  favourite: favoriteValue.data as bool? ?? item.favorite,
                                  photoLink: item.media
                                      ?.firstWhere((element) =>
                                          element.type == UiKitMediaType.image)
                                      .link,
                                  ownerTileTitle: item.owner?.name,
                                  ownerPhotoLink: item.owner?.logo,
                                  ownerTileSubtitle: item.owner?.username,
                                  ownerTileTitleTrailing: ownerTrailing,
                                  onTap: () => onEventTap?.call(item.id),
                                  onFavoriteTap: () =>
                                      onFavoriteTap?.call(item.id),
                                ).paddingOnly(
                                    left: index == 0
                                        ? SpacingFoundation.horizontalSpacing16
                                        : 0,
                                    right: itemsController.itemList?.length ==
                                            index + 1
                                        ? SpacingFoundation.horizontalSpacing16
                                        : 0));
                        // }).toList(),
                      }
                      // children: spinner.events.call(size),
                      );
            },
          ),
        ),
        spacing,
        UiKitSpinner(
          pagingController: categoriesController,
          scrollController: spinner.categoriesScrollController,
          // categories: spinner.categories
          //     .map((e) => e.substring(0, 1).toUpperCase() + e.substring(1))
          //     .toList(),
          onSpinChangedCategory: spinner.onSpinChangedCategory,
        ),
      ],
    );
  }
}
