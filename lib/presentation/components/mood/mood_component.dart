import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    final horizontalMargin =
        (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final bodyAlignment = model.positionModel?.bodyAlignment;
    final cardWidth = 0.5.sw - horizontalMargin * 2;
    final smallCardHeight =
        cardWidth / 2 - SpacingFoundation.verticalSpacing8 / 2;

    return Column(
      mainAxisAlignment: bodyAlignment.mainAxisAlignment,
      crossAxisAlignment: bodyAlignment.crossAxisAlignment,
      children: [
        SpacingFoundation.verticalSpace16,
        UiKitMessageCardWithIcon(
                message: mood.title,
                icon: ImageWidget(link: mood.logo),
                layoutDirection: Axis.horizontal)
            .paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace14,
        Row(
          children: [
            Flexible(
              child: UiKitGradientAttentionCard(
                message: 'Then check this out',
                textColor: Colors.black,
                width: cardWidth,
              ),
            ),
            Flexible(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (mood.descriptionItems != null &&
                    mood.descriptionItems!.isNotEmpty)
                  () {
                    final item = mood.descriptionItems!.first;

                    return UiKitWeatherInfoCard(
                      weatherType: item.title,
                      temperature: item.description,
                      active: item.active,
                      height: smallCardHeight,
                    );
                  }(),
                SpacingFoundation.verticalSpacing8.heightBox,
                if (mood.descriptionItems != null &&
                    mood.descriptionItems!.length >= 2)
                  () {
                    final item = mood.descriptionItems!.last;

                    return UiKitMetricsCard(
                      active: item.active,
                      height: smallCardHeight,
                      title: item.title,
                      value: item.description,
                      unit: 'kCal',
                      icon: ImageWidget(
                        svgAsset: Assets.images.svg.fireWhite,
                        color: item.active
                            ? Colors.white
                            : UiKitColors.darkNeutral200,
                      ),
                    );
                  }(),
              ],
            ).paddingOnly(left: SpacingFoundation.horizontalSpacing8))
          ],
        ).paddingSymmetric(horizontal: horizontalMargin),
        if (model.showPlaces ?? true) ...[
          SpacingFoundation.verticalSpace24,
          Text(
            'We have places just for you',
            style: theme?.boldTextTheme.title1,
          ).paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace4,
          ...?mood.places
              ?.map((e) => PlacePreview(
                    onTap: onPlacePressed,
                    place: e,
                    model: model,
                  ).paddingSymmetric(
                      vertical: SpacingFoundation.verticalSpacing12))
              .toList(),
        ],
      ],
    ).paddingSymmetric(
      vertical: (model.positionModel?.verticalMargin ?? 0).toDouble(),
    );
  }
}
