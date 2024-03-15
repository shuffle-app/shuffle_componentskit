import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/presentation/utils/policies_localization_getter.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PersonalCredentialsVerificationComponent extends StatefulWidget {
  final UiPersonalCredentialsVerificationModel uiModel;
  final VoidCallback? onSubmit;
  final TextEditingController credentialsController;
  final TextEditingController passwordController;
  final ValueChanged<CountryModel>? onCountrySelected;
  final GlobalKey<FormState> formKey;
  final String? Function(String?)? credentialsValidator;
  final String? Function(String?)? passwordValidator;
  final ValueChanged<SocialsLoginModel>? onSocialsLogin;
  final bool? loading;
  final List<LocaleModel>? availableLocales;

  const PersonalCredentialsVerificationComponent({
    super.key,
    required this.uiModel,
    required this.formKey,
    this.loading,
    this.onSubmit,
    this.availableLocales,
    this.onCountrySelected,
    this.credentialsValidator,
    this.passwordValidator,
    this.onSocialsLogin,
    required this.credentialsController,
    required this.passwordController,
  });

  @override
  State<PersonalCredentialsVerificationComponent> createState() => _PersonalCredentialsVerificationComponentState();
}

class _PersonalCredentialsVerificationComponentState extends State<PersonalCredentialsVerificationComponent>
    with SingleTickerProviderStateMixin {
  String? _selectedTab;
  late final tabController = TabController(length: 2, vsync: this);
  bool inited = false;
  late final double horizontalMargin;
  late final double verticalMargin;
  late final String decorationLink;
  late final String countrySelectorTitle;
  late final RegistrationType? authType;

  List<ShortLogInButton> get socials => [
        ShortLogInButton(
          link: GraphicsFoundation.instance.svg.googleLogo.path,
          title: S.current.LoginWith('google').toUpperCase(),
          onTap: () => widget.onSocialsLogin?.call(
            SocialsLoginModel(
              provider: 'google',
              clientType: clientType,
            ),
          ),
        ),
      ];
  late final bool isSmallScreen;
  late final String clientType;
  final FocusNode credentialsFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  bool obscurePassword = true;

  List<UiKitCustomTab> get tabs => [
        UiKitCustomTab.small(title: 'EMAIL', customValue: 'email'),
        UiKitCustomTab.small(title: S.current.Account.toUpperCase(), customValue: 'account'),
      ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final config =
          GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
      final ComponentModel model = ComponentModel.fromJson(config['personal_credentials_verification']);
      horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
      verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
      decorationLink = model.content.properties?['image']?.imageLink ?? GraphicsFoundation.instance.svg.bigArrow.path;

      final captionTexts = Map<String, PropertiesBaseModel>.of(model.content.properties ?? {});

      captionTexts.remove('image');
      captionTexts.remove('auth_type');
      clientType = Platform.isIOS ? 'Ios' : 'Android';
      // final inputs = model.content.body?[ContentItemType.input]?.properties?.values.first;
      // final inputHint = model.content.body?[ContentItemType.input]?.title?[ContentItemType.text]?.properties?.keys.first;
      countrySelectorTitle =
          model.content.body?[ContentItemType.countrySelector]?.title?[ContentItemType.text]?.properties?.keys.first ??
              '';
      authType = indentifyRegistrationType(model.content.properties?['auth_type']?.value ?? '');
      // final socialsData = model.content.body?[ContentItemType.verticalList]?.properties;
      // socialsData?.entries.toList().sort((a, b) => a.value.sortNumber?.compareTo(b.value.sortNumber ?? 0) ?? 0);
      // socials = socialsData?.entries.where((element) => element.value.value != null).map<ShortLogInButton>((element) {
      //       return ShortLogInButton(
      //         link: element.value.imageLink ?? '',
      //         title: element.key,
      //         onTap: () => widget.onSocialsLogin?.call(
      //           SocialsLoginModel(
      //             provider: element.value.type!,
      //             clientType: clientType,
      //           ),
      //         ),
      //       );
      //     }).toList() ??
      //     [];

      isSmallScreen = MediaQuery.sizeOf(context).width <= 375;
      tabController.addListener(_tabListener);
      setState(() => inited = true);
    });
  }

  void _tabListener() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _selectedTab = tabs.elementAt(tabController.index).customValue;
    });
  }

  @override
  void dispose() {
    tabController.removeListener(_tabListener);
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;
    final regTextTheme = context.uiKitTheme?.regularTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;

    if (!inited) return const LoadingWidget();

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: MediaQuery.viewPaddingOf(context).top + SpacingFoundation.verticalSpacing6,
          right: SpacingFoundation.horizontalSpacing16,
          child: ImageWidget(
            link: decorationLink,
            fit: BoxFit.fitWidth,
            width: 1.sw,
          ),
        ),
        Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MediaQuery.viewPaddingOf(context).top,
              ),
              Text(
                S.current.CredentialsVerificationTitle,
                style: textTheme?.titleLarge,
              ),
              SpacingFoundation.verticalSpace16,
              Text(
                S.current.CredentialsVerificationPrompt,
                style: textTheme?.subHeadline,
              ),
              KeyboardVisibilityBuilder(builder: (context, visibility) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: visibility
                      ? SpacingFoundation.verticalSpacing16
                      : isSmallScreen
                          ? 0.05.sh
                          : 0.2.sh,
                );
              }),
              KeyboardVisibilityBuilder(
                builder: (context, keyboardVisible) {
                  return AnimatedSwitcher(
                    reverseDuration: const Duration(milliseconds: 250),
                    duration: const Duration(milliseconds: 125),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // const Spacer(flex: 1),
                        if (widget.availableLocales != null &&
                            widget.availableLocales!.isNotEmpty &&
                            !keyboardVisible) ...[
                          UiKitCardWrapper(
                            color: colorScheme?.surface1,
                            borderRadius: BorderRadiusFoundation.max,
                            child: UiKitLocaleSelector(
                                selectedLocale: widget.availableLocales!
                                    .firstWhere((element) => element.locale.languageCode == Intl.getCurrentLocale()),
                                availableLocales: widget.availableLocales!,
                                onLocaleChanged: (LocaleModel value) {
                                  context.findAncestorWidgetOfExactType<UiKitTheme>()?.onLocaleUpdated(value.locale);
                                  setState(() {});
                                }).paddingAll(EdgeInsetsFoundation.all4),
                          ),
                          SpacingFoundation.verticalSpace16
                        ],
                        if (!keyboardVisible) ...[
                          UiKitCustomTabBar(
                            tabController: tabController,
                            selectedTab: _selectedTab,
                            tabs: tabs,
                            onTappedTab: (tabIndex) {
                              setState(() {
                                _selectedTab = tabs.elementAt(tabIndex).customValue;
                                // tabController.animateTo(tabIndex);
                              });
                            },
                          ),
                          SpacingFoundation.verticalSpace16,
                        ] else
                          isSmallScreen ? const SizedBox.shrink() : 20.h.heightBox
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                flex: isSmallScreen ? 7 : 2,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Column(
                      children: [
                        if (authType == RegistrationType.phone) ...[
                          UiKitCountrySelector(
                            selectedCountry: widget.uiModel.selectedCountry,
                            title: countrySelectorTitle,
                            onSelected: (country) => widget.onCountrySelected?.call(country),
                          ),
                          SpacingFoundation.verticalSpace16,
                          UiKitCardWrapper(
                            color: ColorsFoundation.surface1,
                            borderRadius: BorderRadiusFoundation.max,
                            child: UiKitPhoneNumberInput(
                              enabled: true,
                              controller: widget.credentialsController,
                              countryCode: widget.uiModel.selectedCountry?.countryPhoneCode ?? '',
                              fillColor: ColorsFoundation.surface3,
                              validator: widget.credentialsValidator,
                            ).paddingAll(EdgeInsetsFoundation.all4),
                          ),
                          SpacingFoundation.verticalSpace16,
                        ],
                        if (authType == RegistrationType.email) ...[
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
                            style: regTextTheme?.caption4,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                    Column(
                      children: [
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return socials.elementAt(index);
                          },
                          separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
                          itemCount: socials.length,
                        ),
                        if (tabController.index >= 1) SpacingFoundation.verticalSpace16,
                      ],
                    ),
                  ],
                ),
              ),
              KeyboardVisibilityBuilder(
                builder: (context, visible) => AnimatedSwitcher(
                  reverseDuration: const Duration(milliseconds: 50),
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) => SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                  child: tabController.index < 1 && !visible
                      ? Column(
                          children: [
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
                                onPressed:
                                    widget.passwordController.text.isEmpty || widget.credentialsController.text.isEmpty
                                        ? null
                                        : widget.onSubmit,
                                loading: widget.loading,
                                fit: ButtonFit.fitWidth,
                              ),
                            ),
                            SpacingFoundation.verticalSpace4,
                          ],
                        )
                      : !visible
                          ? (16.h * 3).heightBox
                          : SpacingFoundation.none,
                ),
              ),
            ],
          ).paddingSymmetric(
            horizontal: horizontalMargin,
            vertical: verticalMargin,
          ),
        ),
      ],
    );
  }
}
