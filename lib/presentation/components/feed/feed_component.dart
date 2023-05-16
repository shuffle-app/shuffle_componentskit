import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedComponent extends StatelessWidget {
  final UiFeedModel feed;
  final Function? onMoodPressed;
  final Function? onEventPressed;
  final Function? onPlacePressed;
  final Function? onTagSortPressed;

  const FeedComponent(
      {Key? key, required this.feed, this.onMoodPressed, this.onEventPressed, this.onPlacePressed, this.onTagSortPressed})
      : super(key: key);

  Widget _howItWorksDialog(context, textStyle) => UiKitHintDialog(
        title: 'Depending on...',
        subtitle: 'you get exactly what you need',
        textStyle: textStyle,
        dismissText: 'OKAY, COOL!',
        onDismiss: () => Navigator.pop(context),
        hintTiles: [
          UiKitIconHintCard(
            icon: ImageWidget(
              svgAsset: GraphicsFoundation.instance.svg.location,
            ),
            hint: 'your location',
          ),
          UiKitIconHintCard(
            icon: ImageWidget(
              svgAsset: GraphicsFoundation.instance.svg.dart,
            ),
            hint: 'your interests',
          ),
          UiKitIconHintCard(
            icon: ImageWidget(
              svgAsset: GraphicsFoundation.instance.svg.sunClouds,
            ),
            hint: 'weather around',
          ),
          UiKitIconHintCard(
            icon: ImageWidget(
              svgAsset: GraphicsFoundation.instance.svg.smileMood,
            ),
            hint: 'and other 14 scales',
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentFeedModel model = ComponentFeedModel.fromJson(config['feed']);

    final themeTitleStyle = context.uiKitTheme?.boldTextTheme.title1;
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    final horizontalMargin = model.positionModel?.horizontalMargin ?? 0;
    final horizontalWidthBox = (horizontalMargin - SpacingFoundation.horizontalSpacing4).widthBox;
    final bodyAlignment = model.positionModel?.bodyAlignment;

    return Column(
      mainAxisAlignment: bodyAlignment.mainAxisAlignment,
      crossAxisAlignment: bodyAlignment.crossAxisAlignment,
      children: [
        if (feed.recommendedEvent != null && (model.showDailyRecomendation ?? true)) ...[
          topPadding.heightBox,
          UiKitAccentCard(
            onPressed: onEventPressed == null ? null : () => onEventPressed!(feed.recommendedEvent?.id),
            title: feed.recommendedEvent!.title ?? '',
            additionalInfo: feed.recommendedEvent!.descriptionItems?.first.description ?? '',
            accentMessage: 'Don\'t miss it',
            image: ImageWidget(
              link: feed.recommendedEvent?.media?.first.link,
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          ).paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace8
        ],
        if (feed.moods != null && (model.showFeelings ?? true)) ...[
          Stack(
            children: [
              Text('How’re you feeling tonight?', style: themeTitleStyle),
              Transform.translate(
                offset: Offset(size.width / 1.7, 15),
                child: Transform.rotate(
                  angle: pi * -20 / 180,
                  child: RotatableWidget(
                    endAngle: pi * 20 / 180,
                    alignment: Alignment.center,
                    applyReverseOnEnd: true,
                    startDelay: const Duration(seconds: 10),
                    child: UiKitBlurredQuestionChip(
                      label: 'How it works',
                      onTap: () => showUiKitFullScreenAlertDialog(context, child: _howItWorksDialog),
                    ),
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace8,
          SingleChildScrollView(
            primary: false,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                horizontalWidthBox,
                ...feed.moods!
                    .map((e) => UiKitMessageCardWithIcon(
                          message: e.title,
                          icon: ImageWidget(link: e.logo),
                          layoutDirection: Axis.vertical,
                          onPressed: onMoodPressed == null ? null : () => onMoodPressed!(e.id),
                        ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing4))
                    .toList()
              ],
            ),
          ),
          SpacingFoundation.verticalSpace8,
        ],
        if (feed.places != null && (model.showPlaces ?? true)) ...[
          Text('You better check this out', style: themeTitleStyle).paddingSymmetric(horizontal: horizontalMargin),
          if (feed.filterChips != null && feed.filterChips!.isNotEmpty) ...[
            SpacingFoundation.verticalSpace8,
            SingleChildScrollView(
              primary: false,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  horizontalWidthBox,
                  context.gradientButton(
                    icon: ImageWidget(svgAsset: GraphicsFoundation.instance.svg.dice),
                    onPressed: onTagSortPressed == null ? null : () => onTagSortPressed!(''),
                  ),
                  SpacingFoundation.horizontalSpace8,
                  Wrap(
                    spacing: SpacingFoundation.verticalSpacing8,
                    children: feed.filterChips!
                        .map((e) => UiKitTitledFilterChip(
                              selected: feed.activeFilterChips?.map((e) => e.title).contains(e.title) ?? false,
                              title: e.title,
                              onPressed: onTagSortPressed == null ? () {} : () => onTagSortPressed!(e.title),
                              icon: e.iconPath,
                            ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing4))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
          SpacingFoundation.verticalSpace8,
          ...feed.places!.map((e) => PlacePreview(
                onTap: onPlacePressed,
                place: e,
                model: model,
              ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing8)),
          SpacingFoundation.bottomNavigationBarSpacing,
        ],
      ],
    ).paddingSymmetric(
      vertical: model.positionModel?.verticalMargin ?? 0,
    );
  }
}
