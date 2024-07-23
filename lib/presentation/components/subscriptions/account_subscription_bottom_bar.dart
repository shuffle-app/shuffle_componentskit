import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class AccountSubscriptionBottomBar extends StatelessWidget {
  final bool isLoading;
  final bool isTrialAvailable;
  final String buttonText;
  final VoidCallback? onSubscribe;
  final VoidCallback? onRestorePurchase;
  final String termsOfServiceUrl;
  final String privacyPolicyUrl;
  final ComponentModel configModel;

  const AccountSubscriptionBottomBar(
      {super.key,
      required this.isLoading,
      required this.isTrialAvailable,
      required this.buttonText,
      this.onSubscribe,
      this.onRestorePurchase,
      required this.termsOfServiceUrl,
      required this.privacyPolicyUrl, required this.configModel});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final regularTextTheme = theme?.regularTextTheme;

    final verticalMargin = (configModel.positionModel?.verticalMargin ?? 0).toDouble();
    final horizontalMargin = (configModel.positionModel?.horizontalMargin ?? 0).toDouble();

    return UiKitCardWrapper(child:  Column(
      children: [
        context.gradientButton(
          data: BaseUiKitButtonData(
            loading: isLoading,
            autoSizeGroup: AutoSizeGroup(),
            fit: ButtonFit.fitWidth,
            text: buttonText,
            onPressed: onSubscribe,
          ),
        ),
        TextButton(
          onPressed: onRestorePurchase,
          child: Text(
            S.current.RestorePurchase,
            style: boldTextTheme?.caption1Bold,
          ),
        ),
        if (isTrialAvailable) ...[
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Cancel any time in ${Platform.isIOS ? 'AppStore' : 'Play Store'}',
                  style: regularTextTheme?.caption3))
        ],
        Align(
            alignment: Alignment.centerLeft,
            child: RichText(
                text: TextSpan(
              children: [
                TextSpan(
                    text: S.of(context).TermsOfService,
                    style: regularTextTheme?.caption3.copyWith(color: ColorsFoundation.darkNeutral600),
                    recognizer: TapGestureRecognizer()..onTap = () => launchUrlString(termsOfServiceUrl)),
                TextSpan(
                  text: S.of(context).AndWithWhitespaces.toLowerCase(),
                  style: regularTextTheme?.caption3,
                ),
                TextSpan(
                    text: S.of(context).PrivacyPolicy,
                    style: regularTextTheme?.caption3.copyWith(color: ColorsFoundation.darkNeutral600),
                    recognizer: TapGestureRecognizer()..onTap = () => launchUrlString(privacyPolicyUrl)),
              ],
            ))),

      ],
    ).paddingSymmetric(
      vertical: verticalMargin,
      horizontal: horizontalMargin,
    ));
  }
}
