import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CredentialsCodeVerificationComponent extends StatelessWidget {
  final ValueChanged<String>? onSubmit;
  final TextEditingController codeController;
  final GlobalKey<FormState> formKey;
  final String credentials;
  final String? errorText;
  final VoidCallback? onResendCode;

  const CredentialsCodeVerificationComponent({
    super.key,
    required this.codeController,
    required this.formKey,
    required this.credentials,
    this.onSubmit,
    this.errorText,
    this.onResendCode,
  });

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['sms_verification']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final codeDigits = config['additional_settings']?['code_digits'] ?? 4;

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).viewPadding.top,
          ),
          Text(
            credentials.contains('@') ? S.current.EmailVerification : S.current.PhoneVerification,
            style: boldTextTheme?.title1,
          ),
          SpacingFoundation.verticalSpace16,
          Stack(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${S.current.CredentialsCodeVerificationSubtitle} ',
                      style: boldTextTheme?.subHeadline,
                    ),
                    TextSpan(
                      text: credentials,
                      style: boldTextTheme?.subHeadline.copyWith(color: Colors.transparent),
                    ),
                  ],
                ),
              ),
              GradientableWidget(
                gradient: GradientFoundation.attentionCard,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${S.current.CredentialsCodeVerificationSubtitle} ',
                        style: boldTextTheme?.subHeadline.copyWith(color: Colors.transparent),
                      ),
                      TextSpan(
                        text: credentials,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.pop();
                          },
                        style: boldTextTheme?.subHeadline,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UiKitCodeInputField(
                  controller: codeController,
                  codeDigitsCount: codeDigits,
                  onDone: (code) => onSubmit?.call(code),
                  errorText: errorText,
                ),
                SpacingFoundation.verticalSpace24,
                Align(
                  alignment: Alignment.centerRight,
                  child: context.smallOutlinedButton(
                    data: BaseUiKitButtonData(
                      text: S.current.ResendCode.toUpperCase(),
                      onPressed: onResendCode,
                      fit: ButtonFit.hugContent,
                    ),
                  ),
                ),
                SpacingFoundation.verticalSpace24,
              ],
            ),
          ),
        ],
      ).paddingSymmetric(
        horizontal: horizontalMargin,
        vertical: verticalMargin,
      ),
    );
  }
}
