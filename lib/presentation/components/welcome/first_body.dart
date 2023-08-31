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
              height: MediaQuery.of(context).viewPadding.top + SpacingFoundation.verticalSpacing24,
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
                        text: 'What is \n',
                        style: textTheme?.caption1Medium,
                      ),
                      TextSpan(
                        text: 'shuffle ',
                        style: textTheme?.caption1Bold,
                      ),
                      TextSpan(
                        text: 'for',
                        style: textTheme?.caption1Medium,
                      ),
                    ],
                  ),
                ),
                iconLink: GraphicsFoundation.instance.svg.whiteStarTransparentCenter.path,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: UiKitIconedBlurMessageCard(
                message: Text(
                  'Through a non-\naggregator system \nespecially for you',
                  style: textTheme?.caption1Bold,
                ),
                iconLink: GraphicsFoundation.instance.svg.whiteStarTransparentCenter.path,
              ),
            ),
            spacing,
            Align(
              alignment: Alignment.centerRight,
              child: UiKitIconedBlurMessageCard(
                message: Text(
                  'With your\npreferences',
                  style: textTheme?.caption1Bold,
                ),
                iconLink: GraphicsFoundation.instance.svg.whiteStarTransparentCenter.path,
              ),
            ),
            spacing,
            Align(
              alignment: Alignment.centerLeft,
              child: UiKitIconedBlurMessageCard(
                crossAxisAlignment: CrossAxisAlignment.center,
                message: Text(
                  'Don\'t be alone',
                  style: textTheme?.caption1Bold,
                ),
                iconLink: GraphicsFoundation.instance.svg.whiteStarTransparentCenter.path,
              ),
            ),
            spacing,
            Align(
              alignment: Alignment.centerRight,
              child: UiKitIconedBlurMessageCard(
                message: Text(
                  'Lovely-touch amazing\ninteraction',
                  style: textTheme?.caption1Bold,
                ),
                iconLink: GraphicsFoundation.instance.svg.whiteStarTransparentCenter.path,
              ),
            ),
            if (!bigScreen) SpacingFoundation.verticalSpace24,
            if (bigScreen) const Spacer(),
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return context.buttonWithProgress(
                  data: BaseUiKitButtonData(
                    text: 'NEXT >>>',
                    onPressed: () => onNextPressed?.call(),
                  ),
                  blurred: false,
                  progress: animationController.value,
                );
              },
            ),
            SpacingFoundation.verticalSpace24,
          ],
        ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16)
      ],
    );
  }
}
