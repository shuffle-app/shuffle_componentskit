import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PlaceComponent extends StatelessWidget {
  final UiPlaceModel place;

  const PlaceComponent({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentPlaceModel model = ComponentPlaceModel.fromJson(config['place']);
    final titleAlignment = model.positionModel?.titleAlignment;
    final bodyAlignment = model.positionModel?.bodyAlignment;
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

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
            GridView.count(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: SpacingFoundation.horizontalSpacing8,
              childAspectRatio: 2,
              children: place.descriptionItems!
                  .map((e) => TitledAccentInfo(
                        title: e.title,
                        info: e.description,
                      ))
                  .toList(),
            ).paddingSymmetric(horizontal: horizontalMargin),
            SpacingFoundation.verticalSpace8,
          ],
        ),
      ],
      // ),
    ).paddingSymmetric(
      vertical: (model.positionModel?.verticalMargin ?? 0).toDouble(),
    );
  }
}
