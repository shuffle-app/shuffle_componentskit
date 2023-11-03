import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
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
  late final String title;
  late final String subtitle;
  late final String decorationLink;
  late final String countrySelectorTitle;
  late final RegistrationType? authType;
  late final String passwordHint;
  late final List<ShortLogInButton> socials;
  late final List<String>? tabBar;
  late final List<MapEntry<String, PropertiesBaseModel>> privacyCaptions;
  late final bool isSmallScreen;
  final FocusNode credentialsFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final config =
          GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
      final ComponentModel model = ComponentModel.fromJson(config['personal_credentials_verification']);
      horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
      verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
      title = model.content.title?[ContentItemType.text]?.properties?.keys.first ?? '';
      subtitle = model.content.subtitle?[ContentItemType.text]?.properties?.keys.first ?? '';
      decorationLink = model.content.properties?['image']?.imageLink ?? '';

      final captionTexts = Map<String, PropertiesBaseModel>.of(model.content.properties ?? {});

      captionTexts.remove('image');
      captionTexts.remove('auth_type');
      captionTexts.remove('password_hint');

      privacyCaptions = captionTexts.entries.toList();
      privacyCaptions.sort((a, b) => (a.value.sortNumber ?? 0).compareTo(b.value.sortNumber ?? 0));

      // final inputs = model.content.body?[ContentItemType.input]?.properties?.values.first;
      // final inputHint = model.content.body?[ContentItemType.input]?.title?[ContentItemType.text]?.properties?.keys.first;
      countrySelectorTitle =
          model.content.body?[ContentItemType.countrySelector]?.title?[ContentItemType.text]?.properties?.keys.first ??
              '';
      tabBar = model.content.body?[ContentItemType.tabBar]?.properties?.keys.toList();
      if (tabBar?.isNotEmpty ?? false) {
        if (_selectedTab == null) setState(() => _selectedTab = tabBar?.first);
      }
      authType = indentifyRegistrationType(model.content.properties?['auth_type']?.value ?? '');
      passwordHint = model.content.properties?['password_hint']?.value ?? '';
      final socialsData = model.content.body?[ContentItemType.verticalList]?.properties;
      socialsData?.entries.toList().sort((a, b) => a.value.sortNumber?.compareTo(b.value.sortNumber ?? 0) ?? 0);
      final clientType = Platform.isIOS ? 'iOS' : 'Android';
      socials = socialsData?.entries.where((element) => element.value.value != null).map<ShortLogInButton>((element) {
            return ShortLogInButton(
              iconPath: element.value.imageLink ?? '',
              title: element.key,
              onTap: () => widget.onSocialsLogin?.call(
                SocialsLoginModel(
                  provider: element.value.type!,
                  clientType: clientType,
                ),
              ),
            );
          }).toList() ??
          [];
      isSmallScreen = MediaQuery.sizeOf(context).width <= 375;
      tabController.addListener(_tabListener);
      setState(() => inited = true);
    });
  }

  void _tabListener() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _selectedTab = tabBar?.elementAt(tabController.index);
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
                title,
                style: textTheme?.titleLarge,
              ),
              SpacingFoundation.verticalSpace16,
              Text(
                subtitle,
                style: textTheme?.subHeadline,
              ),
              KeyboardVisibilityBuilder(builder: (context, visibility) {
                if (visibility) return SpacingFoundation.verticalSpace16;
                return Spacer(flex: isSmallScreen ? 2 : 1);
              }),
              KeyboardVisibilityBuilder(builder: (context, visibility) {
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
                              !visibility) ...[
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
                          if (tabBar != null && !visibility) ...[
                            UiKitCustomTabBar(
                              tabController: tabController,
                              selectedTab: _selectedTab,
                              tabs: tabBar!
                                  .map<UiKitCustomTab>((key) => UiKitCustomTab.small(title: key.toUpperCase()))
                                  .toList(),
                              onTappedTab: (tabIndex) {
                                setState(() {
                                  _selectedTab = tabBar!.elementAt(tabIndex);
                                  // tabController.animateTo(tabIndex);
                                });
                              },
                            ),
                            SpacingFoundation.verticalSpace16,
                          ],
                        ]));
              }),
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
                            hintText: 'EMAIL',
                            controller: widget.credentialsController,
                            fillColor: ColorsFoundation.surface3,
                            validator: widget.credentialsValidator,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          SpacingFoundation.verticalSpace16,
                          UiKitWrappedInputField.uiKitInputFieldRightIcon(
                            obscureText: obscurePassword,
                            enabled: true,
                            hintText: 'PASSWORD',
                            controller: widget.passwordController,
                            fillColor: ColorsFoundation.surface3,
                            validator: widget.passwordValidator,
                            icon: GestureDetector(
                              onTap: () => setState(() => obscurePassword = !obscurePassword),
                              child: obscurePassword
                                  ? ImageWidget(
                                      svgAsset: GraphicsFoundation.instance.svg.view,
                                      color: colorScheme?.darkNeutral900,
                                    )
                                  : GradientableWidget(
                                      gradient: GradientFoundation.defaultRadialGradient,
                                      child: ImageWidget(
                                        svgAsset: GraphicsFoundation.instance.svg.eyeOff,
                                        color: Colors.white,
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
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: 'By continuing you accept the ', style: regTextTheme?.caption4),
                  TextSpan(
                      text: privacyCaptions.first.key,
                      style: regTextTheme?.caption4.copyWith(color: ColorsFoundation.darkNeutral600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push(WebViewScreen(
                            title: privacyCaptions.first.key, url: privacyCaptions.first.value.value ?? ''))),
                  TextSpan(text: ' and ', style: regTextTheme?.caption4),
                  TextSpan(
                      text: privacyCaptions.last.key,
                      style: regTextTheme?.caption4.copyWith(color: ColorsFoundation.darkNeutral600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push(WebViewScreen(
                            title: privacyCaptions.last.key, url: privacyCaptions.last.value.value ?? '')))
                ]),
              ),
              KeyboardVisibilityBuilder(
                builder: (context, visible) => AnimatedSwitcher(
                  reverseDuration: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 300),
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
                            SpacingFoundation.verticalSpace16,
                            context.button(
                              data: BaseUiKitButtonData(
                                text: 'NEXT',
                                onPressed: widget.onSubmit,
                                loading: widget.loading,
                                fit: ButtonFit.fitWidth,
                              ),
                            ),
                          ],
                        )
                      : !visible
                          ? (16.h * 3).heightBox
                          : SpacingFoundation.none,
                ),
              ),
              SpacingFoundation.verticalSpace4,
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
