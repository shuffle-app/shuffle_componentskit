import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class SpinnerComponent extends StatelessWidget {
  final UiSpinnerModel spinner;
  final Function? onEventTap;
  final Function? onFavoriteTap;

  const SpinnerComponent(
      {Key? key, required this.spinner, this.onEventTap, this.onFavoriteTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacing = SizesFoundation.screenWidth <= 375
        ? SpacingFoundation.verticalSpace16
        : SpacingFoundation.verticalSpace24;

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
        spacing,
        Expanded(
          child: LayoutBuilder(
            builder: (context, size) {
              return UiKitHorizontalScrollableList(
                leftPadding: SpacingFoundation.horizontalSpacing16,
                spacing: SpacingFoundation.horizontalSpacing12,
                children: spinner.events.map((e) {
                  late final Widget? ownerTrailing;
                  switch (e.owner?.type ?? UserTileType.ordinary) {
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
                      InfluencerAccountMark();
                      break;
                  }

                  return UiKitSpinnerCard(
                    availableHeight: size.maxHeight,
                    title: e.title,
                    date: e.date,
                    favourite: e.favorite,
                    photoLink: e.media
                        ?.firstWhere(
                            (element) => element.type == UiKitMediaType.image)
                        .link,
                    ownerTileTitle: e.owner?.name,
                    ownerPhotoLink: e.owner?.logo,
                    ownerTileSubtitle: e.owner?.username,
                    ownerTileTitleTrailing: ownerTrailing,
                    onTap: onEventTap != null ? () => onEventTap!(e.id) : null,
                    onFavoriteTap: onFavoriteTap != null
                        ? () => onFavoriteTap!(e.id)
                        : null,
                  );
                }).toList(),
                // children: spinner.events.call(size),
              );
            },
          ),
        ),
        spacing,
        UiKitSpinner(
          scrollController: spinner.scrollController,
          categories: spinner.categories,
          onSpinChangedCategory: spinner.onSpinChangedCategory,
        ),
      ],
    );
  }
}
