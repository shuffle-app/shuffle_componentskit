import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ForgotPasswordDialogComponent extends StatelessWidget {
  final VoidCallback? onForgotPassword;

  const ForgotPasswordDialogComponent({
    Key? key,
    this.onForgotPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;
    final forgotPasswordConfig = ComponentModel.fromJson(GlobalConfiguration().appConfig.content['forgot_password']);
    final horizontalMargin = (forgotPasswordConfig.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (forgotPasswordConfig.positionModel?.verticalMargin ?? 0).toDouble();
    final title = forgotPasswordConfig.content.title?[ContentItemType.text]?.properties?.keys.first;
    final subtitle = forgotPasswordConfig.content.subtitle?[ContentItemType.text]?.properties?.keys.first;
    final button = forgotPasswordConfig.content.body?[ContentItemType.button]?.properties?.entries.first;

    return SafeArea(
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text(
            //   '$title',
            //   style: boldTextTheme?.title2.copyWith(color: Colors.black),
            // ),
            // SpacingFoundation.verticalSpace16,
            // TextButton(
            //   onPressed: () {},
            //   child: Text(subtitle ?? ''),
            // ),
            // SpacingFoundation.verticalSpace16,
            // context.dialogButton(
            //   dialogButtonType: DialogButtonType.buttonBlack,
            //   data: BaseUiKitButtonData(
            //     fit: ButtonFit.fitWidth,
            //     text: button?.key ?? '',
            //     onPressed: () {},
            //   ),
            // ),
          ],
        ).paddingSymmetric(horizontal: horizontalMargin, vertical: verticalMargin),
      ),
    );
  }
}
