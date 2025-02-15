import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LoginInvitationComponent extends StatelessWidget {
  final VoidCallback goToLogin;

  const LoginInvitationComponent({super.key, required this.goToLogin});

  AssetGenImage _getIconForTile(int index) {
    switch (index) {
      case 0:
        return GraphicsFoundation.instance.png.relevantContent;
      case 1:
        return GraphicsFoundation.instance.png.rating;
      case 2:
        return GraphicsFoundation.instance.png.reward;
      case 3:
        return GraphicsFoundation.instance.png.help;
      case 4:
        return GraphicsFoundation.instance.png.shuffleLabel;
      default:
        return GraphicsFoundation.instance.png.shuffleLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final AutoSizeGroup group = AutoSizeGroup();

    return SafeArea(
        child: Column(
      children: [
        SpacingFoundation.verticalSpace24,
        Stack(
          alignment: Alignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: S.of(context).LogInTo, style: boldTextTheme?.title2.copyWith(color: Colors.transparent)),
                  TextSpan(text: ' ${S.of(context).ToOpen}'.toLowerCase(), style: boldTextTheme?.title2)
                ])),
            GradientableWidget(
                gradient: GradientFoundation.attentionCard,
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(text: S.of(context).LogInTo, style: boldTextTheme?.title2.copyWith(color: Colors.white)),
                      TextSpan(
                          text: ' ${S.of(context).ToOpen}'.toLowerCase(),
                          style: boldTextTheme?.title2.copyWith(color: Colors.transparent))
                    ])))
          ],
        ),
        SpacingFoundation.verticalSpace16,
        for (int i = 0; i < 5; i++)
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            minLeadingWidth: 32.h,
            contentPadding: EdgeInsets.symmetric(vertical: SpacingFoundation.verticalSpacing6),
            leading: ImageWidget(
              // height: 32.h,
              rasterAsset: _getIconForTile(i),
            ),
            title: AutoSizeText(
              S.of(context).LoginBenefits(i < 4 ? i : 101).toLowerCase(),
              style: boldTextTheme?.caption1Bold,
              maxLines: 3,
              group: group,
            ),
          ),
        SpacingFoundation.verticalSpace16,
        context.gradientButton(
            data: BaseUiKitButtonData(
          fit: ButtonFit.fitWidth,
          text: S.of(context).LogIn,
          onPressed: goToLogin,
        ))
      ],
    ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16));
  }
}
