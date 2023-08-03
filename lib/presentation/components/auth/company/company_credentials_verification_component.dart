import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CompanyCredentialsVerificationComponent extends StatelessWidget {
  final UiCompanyCredentialsVerificationModel uiModel;
  final VoidCallback? onSubmitted;
  final ValueChanged<int>? onTabChanged;
  final ValueChanged<CountryModel>? onCountryChanged;
  final TextEditingController nameController;
  final TextEditingController positionController;
  final TextEditingController credentialsController;
  final GlobalKey<FormState> formKey;
  final bool? loading;

  const CompanyCredentialsVerificationComponent({
    super.key,
    required this.uiModel,
    required this.formKey,
    required this.nameController,
    required this.positionController,
    required this.credentialsController,
    this.loading,
    this.onSubmitted,
    this.onTabChanged,
    this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
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
                  height: MediaQuery.of(context).viewPadding.top + (SpacingFoundation.verticalSpacing24 * 2),
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
                SpacingFoundation.verticalSpace16,
                UiKitCardWrapper(
                  color: ColorsFoundation.surface1,
                  borderRadius: BorderRadiusFoundation.max,
                  child: UiKitInputFieldNoIcon(
                    controller: nameController,
                    hintText: 'Your Name'.toUpperCase(),
                    fillColor: ColorsFoundation.surface3,
                  ).paddingAll(EdgeInsetsFoundation.all4),
                ),
                SpacingFoundation.verticalSpace16,
                UiKitCardWrapper(
                  color: ColorsFoundation.surface1,
                  borderRadius: BorderRadiusFoundation.max,
                  child: UiKitInputFieldNoIcon(
                    controller: positionController,
                    hintText: 'Your Position'.toUpperCase(),
                    fillColor: ColorsFoundation.surface3,
                  ).paddingAll(EdgeInsetsFoundation.all4),
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
                context.button(
                  data: BaseUiKitButtonData(
                    text: 'get code'.toUpperCase(),
                    onPressed: onSubmitted,
                    loading: loading,
                  ),
                ),
                SpacingFoundation.verticalSpace24,
              ],
            ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
          ),
        ],
      ),
    );
  }
}
