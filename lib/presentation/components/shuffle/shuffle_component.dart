import 'dart:async';
import 'dart:ui';
import 'dart:developer';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ShuffleComponent extends StatefulWidget {
  final UiShuffleModel shuffle;
  final Function? onLike;
  final Function? onDislike;
  final Function? onFavorite;
  final Function? onCardTap;
  final VoidCallback? onEnd;
  final VoidCallback? onHowItWorksPoped;
  final List<String> favoriteTitles;

  const ShuffleComponent({Key? key,
    required this.shuffle,
    this.onLike,
    this.favoriteTitles = const [],
    this.onDislike,
    this.onHowItWorksPoped,
    this.onCardTap,
    this.onEnd,
    this.onFavorite})
      : super(key: key);

  @override
  State<ShuffleComponent> createState() => ShuffleComponentState();
}

class ShuffleComponentState extends State<ShuffleComponent> {
  late final ComponentShuffleModel model;
  final ValueNotifier<int> indexNotifier = ValueNotifier<int>(0);
  bool isEnded = false;
  late final Key backImageKey;
  Widget isEndedWidget = UiKitLastSwiperCard.fixed();

  // Color _backgroundColor = Colors.black12;
  final CardSwiperController controller = CardSwiperController();
  final animDuration = const Duration(milliseconds: 250);
  String lastAddedKey = '';
  FileInfo? lastFile;
  late Future<FileInfo?> currentFutureMayBeImage =
  CustomCacheManager.imageInstance.getFileFromCache(_getKey(widget.shuffle.items.first.imageLink ?? ''));

  @override
  void initState() {
    backImageKey = UniqueKey();
    final config =
        GlobalComponent
            .of(context)
            ?.globalConfiguration
            .appConfig
            .content ?? GlobalConfiguration().appConfig.content;
    model = ComponentShuffleModel.fromJson(config['shuffle']);
    unawaited(_getColor(widget.shuffle.items.first.imageLink ?? ''));

    super.initState();
  }

  _getKey(String imageUrl) {
    return imageUrl;
  }

  Future<void> _getColor(String imageLink) async {
    if (imageLink.isEmpty) return;

    final key = _getKey(imageLink);

    setState(() {
      currentFutureMayBeImage = CustomCacheManager.imageInstance.getFileFromCache(key);
      lastAddedKey = key;
    });
  }

  // _onEnd() {
  //   setState(() {
  //     isEnded = true;
  //   });
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final bodyAlignment = model.positionModel?.bodyAlignment;

    // log('here is rebuild', name: 'ShuffleComponent');

    return Stack(
      children: [
        FutureBuilder(
            future: currentFutureMayBeImage,
            builder: (context, snapshot) {
              Widget? child;
              if (snapshot.connectionState == ConnectionState.done) {
                // log('here is snapshot with ${snapshot.data?.file.path}', name: 'ShuffleComponent');
                if (snapshot.data != null ) {
                // if (snapshot.data != null && lastFile?.file.path != (snapshot.data as FileInfo).file.path) {
                  // WidgetsBinding.instance.addPostFrameCallback((_) =>
                  //     setState(() {
                        lastFile = snapshot.data as FileInfo;
                      // }));


                  child = ImageWidget(
                    link: ['bin', 'avif'].contains(lastFile!.file.path
                        .split('.')
                        .last)
                        ? lastAddedKey
                        : lastFile!.file.path,
                    fit: BoxFit.cover,
                    height: 1.sh,
                    width: 1.sw,
                  );
                }
                else {
                  log('here is snapshot with null', name: 'ShuffleComponent');
                  //waiting here the cache image network job to cache our file
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      currentFutureMayBeImage = CustomCacheManager.imageInstance.getFileFromCache(lastAddedKey);
                    });
                  });
                }
              }
              if (lastFile != null && child ==null) {
                child =
                    ImageWidget(
                      link: ['bin', 'avif'].contains(lastFile!
                          .file.path
                          .split('.')
                          .last)
                          ? lastAddedKey
                          : lastFile!.file.path,
                      fit: BoxFit.cover,
                      height: 1.sh,
                      width: 1.sw,
                    );
              }

