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
    if (bigScreen) spacing = SpacingFoundation.verticalSpace24;

    return Stack(
      fit: StackFit.expand,
      children: [
        ImageWidget(
          link: backgroundImage,
          fit: BoxFit.cover,
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.viewPaddingOf(context).top + SpacingFoundation.verticalSpacing24,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: UiKitIconedBlurMessageCard(
                borderRadius: BorderRadiusFoundation.all24,
                orientation: Axis.vertical,
                message: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: S.of(context).WhatIs,
                        style: textTheme?.caption1Medium,
                      ),
                      TextSpan(
                        text: S.of(context).ShuffleWithRightWhitespace.toLowerCase(),
                        style: textTheme?.caption1Bold,
                      ),
                      TextSpan(
                        text: S.of(context).For.toLowerCase(),
                        style: textTheme?.caption1Medium,
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
                message: Text(
                  S.of(context).ThroughANonAggregatorSystem,
                  style: textTheme?.caption1Bold,
                ),
                icon: ShuffleUiKitIcons.whiteStarTransparentCenter,
                iconColor: Colors.white,
              ),
            ),
            spacing,
            Align(
              alignment: Alignment.centerRight,
              child: UiKitIconedBlurMessageCard(
                message: Text(
                  S.of(context).WithYourPreferences,
                  style: textTheme?.caption1Bold,
                ),
                icon: ShuffleUiKitIcons.whiteStarTransparentCenter,
                iconColor: Colors.white,
              ),
            ),
            spacing,
            Align(
              alignment: Alignment.centerLeft,
              child: UiKitIconedBlurMessageCard(
                crossAxisAlignment: CrossAxisAlignment.center,
                message: Text(
                  S.of(context).DontBeAlone,
                  style: textTheme?.caption1Bold,
                ),
                icon: ShuffleUiKitIcons.whiteStarTransparentCenter,
                iconColor: Colors.white,
              ),
            ),
            spacing,
            Align(
              alignment: Alignment.centerRight,
              child: UiKitIconedBlurMessageCard(
                message: Text(
                  S.of(context).LovelyTouchAmazingInteraction,
                  style: textTheme?.caption1Bold,
                ),
                icon: ShuffleUiKitIcons.whiteStarTransparentCenter,
                iconColor: Colors.white,
              ),
            ),
            if (!bigScreen) SpacingFoundation.verticalSpace24,
            if (bigScreen) const Spacer(),
            Hero(
              tag: 'welcome',
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
        ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16)
      ],
    );
  }
}
