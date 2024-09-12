import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class EmailVerificationForm extends StatefulWidget {
  final UiUnifiedVerificationModel? uiModel;
  final RegistrationType? authType;
  final TextEditingController credentialsController;
  final TextEditingController passwordController;
  final String? Function(String?)? credentialsValidator;
  final String? Function(String?)? passwordValidator;
  final String? countrySelectorTitle;
  final ValueChanged<CountryModel>? onCountrySelected;
  final bool? loading;
  final bool isSmallScreen;
  final bool hasPasswordError;

  const EmailVerificationForm({
    super.key,
    this.uiModel,
    this.authType,
    required this.credentialsController,
    required this.passwordController,
    this.credentialsValidator,
    this.passwordValidator,
    this.countrySelectorTitle,
    this.onCountrySelected,
    this.loading,
    this.isSmallScreen = false,
    this.hasPasswordError = false,
  });

  @override
  State<EmailVerificationForm> createState() => _EmailVerificationFormState();
}

class _EmailVerificationFormState extends State<EmailVerificationForm> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final regTextTheme = theme?.regularTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;

    return Column(
      children: [
        if (widget.authType == RegistrationType.phone) ...[
          UiKitCountrySelector(
            selectedCountry: widget.uiModel?.selectedCountry,
            title: widget.countrySelectorTitle ?? '',
            onSelected: (country) => widget.onCountrySelected?.call(country),
          ),
          widget.isSmallScreen ? SpacingFoundation.verticalSpace8 : SpacingFoundation.verticalSpace16,
          UiKitCardWrapper(
            color: ColorsFoundation.surface1,
            borderRadius: BorderRadiusFoundation.max,
            child: UiKitPhoneNumberInput(
              enabled: true,
              controller: widget.credentialsController,
              countryCode: widget.uiModel?.selectedCountry?.countryPhoneCode ?? '',
              fillColor: ColorsFoundation.surface3,
              validator: widget.credentialsValidator,
            ).paddingAll(EdgeInsetsFoundation.all4),
          ),
          widget.isSmallScreen ? SpacingFoundation.verticalSpace8 : SpacingFoundation.verticalSpace16,
        ],
        if (widget.authType == RegistrationType.email) ...[
          UiKitWrappedInputField.uiKitInputFieldNoIcon(
            enabled: true,
            hintText: S.of(context).Email.toUpperCase(),
            controller: widget.credentialsController,
            fillColor: colorScheme?.surface3,
            validator: widget.credentialsValidator,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          widget.isSmallScreen ? SpacingFoundation.verticalSpace8 : SpacingFoundation.verticalSpace16,
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
            style: regTextTheme?.caption4,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
