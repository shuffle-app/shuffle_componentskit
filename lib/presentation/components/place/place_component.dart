import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PlaceComponent extends StatelessWidget {
  final UiPlaceModel placeData;
  final List<UiDescriptionItemModel> placeDescriptionItems;

  const PlaceComponent(
      {Key? key, required this.placeData, required this.placeDescriptionItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentPlaceModel model = ComponentPlaceModel.fromJson(config['place']);

    final theme = context.uiKitTheme;
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SpacingFoundation.verticalSpace4,
        Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                (model.positionModel?.titleAlignment).mainAxisAlignment,
            crossAxisAlignment:
                (model.positionModel?.titleAlignment).crossAxisAlignment,
            children: [
              TitleWithAvatar(
                title: placeData.title,
                avatarUrl: placeData.logo,
              ),
            ]),
        SpacingFoundation.verticalSpace4,
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              (model.positionModel?.bodyAlignment).mainAxisAlignment,
          crossAxisAlignment:
              (model.positionModel?.bodyAlignment).crossAxisAlignment,
          children: [
            UiKitPhotoSlider(
              media: placeData.media,
              width: size.width,
              height: 256,
            ),
            SpacingFoundation.verticalSpace12,
            UiKitTagsWidget(
              rating: (model.showRating ?? false) ? placeData.rating : null,
              uniqueTags: placeData.tags,
              baseTags: placeData.baseTags ?? [],
            ),
            SpacingFoundation.verticalSpace12,
            Text(
              placeData.description,
              style:
                  theme?.boldTextTheme.caption1Bold.copyWith(color: Colors.white),
            ),
            SpacingFoundation.verticalSpace16,
            IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: UpcomingEventPlaceActionCard(
                      value: 'in 2 days',
                      rasterIconAsset: Assets.images.png.calendar,
                      action: () {},
                    ),
                  ),
                  SpacingFoundation.horizontalSpace8,
                  Expanded(
                    child: PointBalancePlaceActionCard(
                      value: '2 650',
                      rasterIconAsset: Assets.images.png.calendar,
                      action: () {},
                    ),
                  ),
                ],
              ),
            ),
            SpacingFoundation.verticalSpace16,
            PlaceDescriptionGrid(
              spacing: 16,
              children: placeDescriptionItems.map((e) => UiKitTitledDescriptionWidget(title: e.title,description: e.description,)).toList(),
            ),
            SpacingFoundation.verticalSpace16,
          ],
        ),
      ],
      // ),
    ).paddingSymmetric(
        vertical: model.positionModel?.verticalMargin ?? 0,
        horizontal: model.positionModel?.horizontalMargin ?? 0);
  }
}
