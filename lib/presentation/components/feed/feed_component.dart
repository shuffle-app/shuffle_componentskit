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
      {Key? key,
      required this.feed,
      this.onMoodPressed,
      this.onEventPressed,
      this.onPlacePressed,
      this.onTagSortPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentFeedModel model =
        ComponentFeedModel.fromJson(config['feed']);

    final theme = context.uiKitTheme;
    final size = MediaQuery.of(context).size;
    final horizontalMargin = model.positionModel?.horizontalMargin ?? 0;
    final bodyAlignment = model.positionModel?.bodyAlignment;

    return Column(
        mainAxisAlignment:
            bodyAlignment.mainAxisAlignment,
        crossAxisAlignment:
            bodyAlignment.crossAxisAlignment,
        children: [
          if (feed.recommendedEvent != null &&
              (model.showDailyRecomendation ?? true)) ...[
            InkWell(
                    onTap: onEventPressed == null
                        ? null
                        : () => onEventPressed!(feed.recommendedEvent?.id),
                    child: SafeArea(
                        child: UiKitAccentCard(
                      title: feed.recommendedEvent!.title ?? '',
                      additionalInfo: feed.recommendedEvent!.descriptionItems
                              ?.first.description ??
                          '',
                      accentMessage: 'Don\'t miss it',
                      image: ImageWidget(
                        link: feed.recommendedEvent?.media?.first.link,
                        fit: BoxFit.fill,
                        width: double.infinity,
                      ),
                    )))
                .paddingSymmetric(
                    horizontal: horizontalMargin),
            SpacingFoundation.verticalSpace8
          ],
          if (feed.moods != null && (model.showFeelings ?? true)) ...[
            Stack(children: [
              Text('How’re you feeling tonight?',
                  style: theme?.boldTextTheme.title1),
              Transform.translate(
                  offset: Offset(size.width / 2, 30),
                  child: RotatableWidget(
                    startDelay: const Duration(seconds: 10),
                    child: UiKitBlurredQuestionChip(
                      label: 'How it works',
                      onTap: () => showUiKitFullScreenAlertDialog(context,
                          child: _howItWorksDialog),
                    ),
                  ))
            ]).paddingSymmetric(
                horizontal: horizontalMargin),
            SpacingFoundation.verticalSpace8,
            SingleChildScrollView(
                primary: false,
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  (horizontalMargin -
                          SpacingFoundation.horizontalSpacing4)
                      .widthBox,
                  ...feed.moods!
                      .map((e) => InkWell(
                              onTap: onMoodPressed == null
                                  ? null
                                  : () => onMoodPressed!(e.id),
                              child: UiKitMessageCardWithIcon(
                                  message: e.title,
                                  icon: ImageWidget(link: e.logo),
                                  layoutDirection: Axis.vertical))
                          .paddingSymmetric(
                              horizontal: SpacingFoundation.horizontalSpacing4))
                      .toList()
                ])),
            SpacingFoundation.verticalSpace8,
          ],
          if (feed.places != null && (model.showPlaces ?? true)) ...[
            Text('You better check this out',
                    style: theme?.boldTextTheme.title1)
                .paddingSymmetric(
                    horizontal: horizontalMargin),
            if (feed.filterChips != null && feed.filterChips!.isNotEmpty) ...[
              SpacingFoundation.verticalSpace8,
              SingleChildScrollView(
                  primary: false,
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    (horizontalMargin -
                            SpacingFoundation.horizontalSpacing4)
                        .widthBox,
                    context.button(
                        icon: ImageWidget(
                            svgAsset: GraphicsFoundation.instance.svg.dice),
                        onPressed: onTagSortPressed == null
                            ? null
                            : () => onTagSortPressed!(''),
                        gradient: true),
                    ...feed.filterChips!
                        .map((e) => context
                            .button(
                              // small: true,
                              text: e.title,
                              onPressed: onTagSortPressed == null
                                  ? null
                                  : () => onTagSortPressed!(e.title),
                              icon: ImageWidget(
                                link: e.iconPath,
                                color: ColorsFoundation.darkNeutral900,
                              ),
                            )
                            .paddingSymmetric(
                                horizontal:
                                    SpacingFoundation.horizontalSpacing4))
                        .toList()
                  ])),
            ],
            SpacingFoundation.verticalSpace8,
            ...feed.places!.map((e) => PlacePreview(
                  onTap: onPlacePressed,
                  place: e,
                  model: model,
                ).paddingSymmetric(
                    vertical: SpacingFoundation.verticalSpacing4)),
            SpacingFoundation.verticalSpace16,
          ],
        ]).paddingSymmetric(
      vertical: model.positionModel?.verticalMargin ?? 0,
    );
  }

  _howItWorksDialog(context, textStyle) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Depending on...',
            style: textStyle,
          ),
          SpacingFoundation.verticalSpace8,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: UiKitIconHintCard(
                  icon: ImageWidget(
                    rasterAsset: GraphicsFoundation.instance.png.location,
                  ),
                  hint: 'your location',
                ),
              ),
              SpacingFoundation.horizontalSpace16,
              Expanded(
                child: UiKitIconHintCard(
                  icon: ImageWidget(
                    rasterAsset: GraphicsFoundation.instance.png.target,
                  ),
                  hint: 'your interests',
                ),
              ),
            ],
          ),
          SpacingFoundation.verticalSpace8,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: UiKitIconHintCard(
                  icon: ImageWidget(
                    rasterAsset: GraphicsFoundation.instance.png.cloudy,
                  ),
                  hint: 'weather around',
                ),
              ),
              SpacingFoundation.horizontalSpace16,
              Expanded(
                child: UiKitIconHintCard(
                  icon: ImageWidget(
                    rasterAsset: GraphicsFoundation.instance.png.mood,
                  ),
                  hint: 'and other 14 scales',
                ),
              ),
            ],
          ),
          SpacingFoundation.verticalSpace8,
          Text(
            'you get exactly what you need',
            style: textStyle,
          ),
          SpacingFoundation.verticalSpace8,
          GeneralPurposeButton(
            text: 'OKAY, COOL!',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
}
