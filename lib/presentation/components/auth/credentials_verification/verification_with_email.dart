import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/utils/policies_localization_getter.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class VerificationWithEmail extends StatefulWidget {
  final BuildContext context;
  final TextEditingController credentialsController;
  final TextEditingController passwordController;
  final VoidCallback? onSubmit;
  final bool? loading;
  final String? Function(String?)? credentialsValidator;
  final String? Function(String?)? passwordValidator;

  const VerificationWithEmail({
    super.key,
    required this.context,
    required this.credentialsController,
    required this.passwordController,
    this.onSubmit,
    this.loading,
    this.credentialsValidator,
    this.passwordValidator,
  });

  @override
  State<VerificationWithEmail> createState() => _VerificationWithEmailState();
}

class _VerificationWithEmailState extends State<VerificationWithEmail> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final regTextTheme = theme?.regularTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;

    return Column(
      children: [
        SpacingFoundation.verticalSpace16,
        Text(
          S.of(context).LoginWith('email'),
          style: theme?.boldTextTheme.title2,
        ),
        SpacingFoundation.verticalSpace16,
        UiKitWrappedInputField.uiKitInputFieldNoIcon(
          enabled: true,
          hintText: S.of(context).Email.toUpperCase(),
          controller: widget.credentialsController,
          fillColor: colorScheme?.surface3,
          validator: widget.credentialsValidator,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        SpacingFoundation.verticalSpace16,
        UiKitWrappedInputField.uiKitInputFieldRightIcon(
          obscureText: obscurePassword,
          enabled: true,
          hintText: S.of(context).Password.toUpperCase(),
          controller: widget.passwordController,
          fillColor: colorScheme?.surface3,
          validator: widget.passwordValidator,
          icon: GestureDetector(
            onTap: () => setState(() => obscurePassword = !obscurePassword),
            child: obscurePassword
                ? ImageWidget(
                    iconData: ShuffleUiKitIcons.view,
                    color: colorScheme?.darkNeutral900,
                  )
                : const GradientableWidget(
                    gradient: GradientFoundation.defaultRadialGradient,
                    child: ImageWidget(
                      iconData: ShuffleUiKitIcons.eyeoff,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        SpacingFoundation.verticalSpace2,
        Text(
          S.current.PasswordHint,
          style: theme?.regularTextTheme.caption4,
          textAlign: TextAlign.center,
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
                onPressed: widget.passwordController.text.isEmpty || widget.credentialsController.text.isEmpty
                    ? null
                    : widget.onSubmit,
                loading: widget.loading,
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
