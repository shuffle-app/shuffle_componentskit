part of 'welcome_component.dart';

class _LastBody extends StatelessWidget {
  final bool bigScreen;
  final VoidCallback? onFinished;
  final String backgroundImage;
  final bool loading;

  const _LastBody({
    Key? key,
    required this.bigScreen,
    this.loading = false,
    required this.backgroundImage,
    this.onFinished,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        ImageWidget(
          rasterAsset: GraphicsFoundation.instance.png.welcomeSlide2,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 0.3.sh,
          child: ImageWidget(
            svgAsset: GraphicsFoundation.instance.svg.bigCuttedLogo,
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
              Text(
                'This is shuffle',
                style: textTheme?.title1,
                textAlign: TextAlign.center,
              ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal32 * 2),
              SpacingFoundation.verticalSpace16,
              Text(
                'Smart leisure selection for everyone, everywhere.',
                style: textTheme?.subHeadline,
                textAlign: TextAlign.center,
              ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal32),
              if (bigScreen) ...[
                SpacingFoundation.verticalSpace24,
                SpacingFoundation.verticalSpace24,
                SpacingFoundation.verticalSpace12,
              ],
              if (!bigScreen) SpacingFoundation.verticalSpace16,
              context
                  .button(
                    data: BaseUiKitButtonData(
                      text: 'Get started',
                      onPressed: onFinished,
                    ),
                  )
                  .paddingSymmetric(
                    horizontal: EdgeInsetsFoundation.horizontal16,
                  )
                  .loadingWrap(loading),
              SpacingFoundation.verticalSpace24,
            ],
          ),
        ),
      ],
    );
  }
}
