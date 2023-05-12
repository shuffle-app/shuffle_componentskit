import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_cache_manager/src/result/file_info.dart';
import 'package:palette_generator/palette_generator.dart';

class ShuffleComponent extends StatefulWidget {
  final UiShuffleModel shuffle;
  final Function? onLike;
  final Function? onDislike;
  final Function? onFavorite;

  const ShuffleComponent(
      {Key? key,
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
  Color _backgroundColor = Colors.black12;
  final CardSwiperController controller = CardSwiperController();

  @override
  void initState() {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
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
          Image.file((file as FileInfo).file).image);
    } else {
      paletteGenerator = await PaletteGenerator.fromImageProvider(Image.asset(
        imageLink,
        package: 'shuffle_uikit',
      ).image);
    }
    setState(() {
      _backgroundColor =
          paletteGenerator.dominantColor?.color ?? Colors.black12;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final size = MediaQuery.of(context).size;
    final bodyAlignment = model.positionModel?.bodyAlignment;

    return Stack(children: [
      Transform.scale(
          scale: 2,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: RadialGradient(radius: 1, colors: [
              _backgroundColor,
              theme?.customAppBapTheme.backgroundColor ??
                  ColorsFoundation.darkNeutral100
            ])),
          )),
      SafeArea(
          child: Column(
        mainAxisAlignment: bodyAlignment.mainAxisAlignment,
        crossAxisAlignment: bodyAlignment.crossAxisAlignment,
        children: [
          Text('Try this yourself', style: theme?.boldTextTheme.title1)
              .paddingSymmetric(vertical: SpacingFoundation.verticalSpacing4),
          SizedBox(
              height: size.height / 1.5,
              width: double.infinity,
              child: UiKitCardSwiper(
                onSwipe: (
                  previousIndex,
                  currentIndex,
                  direction,
                ) {
                  if (direction != CardSwiperDirection.bottom) {
                    _getColor(
                        widget.shuffle.items[currentIndex ?? 0].imageLink ??
                            '');
                  }

                  switch (direction) {
                    case CardSwiperDirection.bottom:
                      return false;
                    case CardSwiperDirection.top:
                      if (widget.onFavorite != null &&
                          (model.showFavorite ?? true)) {
                        widget.onFavorite!(
                            widget.shuffle.items[currentIndex!].title);
                      } else {
                        return false;
                      }
                      return true;
                    case CardSwiperDirection.none:
                      return false;
                    case CardSwiperDirection.left:
                      if (widget.onDislike != null) {
                        widget.onDislike!(
                            widget.shuffle.items[currentIndex!].title);
                      } else {
                        return false;
                      }
                      return true;
                    case CardSwiperDirection.right:
                      if (widget.onLike != null) {
                        widget
                            .onLike!(widget.shuffle.items[currentIndex!].title);
                      } else {
                        return false;
                      }
                      return true;
                  }
                },
                cards: widget.shuffle.items,
                controller: controller,
              )),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: () {
              final svg = GraphicsFoundation.instance.svg;

              return [
                context.smallButton(
                  blurred: true,
                  onPressed: () => controller.swipeLeft(),
                  icon: ImageWidget(
                    svgAsset: svg.heartBrokenFill,
                    color: Colors.white,
                  ),
                ),
                if (model.showFavorite ?? true)
                  context.button(
                    blurred: true,
                    onPressed: () => controller.swipeTop(),
                    icon: ImageWidget(
                      svgAsset: svg.star,
                      color: Colors.white,
                    ),
                  ),
                context.smallButton(
                  blurred: true,
                  onPressed: () => controller.swipeRight(),
                  icon: ImageWidget(
                    svgAsset: svg.heartFill,
                    color: Colors.white,
                  ),
                ),
              ];
            }(),
          ),
        ],
      ))
    ]);
  }
}
