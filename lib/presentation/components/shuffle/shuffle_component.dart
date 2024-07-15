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
  final List<int> favoriteIds;
  final ValueNotifier<int> indexNotifier;
  final ValueNotifier<String> backgroundImageNotifier;

  const ShuffleComponent({
    super.key,
    required this.shuffle,
    required this.configModel,
    required this.indexNotifier,
    required this.backgroundImageNotifier,
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
    final bodyAlignment = configModel.positionModel?.bodyAlignment;

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
              mainAxisAlignment: bodyAlignment.mainAxisAlignment,
              crossAxisAlignment: bodyAlignment.crossAxisAlignment,
              children: [
                SizedBox(height: MediaQuery.viewPaddingOf(context).top),
                RepaintBoundary(
                  child: SizedBox(
                    width: double.infinity,
                    child: TitleWithHowItWorks(
                      title: S.of(context).TryYourself,
                      textStyle: theme?.boldTextTheme.title1.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                      shouldShow:
                          shuffle.showHowItWorks && configModel.content.title?[ContentItemType.hintDialog] != null,
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
                          size: Size(1.sw, 1.sh / 1.6),
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
                RepaintBoundary(
                  child: Row(
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
                      if (configModel.showFavorite ?? true)
                        context.bouncingButton(
                          blurred: true,
                          data: BaseUiKitButtonData(
                            onPressed: () {
                              FeedbackIsolate.instance.addEvent(FeedbackIsolateHaptics(
                                intensities: [140, 150, 170, 200],
                                pattern: [20, 15, 10, 5],
                              ));
                              onFavorite?.call(shuffle.items[indexNotifier.value].title);
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