              return AnimatedSwitcher(
                  key: backImageKey,
                  switchInCurve: Curves.easeInOut,
                  duration: animDuration,
                  child: child ?? const ColoredBox(
                    color: UiKitColors.darkNeutral100,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ));
            }),

        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(
            height: double.infinity,
            width: double.infinity,
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
                    // height: 50.h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      // fit: StackFit.expand,
                      children: [
                        Text('Try\nyourself', style: theme?.boldTextTheme.title1, textAlign: TextAlign.center),
                        if (widget.shuffle.showHowItWorks && model.content.title?[ContentItemType.hintDialog] != null)
                          HowItWorksWidget(
                              customOffset: Offset(0.35.sw, 25),
                              element: model.content.title![ContentItemType.hintDialog]!,
                              onPop: widget.onHowItWorksPoped),
                      ],
                    )).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing12),
                SizedBox(
                  height: 1.sh / 1.6,
                  width: 1.sw - 24,
                  child: Stack(fit: StackFit.passthrough, children: [
                    AnimatedScale(
                      scale: isEnded ? 1 : 0.3,
                      duration: animDuration,
                      child: isEndedWidget,
                    ),
                    if (widget.shuffle.items.isNotEmpty)
                      UiKitCardSwiper(
                        onEnd: widget.onEnd,
                        onSwipe: (previousIndex,
                            currentIndex,
                            direction,) {
                          if (currentIndex == null) return true;
                          indexNotifier.value = currentIndex;

                          _getColor(widget.shuffle.items[currentIndex].imageLink ?? '');

                          switch (direction) {
                            case CardSwiperDirection.bottom:
                              return true;
                            case CardSwiperDirection.top:
                            // if (widget.onFavorite != null && (model.showFavorite ?? true)) {
                            //   widget.onFavorite!(widget.shuffle.items[currentIndex].title);
                            // } else {
                            //   return false;
                            // }
                              return true;
                            case CardSwiperDirection.none:
                              return false;
                            case CardSwiperDirection.left:
                            // if (widget.onDislike != null) {
                            //   widget.onDislike!(widget.shuffle.items[currentIndex].title);
                            // } else {
                            //   return false;
                            // }
                              return true;
                            case CardSwiperDirection.right:
                            // if (widget.onLike != null) {
                            //   widget.onLike!(widget.shuffle.items[currentIndex].title);
                            // } else {
                            //   return false;
                            // }
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
                    opacity: isEnded || widget.shuffle.items.isEmpty ? 0 : 1,
                    duration: animDuration,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: () {
                        final svg = GraphicsFoundation.instance.svg;

                        return [
                          context.bouncingButton(
                            blurred: true,
                            small: true,
                            data: BaseUiKitButtonData(
                                onPressed: () =>
                                    widget.onDislike?.call(widget.shuffle.items[controller.state?.index ?? 0].title),
                                icon: ImageWidget(
                                  svgAsset: svg.heartBrokenFill,
                                  color: Colors.white,
                                )),
                          ),
                          SpacingFoundation.horizontalSpace24,
                          if (model.showFavorite ?? true)
                            context.bouncingButton(
                                blurred: true,
                                data: BaseUiKitButtonData(
                                  onPressed: () =>
                                      widget.onFavorite?.call(widget.shuffle.items[indexNotifier.value].title),
                                  icon: ValueListenableBuilder(
                                      valueListenable: indexNotifier,
                                      builder: (_, value, __) =>
                                          ImageWidget(
                                            svgAsset: widget.shuffle.items.isNotEmpty &&
                                                widget.favoriteTitles.contains(
                                                    widget.shuffle.items[value % widget.shuffle.items.length].title)
                                                ? svg.starFill
                                                : svg.starOutline,
                                            color: Colors.white,
                                          )),
                                )),
                          SpacingFoundation.horizontalSpace24,
                          context.bouncingButton(
                            blurred: true,
                            small: true,
                            data: BaseUiKitButtonData(
                                onPressed: () =>
                                    widget.onLike?.call(widget.shuffle.items[controller.state?.index ?? 0].title),
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
