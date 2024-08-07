part of 'welcome_component.dart';

class _LastBody extends StatelessWidget {
  final bool bigScreen;
  final VoidCallback? onFinished;
  final String backgroundImage;
  final bool loading;

  const _LastBody({
    required this.bigScreen,
    this.loading = false,
    required this.backgroundImage,
    this.onFinished,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final regularTextTheme = context.uiKitTheme?.regularTextTheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        const ImageWidget(
          link: 'https://shuffle-app-production.s3.eu-west-2.amazonaws.com/static-files/onboarding/welcome_slide_2.png',
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 0.3.sh,
          child: ImageWidget(
            link: GraphicsFoundation.instance.svg.bigCuttedLogo.path,
            width: 1.sw,
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          width: 1.sw,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SpacingFoundation.verticalSpace24,
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${S.of(context).ThisIs} ',
                      style: regularTextTheme?.title1.copyWith(color: Colors.white),
                    ),
                    TextSpan(
                      text: S.of(context).Shuffle.toLowerCase(),
                      style: boldTextTheme?.title1.copyWith(color: Colors.white),
                    )
                  ],
                ),
              ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal32 * 2),
              SpacingFoundation.verticalSpace16,
              Text(
                S.of(context).SmartLeisureSelection,
                style: boldTextTheme?.subHeadline.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal32),
              if (bigScreen) ...[
                SpacingFoundation.verticalSpace24,
                SpacingFoundation.verticalSpace24,
                SpacingFoundation.verticalSpace12,
              ],
              if (!bigScreen) SpacingFoundation.verticalSpace16,
              Hero(
                tag: S.of(context).Welcome.toLowerCase(),
                transitionOnUserGestures: true,
                child: context.button(
                  data: BaseUiKitButtonData(
                    text: S.of(context).GetStarted,
                    onPressed: onFinished,
                    loading: loading,
                    textColor: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                ),
              ).paddingSymmetric(
                horizontal: EdgeInsetsFoundation.horizontal16,
              ),
              SpacingFoundation.verticalSpace24,
            ],
          ),
        ),
      ],
    );
  }
}
