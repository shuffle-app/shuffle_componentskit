import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CredentialsCodeVerificationComponent extends StatelessWidget {
  final VoidCallback? onSubmit;
  final TextEditingController codeController;
  final GlobalKey<FormState> formKey;
  final String credentials;

  const CredentialsCodeVerificationComponent({
    super.key,
    required this.codeController,
    required this.formKey,
    required this.credentials,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['sms_verification']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final title = model.content.title?[ContentItemType.text]?.properties?.keys.first ?? '';
    final subtitle = model.content.subtitle?[ContentItemType.text]?.properties?.keys.first ?? '';
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
            title,
            style: boldTextTheme?.title1,
          ),
          SpacingFoundation.verticalSpace16,
          Stack(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: subtitle,
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
                        text: subtitle,
                        style: boldTextTheme?.subHeadline.copyWith(color: Colors.transparent),
                      ),
                      TextSpan(
                        text: credentials,
                        style: boldTextTheme?.subHeadline,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: UiKitCodeInputField(
                controller: codeController,
                codeDigitsCount: codeDigits,
                onDone: (code) => onSubmit?.call(),
              ),
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