import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

  final String? Function(String?)? companyCredentialsValidator;

  const CompanyCredentialsVerificationComponent({
    super.key,
    required this.uiModel,
    required this.formKey,
    required this.credentialsController,
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
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['company_credentials_verification']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final title = model.content.title?[ContentItemType.text]?.properties?.keys.first ?? '';
    final subtitle = model.content.subtitle?[ContentItemType.text]?.properties?.keys.first ?? '';
    final decorationLink = model.content.properties?.values.first;
    final tabBar = model.content.body?[ContentItemType.tabBar]?.properties;
    final countrySelectorTitle =
        model.content.body?[ContentItemType.countrySelector]?.title?[ContentItemType.text]?.properties?.keys.first ??
            '';

    final captionTexts = Map<String, PropertiesBaseModel>.of(model.content.properties ?? {});

    captionTexts.remove('image');

    final list = captionTexts.entries.toList();
    list.sort((a, b) => (a.value.sortNumber ?? 0).compareTo(b.value.sortNumber ?? 0));

    return Form(
      key: formKey,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            width: 1.sw,
            right: SpacingFoundation.horizontalSpacing16,
            top: MediaQuery.of(context).viewPadding.top + SpacingFoundation.verticalSpacing6,
            child: ImageWidget(
              link: decorationLink?.imageLink ?? '',
              fit: BoxFit.fitWidth,
              width: 1.sw,
            ),
          ),
          Positioned(
            width: 1.sw,
            height: 1.sh,
            bottom: SpacingFoundation.zero,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top,
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
                if (tabBar != null) ...[
                  UiKitCustomTabBar(
                    tabs: tabBar.keys.map<UiKitCustomTab>((key) => UiKitCustomTab(title: key)).toList(),
                    onTappedTab: (tabIndex) => onTabChanged?.call(tabIndex),
                  ),
                  SpacingFoundation.verticalSpace16,
                ],
                UiKitCountrySelector(
                  selectedCountry: uiModel.selectedCountry,
                  onSelected: (country) => onCountryChanged?.call(country),
                  title: countrySelectorTitle,
                ),
                if (uiModel.selectedRegistrationType == RegistrationType.phone) ...[
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
                if (uiModel.selectedRegistrationType == RegistrationType.email) ...[
                  SpacingFoundation.verticalSpace16,
                  UiKitCardWrapper(
                    color: ColorsFoundation.surface1,
                    borderRadius: BorderRadiusFoundation.max,
                    child: UiKitInputFieldNoIcon(
                      fillColor: ColorsFoundation.surface3,
                      controller: credentialsController,
                      hintText: 'Johndoe@gmail.com',
                    ).paddingAll(EdgeInsetsFoundation.all4),
                  ),
                ],
                SpacingFoundation.verticalSpace16,
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: S.of(context).ByContinuingYouAcceptThe, style: regTextTheme?.caption4),
                    TextSpan(
                        text: list.first.key,
                        style: regTextTheme?.caption4.copyWith(color: ColorsFoundation.darkNeutral600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              context.push(WebViewScreen(title: list.first.key, url: list.first.value.value ?? ''))),
                    TextSpan(text: S.of(context).AndWithWhitespaces.toLowerCase(), style: regTextTheme?.caption4),
                    TextSpan(
                        text: list.last.key,
                        style: regTextTheme?.caption4.copyWith(color: ColorsFoundation.darkNeutral600),
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => context.push(WebViewScreen(title: list.last.key, url: list.last.value.value ?? '')))
                  ]),
                ),
                SpacingFoundation.verticalSpace16,
                context.button(
                  data: BaseUiKitButtonData(
                    text: S.of(context).GetCode.toUpperCase(),
                    onPressed: onSubmitted,
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
        ],
      ),
    );
  }
}
