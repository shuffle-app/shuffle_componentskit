import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PlaceComponent extends StatelessWidget {
  final UiPlaceModel place;

  const PlaceComponent({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentPlaceModel model =
        ComponentPlaceModel.fromJson(config['place']);
    final titleAlignment = model.positionModel?.titleAlignment;
    final bodyAlignment = model.positionModel?.bodyAlignment;

    return Column(
      children: [
        SpacingFoundation.verticalSpace4,
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: titleAlignment.mainAxisAlignment,
          crossAxisAlignment: titleAlignment.crossAxisAlignment,
          children: [
            TitleWithAvatar(
              title: place.title,
              avatarUrl: place.logo,
            ),
          ],
        ),
        SpacingFoundation.verticalSpace4,
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: bodyAlignment.mainAxisAlignment,
          crossAxisAlignment: bodyAlignment.crossAxisAlignment,
          children: [
            UiKitMediaSliderWithTags(
              rating: place.rating,
              media: place.media,
              description: place.description,
              baseTags: place.baseTags ?? [],
              uniqueTags: place.tags,
            ),
            // UiKitPhotoSlider(
            //   media: placeData.media,
            //   width: size.width,
            //   height: 256,
            // ),
            // SpacingFoundation.verticalSpace12,
            // UiKitTagsWidget(
            //   rating: (model.showRating ?? false) ? placeData.rating : null,
            //   uniqueTags: placeData.tags,
            //   baseTags: placeData.baseTags ?? [],
            // ),
            // SpacingFoundation.verticalSpace12,
            // Text(
            //   placeData.description,
            //   style: theme?.boldTextTheme.caption1Bold
            //       .copyWith(color: Colors.white),
            // ),
            SpacingFoundation.verticalSpace16,
            IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: () {
                  final icon = Assets.images.png.calendar;

                  return [
                    Expanded(
                      child: UpcomingEventPlaceActionCard(
                        value: 'in 2 days',
                        rasterIconAsset: icon,
                        action: () {
                          log('calendar was pressed');
                        },
                      ),
                    ),
                    SpacingFoundation.horizontalSpace8,
                    Expanded(
                      child: PointBalancePlaceActionCard(
                        value: '2 650',
                        rasterIconAsset: icon,
                        action: () {
                          log('balance was pressed');
                        },
                      ),
                    ),
                  ];
                }(),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            PlaceDescriptionGrid(
              spacing: 16,
              children: place.descriptionItems!
                  .map((e) => UiKitTitledDescriptionWidget(
                        title: e.title,
                        description: e.description,
                      ))
                  .toList(),
            ),
            SpacingFoundation.verticalSpace16,
          ],
        ),
      ],
      // ),
    ).paddingSymmetric(
      vertical: model.positionModel?.verticalMargin ?? 0,
      horizontal: model.positionModel?.horizontalMargin ?? 0,
    );
  }
}
