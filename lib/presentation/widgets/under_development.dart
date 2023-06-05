import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UnderDevelopment extends StatelessWidget {
  const UnderDevelopment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Under Development',
          style: context.uiKitTheme?.boldTextTheme.subHeadline,
        ),
        SpacingFoundation.verticalSpace16,
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Center(
            child: LottieAnimation(
              lottiePath: GraphicsFoundation.instance.animations.lottie.shuffleLoader1.path,
            ),
          ),
        ),
      ],
    );
  }
}
