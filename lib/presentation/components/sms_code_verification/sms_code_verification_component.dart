import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SmsCodeVerificationComponent extends StatelessWidget {
  final VoidCallback? onSubmit;
  final TextEditingController smsController;
  final UiSmsCodeVerificationModel uiModel;

  const SmsCodeVerificationComponent({
    super.key,
    required this.smsController,
    required this.uiModel,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final SmsVerificationModel model = SmsVerificationModel.fromJson(config['about_user']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: MediaQuery.of(context).viewPadding.top,
        ),
        Text(
          'Mobile verification',
          style: boldTextTheme?.title1,
        ),
        SpacingFoundation.verticalSpace16,
        Stack(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Please type verification code sent to ',
                    style: boldTextTheme?.subHeadline,
                  ),
                  TextSpan(
                    text: uiModel.phone,
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
                      text: 'Please type verification code sent to ',
                      style: boldTextTheme?.subHeadline.copyWith(color: Colors.transparent),
                    ),
                    TextSpan(
                      text: uiModel.phone,
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
              codeDigitsCount: model.codeDigitsCount,
              onDone: (code) => onSubmit?.call(),
            ),
          ),
        ),
      ],
    ).paddingSymmetric(
      horizontal: horizontalMargin,
      vertical: verticalMargin,
    );
  }
}
