import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UnderDevelopment extends StatelessWidget {
  final String? customMessage;

  const UnderDevelopment({
    super.key,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isLightTheme = context.uiKitTheme?.themeMode == ThemeMode.light;
    String animationPath = isLightTheme
        ? GraphicsFoundation.instance.animations.lottie.shuffleLoaderWhiteTheme.path
        : GraphicsFoundation.instance.animations.lottie.shuffleLoaderBlackTheme.path;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          customMessage ?? S.current.UnderDevelopmentMessage,
          style: context.uiKitTheme?.boldTextTheme.subHeadline,
          textAlign: TextAlign.center,
        ),
        SpacingFoundation.verticalSpace16,
        SizedBox(
          width: MediaQuery.sizeOf(context).width / 2,
          child: Center(
            child: LottieAnimation(
              lottiePath: animationPath,
            ),
          ),
        ),
      ],
    );
  }
}
