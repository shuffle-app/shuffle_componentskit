import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ShuffleComponent extends StatelessWidget {
  final UiShuffleModel shuffle;
  final ComponentShuffleModel configModel;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;
  final Function? onFavorite;
  final Function? onCardTap;
  final VoidCallback? onEnd;
  final VoidCallback? onHowItWorksPoped;
  final List<String> favoriteTitles;
  final ValueNotifier<int> indexNotifier;
  final ValueNotifier<String> backgroundImageNotifier;

  const ShuffleComponent({
    Key? key,
    required this.shuffle,
    required this.configModel,
    required this.indexNotifier,
    required this.backgroundImageNotifier,
    this.onLike,
    this.favoriteTitles = const [],
    this.onDislike,
    this.onHowItWorksPoped,
    this.onCardTap,
    this.onEnd,
    this.onFavorite,
  }) : super(key: key);

  final animDuration = const Duration(milliseconds: 250);

  bool get isEnded => indexNotifier.value < 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final bodyAlignment = configModel.positionModel?.bodyAlignment;

    // log('here is rebuild', name: 'ShuffleComponent');

    return Stack(
      children: [
        SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: AnimatedBuilder(
            animation: backgroundImageNotifier,
            builder: (context, child) {
              final value = backgroundImageNotifier.value;

              return AnimatedSwitcher(
                duration: animDuration,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: ImageWidget(
                  key: ValueKey(value),
                  link: value,
                  fit: BoxFit.cover,
                  lowerQuality: true,
                  height: 1.sh,
                  width: 1.sw,
                ),
              );
            },
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 100,
            sigmaY: 100,
          ),
          child: Container(
            width: 1.sw,
            height: 1.sh,
            color: Colors.black.withOpacity(0.35),
          ),
        ),
        SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: bodyAlignment.mainAxisAlignment,
              crossAxisAlignment: bodyAlignment.crossAxisAlignment,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    // fit: StackFit.expand,
                    children: [
                      Text(S.of(context).TryYourself, style: theme?.boldTextTheme.title1, textAlign: TextAlign.center),
                      if (shuffle.showHowItWorks && configModel.content.title?[ContentItemType.hintDialog] != null)
                        HowItWorksWidget(
                            customOffset: Offset(0.35.sw, 25),
                            element: configModel.content.title![ContentItemType.hintDialog]!,
                            onPop: onHowItWorksPoped),
                    ],
                  ),
                ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing12),
                SizedBox(
                  height: 1.sh / 1.6,
                  width: 1.sw - 24,
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      ValueListenableBuilder(
                          valueListenable: indexNotifier,
                          builder: (context, value, child) {
                            final ended = value < 0;

                            return AnimatedScale(
                              scale: ended ? 1 : 0,
                              duration: animDuration,
                              child: ended
                                  ? Shimmer(
                                      gradient: GradientFoundation.greyGradient,
                                      child: UiKitLastSwiperCard.fixed(),
                                    )
                                  : const SizedBox(),
                            );
                          }),
                      if (shuffle.items.isNotEmpty)
                        UiKitCardSwiper(
                          size: Size(1.sw - 24, 1.sh / 1.6),
                          likeController: shuffle.likeController,
                          dislikeController: shuffle.dislikeController,
                          onEnd: onEnd,
                          onSwipe: (
                            previousIndex,
                            currentIndex,
                            direction,
                          ) {
                            if (currentIndex == null) return true;
                            indexNotifier.value = currentIndex;

                            switch (direction) {
                              case CardSwiperDirection.bottom:
                                return true;
                              case CardSwiperDirection.top:
                                // if (onFavorite != null && (configModel.showFavorite ?? true)) {
                                //   onFavorite!(shuffle.items[currentIndex].title);
                                // } else {
                                //   return false;
                                // }
                                return true;
                              case CardSwiperDirection.none:
                                return false;
                              case CardSwiperDirection.left:
                                // if (onDislike != null) {
                                //   onDislike!(shuffle.items[currentIndex].title);
                                // } else {
                                //   return false;
                                // }
                                return true;
                              case CardSwiperDirection.right:
                                // if (onLike != null) {
                                //   onLike!(shuffle.items[currentIndex].title);
                                // } else {
                                //   return false;
                                // }
                                return true;
                            }
                          },
                          cards: shuffle.items,
                        )
                    ],
                  ),
                ),
                SpacingFoundation.verticalSpace4,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: () {
                    final svg = GraphicsFoundation.instance.svg;

                    return [
                      context.bouncingButton(
                        blurred: true,
                        small: true,
                        data: BaseUiKitButtonData(
                          onPressed: () {
                            shuffle.dislikeController.forward(from: 0);
                            onDislike?.call();
                          },
                          icon: ImageWidget(
                            svgAsset: svg.heartBrokenFill,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SpacingFoundation.horizontalSpace24,
                      if (configModel.showFavorite ?? true)
                        context.bouncingButton(
                          blurred: true,
                          data: BaseUiKitButtonData(
                            onPressed: () => onFavorite?.call(shuffle.items[indexNotifier.value].title),
                            icon: ValueListenableBuilder(
                              valueListenable: indexNotifier,
                              builder: (_, value, __) {
                                return ImageWidget(
                                  svgAsset: shuffle.items.isNotEmpty &&
                                          favoriteTitles.contains(shuffle.items[value % shuffle.items.length].title)
                                      ? svg.starFill
                                      : svg.starOutline,
                                  color: Colors.white,
                                );
                              },
                            ),
                          ),
                        ),
                      SpacingFoundation.horizontalSpace24,
                      context.bouncingButton(
                        blurred: true,
                        small: true,
                        data: BaseUiKitButtonData(
                          onPressed: () {
                            shuffle.likeController.forward(from: 0);
                          },
                          icon: ImageWidget(
                            svgAsset: svg.heartFill,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ];
                  }(),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
