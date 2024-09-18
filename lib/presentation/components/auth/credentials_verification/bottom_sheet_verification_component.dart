import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/utils/policies_localization_getter.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class BottomSheetVerificationComponent extends StatelessWidget {
  final TextEditingController credentialsController;
  final TextEditingController passwordController;
  final ValueChanged<bool>? onSubmit;
  final bool? loading;
  final String? Function(String?)? credentialsValidator;
  final String? Function(String?)? passwordValidator;

  const BottomSheetVerificationComponent({
    super.key,
    required this.credentialsController,
    required this.passwordController,
    this.onSubmit,
    this.loading,
    this.credentialsValidator,
    this.passwordValidator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final regTextTheme = theme?.regularTextTheme;

    return Column(
      children: [
        SpacingFoundation.verticalSpace16,
        Text(
          S.of(context).LoginWith('email'),
          style: theme?.boldTextTheme.title2,
        ),
        SpacingFoundation.verticalSpace16,
        EmailVerificationForm(
          authType: RegistrationType.email,
          credentialsController: credentialsController,
          passwordController: passwordController,
          loading: loading,
          credentialsValidator: credentialsValidator,
          passwordValidator: passwordValidator,
        ),
        Column(
          children: [
            SpacingFoundation.verticalSpace16,
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${S.of(context).ByContinuingYouAcceptThe} ',
                    style: regTextTheme?.caption4,
                  ),
                  TextSpan(
                    text: S.current.TermsOfService,
                    style: regTextTheme?.caption4.copyWith(color: ColorsFoundation.darkNeutral600),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.push(
                            WebViewScreen(
                              title: S.current.TermsOfService,
                              url: PolicyLocalizer.localizedTermsOfService(
                                Localizations.localeOf(context).languageCode,
                              ),
                            ),
                          ),
                  ),
                  TextSpan(
                    text: S.of(context).AndWithWhitespaces.toLowerCase(),
                    style: regTextTheme?.caption4,
                  ),
                  TextSpan(
                    text: S.current.PrivacyPolicy,
                    style: regTextTheme?.caption4.copyWith(color: ColorsFoundation.darkNeutral600),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.push(
                            WebViewScreen(
                              title: S.current.PrivacyPolicy,
                              url: PolicyLocalizer.localizedPrivacyPolicy(
                                Localizations.localeOf(context).languageCode,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: S.of(context).Next.toUpperCase(),
                onPressed: () {
                  if (passwordController.text.isNotEmpty && credentialsController.text.isNotEmpty) {
                    onSubmit?.call(true);
                  }
                },
                loading: loading,
                fit: ButtonFit.fitWidth,
              ),
            ),
            SpacingFoundation.verticalSpace4,
          ],
        )
      ],
    ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16);
  }
}
