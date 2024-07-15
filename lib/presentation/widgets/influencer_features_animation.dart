import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class InfluencerFeaturesAnimation extends StatefulWidget {
  const InfluencerFeaturesAnimation({super.key});

  @override
  State<InfluencerFeaturesAnimation> createState() => _InfluencerFeaturesAnimationState();
}

class _InfluencerFeaturesAnimationState extends State<InfluencerFeaturesAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // CrossFadeState crossFadeState = CrossFadeState.showFirst;

  final List<WidgetBuilder> _features = [
    (_) => UserTileSpecialityAnimation(
          key: UniqueKey(),
        ),
    (_) => ProfileCardAnimated(
          key: UniqueKey(),
        ),
    (_) => UiKitInfluencerAudioMessagesDemo(
          key: UniqueKey(),
        ),
    (_) => _VideoWrapper(
          key: UniqueKey(),
        ),
    (_) => UiKitHorizontalPicturesCarousel(
          key: UniqueKey(),
          autoPlay: true,
          autoPlayDuration: const Duration(seconds: 1),
          pictureLinks: [
            GraphicsFoundation.instance.png.mockAdBanner1.path,
            GraphicsFoundation.instance.png.mockAdBanner2.path,
            GraphicsFoundation.instance.png.mockAdBanner3.path,
            GraphicsFoundation.instance.png.mockAdBanner4.path,
            GraphicsFoundation.instance.png.mockAdBanner5.path,
            GraphicsFoundation.instance.png.place.path,
          ],
          carouselSize: Size(1.sw - SpacingFoundation.verticalSpacing32, 0.285.sw * 1.7),
        ),
    (_) => PlacePreview(
          key: UniqueKey(),
          cellSize: Size(1.sw - 44.w, 156.h),
          onTap: (id) {},
          place: UiPlaceModel(
            title: 'Center city club',
            id: 1,
            media: [
              UiKitMediaPhoto(
                link: 'assets/images/png/place.png',
              ),
              UiKitMediaPhoto(
                link: 'assets/images/png/place.png',
              ),
              UiKitMediaPhoto(
                link: 'assets/images/png/place.png',
              ),
              UiKitMediaPhoto(
                link: 'assets/images/png/place.png',
              ),
            ],
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Sed euismod, nunc ut tincidunt lacinia, nisl nisl aliquam nisl, vitae aliquam nisl nisl sit amet nunc. '
                'Nulla facilisi. '
                'Donec auctor, nisl eget aliquam tincidunt, nunc nisl aliquam nisl, vitae aliquam nisl nisl sit amet nunc. '
                'Nulla facilisi',
            baseTags: [
              UiKitTag(title: 'Bar', icon: ShuffleUiKitIcons.cocktail, unique: false),
              UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.label, unique: false),
              UiKitTag(title: 'Open', icon: ShuffleUiKitIcons.clock, unique: false),
            ],
            tags: [
              UiKitTag(title: 'Drauth beer', icon: ShuffleUiKitIcons.cocktail2, unique: true),
              UiKitTag(title: 'Live music', icon: ShuffleUiKitIcons.music, unique: true),
              UiKitTag(title: 'Networking', icon: ShuffleUiKitIcons.personLayered, unique: true),
              UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
              UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
              UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
              UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
              UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
            ],
          ),
          model: ComponentPlaceModel.fromJson(GlobalConfiguration().appConfig.content['place']),
          reviewsIndicator: const AddReviewAnimation(),
        ),
    (_) => _GetBonusWrapper(
          key: UniqueKey(),
        ),
  ];

  int featureIndex = 0;

  int get totalFeatureCount => _features.length;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 4500));
    _controller.addStatusListener(animationStateListener);
    _controller.forward();
  }

  void animationStateListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // log('animation completed');
      // if (featureIndex < _features.length - 1) {
      setState(() {
        featureIndex++;
        // crossFadeState = CrossFadeState.showSecond;
      });
      _controller.forward(from: 0);
      // Future.delayed(const Duration(milliseconds: 1000), () {
      //   log('switching to next feature');
      //   setState(() {
      //     featureIndex++;
      //     crossFadeState = CrossFadeState.showFirst;
      //   });
      // });
      // } else {
      //   setState(() {
      //     crossFadeState = CrossFadeState.showSecond;
      //   });
      // }
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(animationStateListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    final regularTextTheme = theme?.regularTextTheme;

    final List<Widget> featureTexts = [
      Text(
        S.of(context).InfluencerSubscriptionFeature1,
        style: regularTextTheme?.body,
      ),
      Text(
        S.of(context).InfluencerSubscriptionFeature2,
        style: regularTextTheme?.body,
      ),
      RichText(
          text: TextSpan(
        children: [
          TextSpan(text: S.of(context).InfluencerSubscriptionFeature3),
          TextSpan(
            text: 'Shuffle',
            style: regularTextTheme?.body.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: S.of(context).InfluencerSubscriptionFeature3v1),
        ],
        style: regularTextTheme?.body,
      )),
      RichText(
          text: TextSpan(
        children: [
          TextSpan(text: S.of(context).InfluencerSubscriptionFeature3),
          TextSpan(
            text: 'Shuffle',
            style: regularTextTheme?.body.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: S.of(context).InfluencerSubscriptionFeature3v1),
        ],
        style: regularTextTheme?.body,
      )),
      Text(
        S.of(context).InfluencerSubscriptionFeature4,
        style: regularTextTheme?.body,
      ),
      Text(
        S.of(context).InfluencerSubscriptionFeature5,
        style: regularTextTheme?.body,
      ),
      Text(
        S.of(context).InfluencerSubscriptionFeature6,
        style: regularTextTheme?.body,
      ),
    ];

    return UiKitCardWrapper(
        height: 0.55.sh,
        padding: EdgeInsets.all(SpacingFoundation.verticalSpacing16),
        gradient: theme?.themeMode == ThemeMode.light
            ? GradientFoundation.lightShunyGreyGradient.lerpTo(GradientFoundation.attentionCard, 0.25)
            : GradientFoundation.shunyGreyGradient.lerpTo(GradientFoundation.attentionCard, 0.25),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientableWidget(
                  gradient: GradientFoundation.starLinearGradient,
                  child: ImageWidget(
                    iconData: ShuffleUiKitIcons.gradientStar,
                    color: Colors.white,
                    width: 0.0625.sw,
                    height: 0.0625.sw,
                    fit: BoxFit.cover,
                  ),
                ),
                SpacingFoundation.horizontalSpace8,
                Expanded(
                  child: Text(
                    'Ability to become an influencer',
                    style: regularTextTheme?.body,
                  ),
                ),
              ],
            ),
            SpacingFoundation.verticalSpace16,
            AnimatedSwitcher(
                reverseDuration: Duration.zero,
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeOut,
                duration: const Duration(milliseconds: 400),
                child: _features[featureIndex % totalFeatureCount](context)),
            // _features[featureIndex % totalFeatureCount],
            SpacingFoundation.verticalSpace16,
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientableWidget(
                  gradient: GradientFoundation.fameLinearGradient,
                  child: ImageWidget(
                    iconData: ShuffleUiKitIcons.gradientStar,
                    color: Colors.white,
                    width: 0.0625.sw,
                    height: 0.0625.sw,
                    fit: BoxFit.cover,
                  ),
                ),
                SpacingFoundation.horizontalSpace8,
                Expanded(child: featureTexts[featureIndex % totalFeatureCount]),
              ],
            )
          ],
        ));
  }
}

