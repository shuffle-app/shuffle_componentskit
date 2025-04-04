import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ShuffleComponent extends StatelessWidget {
  final UiShuffleModel shuffle;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;
  final ValueChanged<int>? onFavorite;
  final ValueChanged<int>? onCardTap;
  final VoidCallback? onEnd;
  final VoidCallback? onHowItWorksPoped;
  final List<int> favoriteIds;
  final ValueNotifier<int> indexNotifier;
  final ValueNotifier<String> backgroundImageNotifier;
  final bool allowedToSwipe;
  final CardSwiperController controller;

  const ShuffleComponent({
    super.key,
    required this.shuffle,
    required this.indexNotifier,
    required this.backgroundImageNotifier,
    required this.controller,
    this.allowedToSwipe = true,
    this.onLike,
    this.favoriteIds = const [],
    this.onDislike,
    this.onHowItWorksPoped,
    this.onCardTap,
    this.onEnd,
    this.onFavorite,
  });

  final animDuration = const Duration(milliseconds: 350);

  bool get isEnded => indexNotifier.value < 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

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
                child: value.isNotEmpty
                    ? ImageWidget(
                        key: ValueKey(value),
                        link: value,
                        fit: BoxFit.cover,
                        lowerQuality: true,
                        height: 1.sh,
                        width: 1.sw,
                      )
                    : ColoredBox(color: theme!.colorScheme.primary),
              );
            },
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 23, sigmaX: 23),
          child: SizedBox(
            height: 1.sh,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.viewPaddingOf(context).top),
                SizedBox(
                  width: double.infinity,
                  child: TitleWithHowItWorks(
                    title: S.of(context).TryYourself,
                    textStyle: theme?.boldTextTheme.title1.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                    shouldShow: shuffle.showHowItWorks,
                    howItWorksWidget: HowItWorksWidget(
                      title: S.of(context).ShuffleHiwTitle,
                      subtitle: S.of(context).ShuffleHiwSubtitle,
                      hintTiles: [
                        HintCardUiModel(
                          title: S.of(context).ShuffleHiwHint(0),
                          imageUrl: GraphicsFoundation.instance.png.shuffleAny.path,
                        ),
                        HintCardUiModel(
                          title: S.of(context).ShuffleHiwHint(1),
                          imageUrl: GraphicsFoundation.instance.png.swipeProperties.path,
                        ),
                        HintCardUiModel(
                          title: S.of(context).ShuffleHiwHint(2),
                          imageUrl: GraphicsFoundation.instance.png.likeDislike.path,
                        ),
                        HintCardUiModel(
                          title: S.of(context).ShuffleHiwHint(3),
                          imageUrl: GraphicsFoundation.instance.png.teach.path,
                        ),
                      ],
                      onPop: onHowItWorksPoped,
                    ),
                  ),
                ),
                SpacingFoundation.verticalSpace12,
                SizedBox(
                  height: 1.sh / 1.6,
                  width: 1.sw,
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
                                ? Shimmer.fromColors(
                                    direction: ShimmerDirection.ltr,
                                    baseColor: Colors.white,
                                    highlightColor: ColorsFoundation.gradientGreyLight3,
                                    period: const Duration(milliseconds: 1000),
                                    child: UiKitLastSwiperCard.fixed(),
                                  )
                                : const SizedBox(),
                          );
                        },
                      ),
                      if (shuffle.items.isNotEmpty)
                        UiKitCardSwiper(
                          controller: controller,
                          size: Size(1.sw, 1.sh / 1.6),
                          likeController: shuffle.likeController,
                          dislikeController: shuffle.dislikeController,
                          onEnd: onEnd,
                          onSwipe: (
                            previousIndex,
                            currentIndex,
                            direction,
                          ) {
                            if (currentIndex == null) return allowedToSwipe;
                            indexNotifier.value = currentIndex;

                            switch (direction) {
                              case CardSwiperDirection.bottom:
                                return allowedToSwipe;
                              case CardSwiperDirection.top:
                                // if (onFavorite != null && (configModel.showFavorite ?? true)) {
                                //   onFavorite!(shuffle.items[currentIndex].title);
                                // } else {
                                //   return false;
                                // }
                                return allowedToSwipe;
                              case CardSwiperDirection.none:
                                return false;
                              case CardSwiperDirection.left:
                                // if (onDislike != null) {
                                //   onDislike!(shuffle.items[currentIndex].title);
                                // } else {
                                //   return false;
                                // }
                                return allowedToSwipe;
                              case CardSwiperDirection.right:
                                // if (onLike != null) {
                                //   onLike!(shuffle.items[currentIndex].title);
                                // } else {
                                //   return false;
                                // }
                                return allowedToSwipe;
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
                  children: [
                    context.bouncingButton(
                      blurred: true,
                      small: true,
                      data: BaseUiKitButtonData(
                        onPressed: () {
                          shuffle.dislikeController.forward(from: 0);
                          FeedbackIsolate.instance.addEvent(FeedbackIsolateHaptics(
                            intensities: [170, 200],
                            pattern: [10, 5],
                          ));
                          onDislike?.call();
                        },
                        iconInfo: BaseUiKitButtonIconData(
                          iconData: ShuffleUiKitIcons.heartbrokenfill,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SpacingFoundation.horizontalSpace24,
                    context.bouncingButton(
                      blurred: true,
                      data: BaseUiKitButtonData(
                        onPressed: () {
                          FeedbackIsolate.instance.addEvent(FeedbackIsolateHaptics(
                            intensities: [140, 150, 170, 200],
                            pattern: [20, 15, 10, 5],
                          ));
                          onFavorite?.call(shuffle.items[indexNotifier.value].id);
                        },
                        iconWidget: ValueListenableBuilder(
                          valueListenable: indexNotifier,
                          builder: (_, value, __) {
                            return ImageWidget(
                              iconData: shuffle.items.isNotEmpty &&
                                      favoriteIds.contains(shuffle.items[value % shuffle.items.length].id)
                                  ? ShuffleUiKitIcons.starfill
                                  : ShuffleUiKitIcons.staroutline,
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
                          FeedbackIsolate.instance.addEvent(FeedbackIsolateHaptics(
                            intensities: [170, 200],
                            pattern: [10, 5],
                          ));
                          shuffle.likeController.forward(from: 0);
                        },
                        iconInfo: BaseUiKitButtonIconData(
                          iconData: ShuffleUiKitIcons.heartfill,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SpacingFoundation.bottomNavigationBarSpacing,
              ],
            ),
          ),
        )
      ],
    );
  }
}
