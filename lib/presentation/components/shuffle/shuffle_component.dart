import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';



class ShuffleComponent extends StatelessWidget {
  final UiShuffleModel shuffle;
  final Function? onLike;
  final Function? onDislike;
  final Function? onFavorite;

  const ShuffleComponent({Key? key,
    required this.shuffle,
    this.onLike,
    this.onDislike,
    this.onFavorite})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent
            .of(context)
            ?.globalConfiguration
            .appConfig
            .content ??
            GlobalConfiguration().appConfig.content;
    final ComponentShuffleModel model =
    ComponentShuffleModel.fromJson(config['shuffle']);
    final theme = context.uiKitTheme;
    final size = MediaQuery
        .of(context)
        .size;

    final CardSwiperController controller = CardSwiperController();

    return Column(
      mainAxisAlignment: (model.positionModel?.bodyAlignment).mainAxisAlignment,
      crossAxisAlignment:
      (model.positionModel?.bodyAlignment).crossAxisAlignment,
      children: [
        Text('Try this yourself', style: theme?.boldTextTheme.title1),
        UiKitCardSwiper(
          onSwipe: (previousIndex,
              currentIndex,
              direction,) {
            switch (direction) {
              case CardSwiperDirection.bottom:
                return false;
              case CardSwiperDirection.top:
                if (onFavorite != null && (model.showFavorite ?? true)) {
                  onFavorite!(shuffle.items[currentIndex!]);
                } else {
                  return false;
                }
                break;
              case CardSwiperDirection.none:
                return false;
              case CardSwiperDirection.left:
                if (onDislike != null) {
                  onDislike!(shuffle.items[currentIndex!]);
                } else {
                  return false;
                }
                break;
              case CardSwiperDirection.right:
                if (onLike != null) {
                  onLike!(shuffle.items[currentIndex!]);
                } else {
                  return false;
                }
                break;
            }
            return true;
          },
          cards: shuffle.items,
          controller: controller,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            context.button(
              blurred: true,
              small: true,
              onPressed: () =>
                  controller.swipeLeft()
              ,
              icon: ImageWidget(
                svgAsset: GraphicsFoundation.instance.svg.heartBrokenFill,
                color: Colors.white,
              ),
            ),
            if(model.showFavorite ?? true)
              context.button(
                blurred: true,
                onPressed: () => controller.swipeTop(),
                icon: ImageWidget(
                  svgAsset: GraphicsFoundation.instance.svg.star,
                  color: Colors.white,
                ),
                small: false,
              ),
            context.button(
              blurred: true,
              small: true,
              onPressed: () => controller.swipeRight(),
              icon: ImageWidget(
                svgAsset: GraphicsFoundation.instance.svg.heartFill,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
