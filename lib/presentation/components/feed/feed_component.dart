import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedComponent extends StatelessWidget {
  final UiKitFeed feed;
  final Function? onMoodPressed;
  final Function? onEventPressed;
  final Function? onPlacePressed;

  const FeedComponent(
      {Key? key,
      required this.feed,
      this.onMoodPressed,
      this.onEventPressed,
      this.onPlacePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final FeedModel model = FeedModel.fromJson(config['feed']);

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
                        child: AccentCard(
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
            Row(children: [
              Text('How’re you feeling tonight?',
                  style: theme?.regularTextTheme.title1),
              Transform.translate(
                  offset: Offset(-20, 25),
                  child: InkWell(
                    child: BlurredQuestionChip(
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
                              child: MessageCardWithIcon(
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
                    style: theme?.regularTextTheme.title1)
                .paddingSymmetric(
                    horizontal: model.positionModel?.horizontalMargin ?? 0),
            SpacingFoundation.verticalSpace8,
            ...feed.places!.map((e) => InkWell(
                    onTap: onPlacePressed == null
                        ? null
                        : () => onPlacePressed!(e.id),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UiKitPhotoSlider(
                          media: e.media,
                          width: size.width -
                              (model.positionModel?.horizontalMargin ?? 0) * 2,
                          height: 200,
                        ),
                        SpacingFoundation.verticalSpace4,
                        Text(e.title ?? '',
                                style: theme?.regularTextTheme.caption1)
                            .paddingSymmetric(
                                horizontal:
                                    model.positionModel?.horizontalMargin ?? 0),
                        SpacingFoundation.verticalSpace4,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: SpacingFoundation.horizontalSpacing8,
                            children: [
                              (model.positionModel?.horizontalMargin ?? 0)
                                  .widthBox,
                              ...e.tags
                                  .map((el) => UiKitTagWidget(
                                        title: el.title,
                                        icon: el.iconPath,
                                        showGradient: el.matching,
                                      ))
                                  .toList()
                            ],
                          ),
                        ),
                      ],
                    ))
                .paddingSymmetric(
                    vertical: SpacingFoundation.verticalSpacing4)),
            SpacingFoundation.verticalSpace16,
          ],
        ]).paddingSymmetric(
      vertical: model.positionModel?.verticalMargin ?? 0,
    );
  }
}
