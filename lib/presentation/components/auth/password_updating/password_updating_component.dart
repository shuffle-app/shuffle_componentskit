import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PasswordUpdatingComponent extends StatelessWidget {
  final TextEditingController codeController;
  final TextEditingController passwordController;
  final ValueChanged<String> onPasswordChanged;
  final GlobalKey<FormState> formKey;
  final String credentials;

  final ValueChanged<String>? onSubmit;
  final String? Function(String?)? passwordValidator;
  final String? codeErrorText;
  final String? passwordErrorText;

  const PasswordUpdatingComponent({
    super.key,
    required this.formKey,
    required this.credentials,
    required this.codeController,
    required this.onPasswordChanged,
    required this.passwordController,
    this.onSubmit,
    this.codeErrorText,
    this.passwordValidator,
    this.passwordErrorText,
  });

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
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
          SizedBox(height: MediaQuery.of(context).viewPadding.top),
          Text('Reset password', style: boldTextTheme?.title1),
          SpacingFoundation.verticalSpace16,
          Stack(
            children: [
              Text(
                'Please type verification code sent to ',
                style: boldTextTheme?.subHeadline,
              ),
              GradientableWidget(
                gradient: GradientFoundation.attentionCard,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Please type verification code sent to ',
                        style: boldTextTheme?.subHeadline.copyWith(
                          color: Colors.transparent,
                        ),
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
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UiKitCodeInputField(
                        controller: codeController,
                        codeDigitsCount: codeDigits,
                        onDone: (code) {
                          onSubmit?.call(code);
                          primaryFocus?.nextFocus();
                        },
                        autofocus: false,
                        errorText: codeErrorText,
                      ),
                      SpacingFoundation.verticalSpace24,
                      SpacingFoundation.verticalSpace8,
                      UiKitTitledTextField(
                        title: 'Enter new password',
                        controller: passwordController,
                        hintText: 'password'.toUpperCase(),
                        validator: passwordValidator,
                        errorText: passwordErrorText,
                      ),
                    ],
                  ),
                ),
                context.button(
                  data: BaseUiKitButtonData(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        onPasswordChanged.call(passwordController.text);
                      }
                    },
                    text: 'next',
                    fit: ButtonFit.fitWidth,
                  ),
                ),
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
