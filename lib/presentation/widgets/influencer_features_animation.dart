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

  final List<Widget> _features = [
    const UserTileSpecialityAnimation(),
    const ProfileCardAnimated(),
    const UiKitInfluencerAudioMessagesDemo(),
    UiKitHorizontalPicturesCarousel(
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
      carouselSize: Size(1.sw - SpacingFoundation.verticalSpacing32, 0.3.sh),
    ),
    PlacePreview(
      onTap: () {},
      place: UiPlaceModel(
        title: 'Center city club',
        id: 1,
        media: [
          UiKitMediaVideo(
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
    const _GetBonusWrapper(),
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
        'You can declare yourself and show your expertise in one of the areas of social life of the city or the world',
        style: regularTextTheme?.body,
      ),
      Text(
        'You can gather your own new or supplement an existing audience',
        style: regularTextTheme?.body,
      ),
      RichText(
          text: TextSpan(
        children: [
          const TextSpan(text: 'Get a set of tools for working with '),
          TextSpan(
            text: 'Shuffle',
            style: regularTextTheme?.body.copyWith(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: ' content and interacting with your audience'),
        ],
        style: regularTextTheme?.body,
      )),
      Text(
        'Become a thought leader in your field and earn a reputation',
        style: regularTextTheme?.body,
      ),
      Text(
        'Influence people\'s choices and enhance the significance of places and events',
        style: regularTextTheme?.body,
      ),
      Text(
        'Monetization',
        style: regularTextTheme?.body,
      ),
    ];

    return AnimatedSize(
        duration: const Duration(milliseconds: 500),
        curve: Curves.bounceIn,
        child: UiKitCardWrapper(
            // height: 0.5.sh,
            padding: EdgeInsets.all(SpacingFoundation.verticalSpacing16),
            gradient: theme?.themeMode == ThemeMode.light
                ? GradientFoundation.lightShunyGreyGradient.lerpTo(GradientFoundation.attentionCard, 0.3)
                : GradientFoundation.shunyGreyGradient.lerpTo(GradientFoundation.attentionCard, 0.3),
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
                    switchInCurve: Curves.bounceIn,
                    switchOutCurve: Curves.bounceIn,
                    duration: const Duration(milliseconds: 500),
                    child: _features[featureIndex % totalFeatureCount]),
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
            )));
  }
}

class _GetBonusWrapper extends StatelessWidget {
  const _GetBonusWrapper();

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
