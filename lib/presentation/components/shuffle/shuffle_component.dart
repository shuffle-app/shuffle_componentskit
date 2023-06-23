import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/src/result/file_info.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ShuffleComponent extends StatefulWidget {
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
  State<ShuffleComponent> createState() => _ShuffleComponentState();
}

class _ShuffleComponentState extends State<ShuffleComponent> {
  late final ComponentShuffleModel model;
  bool isEnded = false;
  Color _backgroundColor = Colors.black12;
  final CardSwiperController controller = CardSwiperController();
  final animDuration = const Duration(milliseconds: 250);

  @override
  void initState() {
    final config =
        GlobalComponent
            .of(context)
            ?.globalConfiguration
            .appConfig
            .content ??
            GlobalConfiguration().appConfig.content;
    model = ComponentShuffleModel.fromJson(config['shuffle']);
    unawaited(_getColor(widget.shuffle.items.first.imageLink ?? ''));

    super.initState();
  }

  Future<void> _getColor(String imageLink) async {
    if (imageLink.isEmpty) return;
    late final PaletteGenerator paletteGenerator;
    if (imageLink.substring(0, 4) == 'http') {
      final file = await CustomCacheManager.instance
          .getFileStream(imageLink)
          .firstWhere((element) => element is FileInfo);
      paletteGenerator = await PaletteGenerator.fromImageProvider(
          Image
              .file((file as FileInfo).file)
              .image);
    } else {
      paletteGenerator = await PaletteGenerator.fromImageProvider(Image
          .asset(
        imageLink,
        package: 'shuffle_uikit',
      )
          .image);
    }
    setState(() {
      final dominantColor =
          paletteGenerator.dominantColor?.color ?? Colors.black12;

      _backgroundColor =
          HSLColor.fromColor(dominantColor).withLightness(0.45).toColor();
      print(_backgroundColor);
    });
  }

  _onEnd() {
    setState(() {
      isEnded = true;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final bodyAlignment = model.positionModel?.bodyAlignment;

    return Stack(
      children: [
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 0.6.sh,
            width: 0.7.sw,
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadiusFoundation.max,
              boxShadow: [
                BoxShadow(
                  offset: Offset.zero,
                  blurRadius: 50,
                  color: _backgroundColor,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
          ),
        ),
        SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: bodyAlignment.mainAxisAlignment,
              crossAxisAlignment: bodyAlignment.crossAxisAlignment,
              children: [
                Text('Try\nyourself',
                    style: theme?.boldTextTheme.title1,
                    textAlign: TextAlign.center)
                    .paddingSymmetric(
                    vertical: SpacingFoundation.verticalSpacing12),
                SizedBox(
                  height: 1.sh / 1.6,
                  width: 1.sw - 24,
                  child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        AnimatedScale(
                          scale: isEnded ? 1 : 0.3,
                          duration: animDuration,
                          child: UiKitLastSwiperCard(),
                        ),
                        if(!isEnded)
                          UiKitCardSwiper(
                          // onEnd: _onEnd,
                          onSwipe: (previousIndex,
                              currentIndex,
                              direction,) {
                            if (currentIndex == null) return true;
                            if (direction != CardSwiperDirection.bottom) {
                              _getColor(widget.shuffle.items[currentIndex ?? 0]
                                  .imageLink ??
                                  '');
                            }

                            switch (direction) {
                              case CardSwiperDirection.bottom:
                                return false;
                              case CardSwiperDirection.top:
                                if (widget.onFavorite != null &&
                                    (model.showFavorite ?? true)) {
                                  widget.onFavorite!(widget
                                      .shuffle.items[currentIndex].title);
                                } else {
                                  return false;
                                }
                                return true;
                              case CardSwiperDirection.none:
                                return false;
                              case CardSwiperDirection.left:
                                if (widget.onDislike != null) {
                                  widget.onDislike!(widget
                                      .shuffle.items[currentIndex].title);
                                } else {
                                  return false;
                                }
                                return true;
                              case CardSwiperDirection.right:
                                if (widget.onLike != null) {
                                  widget.onLike!(widget
                                      .shuffle.items[currentIndex].title);
                                } else {
                                  return false;
                                }
                                return true;
                            }
                          },
                          cards: widget.shuffle.items,
                          controller: controller,
                        )
                      ]),
                ),
                SpacingFoundation.verticalSpace4,
                AnimatedOpacity(
                    opacity: isEnded ? 0 : 1,
                    duration: animDuration,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: () {
                        final svg = GraphicsFoundation.instance.svg;

                        return [
                          context.smallButton(
                            blurred: true,
                            data: BaseUiKitButtonData(
                                onPressed: () => controller.swipeLeft(),
                                icon: ImageWidget(
                                  svgAsset: svg.heartBrokenFill,
                                  color: Colors.white,
                                )),
                          ),
                          SpacingFoundation.horizontalSpace24,
                          if (model.showFavorite ?? true)
                            context.button(
                              blurred: true,
                              data: BaseUiKitButtonData(
                                  onPressed: () => controller.swipeTop(),
                                  icon: ImageWidget(
                                    svgAsset: svg.starOutline,
                                    color: Colors.white,
                                  )),
                            ),
                          SpacingFoundation.horizontalSpace24,
                          context.smallButton(
                            blurred: true,
                            data: BaseUiKitButtonData(
                                onPressed: () => controller.swipeRight(),
                                icon: ImageWidget(
                                  svgAsset: svg.heartFill,
                                  color: Colors.white,
                                )),
                          ),
                        ];
                      }(),
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }
}
