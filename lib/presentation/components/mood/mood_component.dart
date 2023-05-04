import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class MoodComponent extends StatelessWidget {
  final UiMoodModel mood;
  final Function? onPlacePressed;

  const MoodComponent({Key? key, required this.mood, this.onPlacePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentMoodModel model =
        ComponentMoodModel.fromJson(config['mood']);

    final theme = context.uiKitTheme;
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: (model.positionModel?.bodyAlignment).mainAxisAlignment,
      crossAxisAlignment:
          (model.positionModel?.bodyAlignment).crossAxisAlignment,
      children: [
        MessageCardWithIcon(
            message: mood.title,
            icon: ImageWidget(link: mood.logo),
            layoutDirection: Axis.horizontal).paddingSymmetric(
            horizontal: model.positionModel?.horizontalMargin ?? 0),
        SpacingFoundation.verticalSpace12,
        Row(
          children: [
            const Flexible(
              child: GradientAttentionCard(
                message: 'Then check this out',
                textColor: Colors.black,
              ),
            ),
            Flexible(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (mood.descriptionItems != null &&
                    mood.descriptionItems!.isNotEmpty)
                  WeatherInfoCard(
                    temperature: mood.descriptionItems!.first.description,
                    weatherType: mood.descriptionItems!.first.title,
                  ),
                SpacingFoundation.verticalSpace12,
                if (mood.descriptionItems != null &&
                    mood.descriptionItems!.length >= 2)
                  MetricsCard(
                    title: mood.descriptionItems!.last.title,
                    value: mood.descriptionItems!.last.description,
                    unit: 'kCal',
                    icon: ImageWidget(
                      svgAsset: Assets.images.svg.fireWhite,
                    ),
                  ),
              ],
            ))
          ],
        ).paddingSymmetric(
            horizontal: model.positionModel?.horizontalMargin ?? 0),
        if (model.showPlaces ?? true) ...[
          SpacingFoundation.verticalSpace12,
          Text(
            'We have places just for you',
            style: theme?.boldTextTheme.title1,
          ).paddingSymmetric(
    horizontal: model.positionModel?.horizontalMargin ?? 0),
          SpacingFoundation.verticalSpace8,
          ...?mood.places
              ?.map((e) => PlacePreview(
                    onTap: onPlacePressed,
                    place: e,
                    model: model,
                  ).paddingSymmetric(
                      vertical: SpacingFoundation.verticalSpacing4))
              .toList(),
        ],
        SpacingFoundation.verticalSpace24,
      ],
    ).paddingSymmetric(
      vertical: model.positionModel?.verticalMargin ?? 0,
    );
  }
}
