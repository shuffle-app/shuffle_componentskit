import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/common/place_preview.dart';
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

    return Column(
        mainAxisAlignment:
            (model.positionModel?.bodyAlignment).mainAxisAlignment,
        crossAxisAlignment:
            (model.positionModel?.bodyAlignment).crossAxisAlignment,
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
                    horizontal: model.positionModel?.horizontalMargin ?? 0),
            SpacingFoundation.verticalSpace8
          ],
          if (feed.moods != null && (model.showFeelings ?? true)) ...[
            Stack(children: [
              Text('How’re you feeling tonight?',
                  style: theme?.boldTextTheme.title1),
              Transform.translate(
                  offset: Offset(size.width / 2, 30),
                  child: const InkWell(
                    child: UiKitBlurredQuestionChip(
                      label: 'How it works',
                    ),
                  ))
            ]).paddingSymmetric(
                horizontal: model.positionModel?.horizontalMargin ?? 0),
            SpacingFoundation.verticalSpace8,
            SingleChildScrollView(
                primary: false,
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  ((model.positionModel?.horizontalMargin ?? 0) -
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
                    horizontal: model.positionModel?.horizontalMargin ?? 0),
            if (feed.filterChips != null && feed.filterChips!.isNotEmpty) ...[
              SpacingFoundation.verticalSpace8,
              SingleChildScrollView(
                  primary: false,
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    ((model.positionModel?.horizontalMargin ?? 0) -
                            SpacingFoundation.horizontalSpacing4)
                        .widthBox,
                    context.button(
                        icon: ImageWidget(
                            svgAsset: GraphicsFoundation.instance.svg.dice),
                        onPressed: onTagSortPressed == null
                            ? null
                            : ()=>onTagSortPressed!(''),
                        onlyIcon: true,
                        gradient: true),
                    ...feed.filterChips!
                        .map((e) => context
                            .button(
                              // small: true,
                              text: e.title,
                              onPressed: onTagSortPressed == null
                                  ? null
                                  : () => onTagSortPressed!(e.title),
                              icon: ImageWidget(link: e.iconPath,color: ColorsFoundation.darkNeutral900,),
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
}
