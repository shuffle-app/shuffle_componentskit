part of 'welcome_component.dart';

class _FirstBody extends StatelessWidget {
  final String backgroundImage;
  final bool bigScreen;
  final VoidCallback? onNextPressed;
  final AnimationController animationController;

  const _FirstBody({
    Key? key,
    required this.bigScreen,
    required this.backgroundImage,
    required this.animationController,
    this.onNextPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;
    Widget spacing = SpacingFoundation.verticalSpace16;
    final langCode = Localizations.localeOf(context).languageCode;
    if (bigScreen) spacing = SpacingFoundation.verticalSpace24;

    return SizedBox(
      height: 1.sh,
      width: 1.sw,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImageWidget(
            link: backgroundImage,
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MediaQuery.viewPaddingOf(context).top + SpacingFoundation.verticalSpacing24,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: UiKitIconedBlurMessageCard(
                  blurValue: 24,
                  borderRadius: BorderRadiusFoundation.all24,
                  orientation: Axis.vertical,
                  message: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${S.of(context).WhatIs} ',
                          style: textTheme?.caption1Medium.copyWith(color: Colors.white),
                        ),
                        TextSpan(
                          text: S.of(context).ShuffleWithRightWhitespace.toLowerCase(),
                          style: textTheme?.caption1Bold.copyWith(color: Colors.white),
                        ),
                        if (langCode != 'ru')
                          TextSpan(
                            text: S.of(context).For.toLowerCase(),
                            style: textTheme?.caption1Medium.copyWith(color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                  icon: ShuffleUiKitIcons.whiteStarTransparentCenter,
                  iconColor: Colors.white,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: UiKitIconedBlurMessageCard(
                  blurValue: 24,
                  message: Text(
                    S.of(context).ThroughANonAggregatorSystem,
                    style: textTheme?.caption1Bold.copyWith(color: Colors.white),
                  ),
                  icon: ShuffleUiKitIcons.whiteStarTransparentCenter,
                  iconColor: Colors.white,
                ),
              ),
              spacing,
              Align(
                alignment: Alignment.centerRight,
                child: UiKitIconedBlurMessageCard(
                  blurValue: 24,
                  message: Text(
                    S.of(context).WithYourPreferences,
                    style: textTheme?.caption1Bold.copyWith(color: Colors.white),
                  ),
                  icon: ShuffleUiKitIcons.whiteStarTransparentCenter,
                  iconColor: Colors.white,
                ),
              ),
              spacing,
              Align(
                alignment: Alignment.centerLeft,
                child: UiKitIconedBlurMessageCard(
                  blurValue: 24,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  message: Text(
                    S.of(context).DontBeAlone,
                    style: textTheme?.caption1Bold.copyWith(color: Colors.white),
                  ),
                  icon: ShuffleUiKitIcons.whiteStarTransparentCenter,
                  iconColor: Colors.white,
                ),
              ),
              spacing,
              Align(
                alignment: Alignment.centerRight,
                child: UiKitIconedBlurMessageCard(
                  blurValue: 24,
                  message: Text(
                    S.of(context).LovelyTouchAmazingInteraction,
                    style: textTheme?.caption1Bold.copyWith(color: Colors.white),
                  ),
                  icon: ShuffleUiKitIcons.whiteStarTransparentCenter,
                  iconColor: Colors.white,
                ),
              ),
              if (!bigScreen) SpacingFoundation.verticalSpace24,
              if (bigScreen) const Spacer(),
              Hero(
                tag: S.of(context).Welcome.toLowerCase(),
                transitionOnUserGestures: true,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return context.buttonWithProgress(
                      data: BaseUiKitButtonData(
                        text: S.of(context).NextWithChevrons.toUpperCase(),
                        onPressed: () => onNextPressed?.call(),
                      ),
                      blurred: false,
                      progress: animationController.value,
                    );
                  },
                ),
              ),
              SpacingFoundation.verticalSpace24,
            ],
          ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        ],
      ),
    );
  }
}