class _GetBonusWrapper extends StatelessWidget {
  const _GetBonusWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GradientableWidget(
            gradient: GradientFoundation.defaultLinearGradient,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('get bonus', style: context.uiKitTheme?.boldTextTheme.body),
                SpacingFoundation.horizontalSpace2,
                ImageWidget(
                  iconData: ShuffleUiKitIcons.gradientStar,
                  color: Colors.white,
                  width: 0.0625.sw,
                  height: 0.0625.sw,
                  fit: BoxFit.cover,
                )
              ],
            )),
        SpacingFoundation.verticalSpace2,
        const GetBonusAnimation(),
      ],
    );
  }
}

class _VideoWrapper extends StatefulWidget {
  const _VideoWrapper({super.key});

  @override
  State<_VideoWrapper> createState() => __VideoWrapperState();
}

class __VideoWrapperState extends State<_VideoWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double playIconSize = 0;
  final Duration defaultAutoPlayDuration = Duration(milliseconds: (4500 / 2).floor());
  final Duration sizePlayDuration = const Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: defaultAutoPlayDuration);
    _controller.addStatusListener(_animationStateListener);
    _controller.forward();
  }

  _animationStateListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        playIconSize = 1;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageWidget(
          height: 0.55.sw,
          rasterAsset: GraphicsFoundation.instance.png.paywallSlideVideo,
        ),
        AnimatedScale(
          scale: playIconSize,
          duration: sizePlayDuration,
          child: BlurredPlaceVideoPlayButton(
            onPressed: () {},
          ),
        ),
        Positioned(
            right: 10,
            top: 10,
            child: AnimatedScale(
                scale: playIconSize,
                duration: sizePlayDuration,
                child: ClipOval(
                    child: ColoredBox(
                  color: UiKitColors.surface3.withOpacity(0.5),
                  child: ImageWidget(
                    iconData: ShuffleUiKitIcons.x,
                    height: 15.h,
                    color: Colors.white,
                  ).paddingAll(EdgeInsetsFoundation.vertical2),
                ))))
      ],
    );
  }
}
