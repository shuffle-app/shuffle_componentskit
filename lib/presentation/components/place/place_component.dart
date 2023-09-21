import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlaceComponent extends StatelessWidget {
  final UiPlaceModel place;

  const PlaceComponent({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentPlaceModel model = kIsWeb
        ? ComponentPlaceModel(
            version: '',
            pageBuilderType: PageBuilderType.page,
            positionModel: PositionModel(
                version: '', horizontalMargin: 16, verticalMargin: 10, bodyAlignment: Alignment.centerLeft))
        : ComponentPlaceModel.fromJson(config['place']);
    final titleAlignment = model.positionModel?.titleAlignment;
    final bodyAlignment = model.positionModel?.bodyAlignment;
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    return Column(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: titleAlignment.mainAxisAlignment,
          crossAxisAlignment: titleAlignment.crossAxisAlignment,
          children: [
            TitleWithAvatar(
              title: place.title,
              avatarUrl: place.logo,
              horizontalMargin: horizontalMargin,
            ),
          ],
        ).paddingSymmetric(horizontal: horizontalMargin, vertical: SpacingFoundation.verticalSpacing16),
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
              horizontalMargin: horizontalMargin,
            ),
            SpacingFoundation.verticalSpace8,
            Row(
              mainAxisSize: MainAxisSize.max,
              children: () {
                final AutoSizeGroup g = AutoSizeGroup();

                return [
                  Expanded(
                    child: UpcomingEventPlaceActionCard(
                      value: 'in 2 days',
                      group: g,
                      vectorIconAsset: GraphicsFoundation.instance.svg.events,
                      action: () {
                        log('calendar was pressed');
                      },
                    ),
                  ),
                  SpacingFoundation.horizontalSpace8,
                  Expanded(
                    child: PointBalancePlaceActionCard(
                      value: '2 650',
                      group: g,
                      vectorIconAsset: GraphicsFoundation.instance.svg.coin,
                      action: () {
                        log('balance was pressed');
                      },
                    ),
                  ),
                ];
              }(),
            ),
            SpacingFoundation.verticalSpace8,
            GridView.count(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: SpacingFoundation.horizontalSpacing8,
              childAspectRatio: 1.8,
              children: place.descriptionItems!
                  .map((e) => GestureDetector(
                      onTap: () {
                        if (e.description.startsWith('http')) {
                          launchUrlString(e.description);
                        } else if (e.description.replaceAll(RegExp(r'[0-9]'), '').replaceAll('+', '').trim().isEmpty) {
                          log('launching $e.description', name: 'PlaceComponent');
                          launchUrlString('tel:${e.description}');
                        }
                      },
                      child: UiKitTitledDescriptionGridWidget(
                        title: e.title,
                        description: e.description,
                        spacing: SpacingFoundation.horizontalSpacing8,
                        showFullInfo: true,
                      )))
                  .toList(),
            ).paddingSymmetric(horizontal: horizontalMargin),
            SpacingFoundation.verticalSpace8,
          ],
        ),
      ],
      // ),
    ).paddingSymmetric(vertical: verticalMargin);
  }
}
