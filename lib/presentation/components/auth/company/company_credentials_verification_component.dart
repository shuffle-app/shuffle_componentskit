import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CompanyCredentialsVerificationComponent extends StatelessWidget {
  final UiCompanyCredentialsVerificationModel uiModel;
  final VoidCallback? onSubmitted;
  final ValueChanged<int>? onTabChanged;
  final ValueChanged<CountryModel>? onCountryChanged;
  final TextEditingController credentialsController;
  final GlobalKey<FormState> formKey;
  final bool? loading;
  final TextEditingController passwordController;
  final String? Function(String?)? passwordValidator;
  final String? Function(String?)? credentialsValidator;
  final List<LocaleModel>? availableLocales;

  final String? Function(String?)? companyCredentialsValidator;

  const CompanyCredentialsVerificationComponent({
    super.key,
    required this.uiModel,
    required this.formKey,
    required this.credentialsController,
    required this.passwordController,
    this.passwordValidator,
    this.credentialsValidator,
    this.availableLocales,
    this.loading,
    this.onSubmitted,
    this.onTabChanged,
    this.onCountryChanged,
    this.companyCredentialsValidator,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final regTextTheme = context.uiKitTheme?.regularTextTheme;
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['company_credentials_verification']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final title = model.content.title?[ContentItemType.text]?.properties?.keys.first ?? '';
    final subtitle = model.content.subtitle?[ContentItemType.text]?.properties?.keys.first ?? '';
    final decorationLink = model.content.properties?.values.first;
    final tabBar = model.content.body?[ContentItemType.tabBar]?.properties;
    final countrySelectorTitle =
        model.content.body?[ContentItemType.countrySelector]?.title?[ContentItemType.text]?.properties?.keys.first ?? '';

    final captionTexts = Map<String, PropertiesBaseModel>.of(model.content.properties ?? {});

    captionTexts.remove('image');
    captionTexts.remove('auth_type');

    final privacyCaptions = captionTexts.entries.toList();
    privacyCaptions.sort((a, b) => (a.value.sortNumber ?? 0).compareTo(b.value.sortNumber ?? 0));

    final authType = indentifyRegistrationType(model.content.properties?['auth_type']?.value ?? '');
    final passwordHint = model.content.body?[ContentItemType.passwordHint]?.properties?.keys.firstOrNull ?? '';

    final colorScheme = context.uiKitTheme?.colorScheme;
    bool obscurePassword = true;

    return Form(
      key: formKey,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            width: 1.sw,
            right: SpacingFoundation.horizontalSpacing16,
            top: MediaQuery.viewPaddingOf(context).top + SpacingFoundation.verticalSpacing6,
            child: ImageWidget(
              link: decorationLink?.imageLink ?? '',
              fit: BoxFit.fitWidth,
              width: 1.sw,
            ),
          ),
          KeyboardVisibilityBuilder(
            builder: (context, visible) => Positioned(
              width: 1.sw,
              height: 1.sh - MediaQuery.viewInsetsOf(context).bottom,
              bottom: SpacingFoundation.zero,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: MediaQuery.viewPaddingOf(context).top,
                  ),
                  Text(
                    title,
                    style: boldTextTheme?.titleLarge,
                  ),
                  SpacingFoundation.verticalSpace16,
                  Text(
                    subtitle,
                    style: boldTextTheme?.subHeadline,
                  ),
                  const Spacer(),
                  if (availableLocales != null && availableLocales!.isNotEmpty)
                    StatefulBuilder(
                        builder: (context, setState) => UiKitCardWrapper(
                              color: colorScheme?.surface1,
                              borderRadius: BorderRadiusFoundation.max,
                              child: UiKitLocaleSelector(
                                  selectedLocale: availableLocales!
                                      .firstWhere((element) => element.locale.languageCode == Intl.getCurrentLocale()),
                                  availableLocales: availableLocales!,
                                  onLocaleChanged: (LocaleModel value) {
                                    context.findAncestorWidgetOfExactType<UiKitTheme>()?.onLocaleUpdated(value.locale);
                                    setState(() {});
                                  }).paddingAll(EdgeInsetsFoundation.all4),
                            )),
                  if (tabBar != null) ...[
                    UiKitCustomTabBar(
                      tabs: tabBar.keys.map<UiKitCustomTab>((key) => UiKitCustomTab(title: key)).toList(),
                      onTappedTab: (tabIndex) => onTabChanged?.call(tabIndex),
                    ),
                    SpacingFoundation.verticalSpace16,
                  ],
                  if (authType == RegistrationType.phone) ...[
                    UiKitCountrySelector(
                      selectedCountry: uiModel.selectedCountry,
                      onSelected: (country) => onCountryChanged?.call(country),
                      title: countrySelectorTitle,
                    ),
                    SpacingFoundation.verticalSpace16,
                    UiKitCardWrapper(
                      color: ColorsFoundation.surface1,
                      borderRadius: BorderRadiusFoundation.max,
                      child: UiKitPhoneNumberInput(
                        controller: credentialsController,
                        enabled: true,
                        fillColor: ColorsFoundation.surface3,
                        countryCode: uiModel.selectedCountry?.countryPhoneCode ?? '',
                        validator: companyCredentialsValidator,
                      ).paddingAll(EdgeInsetsFoundation.all4),
                    ),
                  ],
                  if (authType == RegistrationType.email) ...[
                    SpacingFoundation.verticalSpace16,
                    UiKitWrappedInputField.uiKitInputFieldNoIcon(
                      enabled: true,
                      hintText: 'EMAIL',
                      controller: credentialsController,
                      fillColor: colorScheme?.surface3,
                      validator: credentialsValidator,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    SpacingFoundation.verticalSpace16,
                    StatefulBuilder(
                      builder: (context, setState) => UiKitWrappedInputField.uiKitInputFieldRightIcon(
                        obscureText: obscurePassword,
                        enabled: true,
                        hintText: 'PASSWORD',
                        controller: passwordController,
                        fillColor: colorScheme?.surface3,
                        validator: passwordValidator,
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
                    ),
                    SpacingFoundation.verticalSpace2,
                    Text(
                      passwordHint,
                      style: regTextTheme?.caption4,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  SpacingFoundation.verticalSpace16,
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: S.of(context).ByContinuingYouAcceptThe, style: regTextTheme?.caption4),
                        TextSpan(
                          text: privacyCaptions.first.key,
                          style: regTextTheme?.caption4.copyWith(color: ColorsFoundation.darkNeutral600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.push(
                                  WebViewScreen(
                                    title: privacyCaptions.first.key,
                                    url: privacyCaptions.first.value.value ?? '',
                                  ),
                                ),
                        ),
                        TextSpan(text: S.of(context).AndWithWhitespaces, style: regTextTheme?.caption4),
                        TextSpan(
                          text: privacyCaptions.last.key,
                          style: regTextTheme?.caption4.copyWith(color: ColorsFoundation.darkNeutral600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.push(
                                  WebViewScreen(
                                    title: privacyCaptions.last.key,
                                    url: privacyCaptions.last.value.value ?? '',
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
                      onPressed: credentialsController.text.isEmpty || passwordController.text.isEmpty ? null : onSubmitted,
                      loading: loading,
                    ),
                  ),
                  SpacingFoundation.verticalSpace8,
                ],
              ).paddingSymmetric(
                horizontal: horizontalMargin,
                vertical: verticalMargin,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
