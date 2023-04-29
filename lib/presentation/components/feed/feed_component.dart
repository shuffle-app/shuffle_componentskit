import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedComponent extends StatelessWidget {
  final UiKitFeed feed;

  const FeedComponent({Key? key, required this.feed}) : super(key: key);

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
          if (feed.recommendedEvent != null) ...[
            AccentCard(
              title: feed.recommendedEvent!.title ?? '',
              additionalInfo:
                  feed.recommendedEvent!.descriptionItems?.first.description ??
                      '',
              accentMessage: 'Don\'t miss it',
              image: ImageWidget(
                rasterAsset: Assets.images.png.balloons,
                fit: BoxFit.cover,
              ),
            ),
            SpacingFoundation.verticalSpace8
          ],
          if (feed.moods != null) ...[
            Text('How’re you feeling tonight?',
                style: theme?.regularTextTheme.title1),
            SpacingFoundation.verticalSpace8,
            SingleChildScrollView(
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    child:  Row(
                        children: feed.moods!
                            .map((e) => Flexible(child: MessageCardWithIcon(
                                    message: e.title,
                                    icon: ImageWidget(link: e.logo),
                                    layoutDirection: Axis.vertical)
    ).paddingSymmetric(
                                    horizontal:
                                        SpacingFoundation.horizontalSpacing4))
                            .toList())),
            SpacingFoundation.verticalSpace8,
          ],
          if (feed.places != null) ...[
            Text('You better check this out',
                style: theme?.regularTextTheme.title1),
            SpacingFoundation.verticalSpace8,
            ...feed.places!.map((e) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiKitPhotoSlider(
                      media: e.media,
                      width: size.width,
                      height: 256,
                    ),
                    SpacingFoundation.verticalSpace4,
                    Text(e.title ?? '',
                        style: theme?.regularTextTheme.caption1),
                    SpacingFoundation.verticalSpace4,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: SpacingFoundation.horizontalSpacing8,
                        children: e.tags
                            .map((el) => UiKitTagWidget(
                                  title: el.title,
                                  icon: el.iconPath,
                                  showGradient: el.matching,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ).paddingSymmetric(
                    vertical: SpacingFoundation.verticalSpacing4)),
            SpacingFoundation.verticalSpace16,
          ],
        ]).paddingSymmetric(
        vertical: model.positionModel?.verticalMargin ?? 0,
        horizontal: model.positionModel?.horizontalMargin ?? 0);
  }
}
