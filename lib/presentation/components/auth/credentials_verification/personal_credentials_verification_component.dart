import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PersonalCredentialsVerificationComponent extends StatelessWidget {
  final UiPersonalCredentialsVerificationModel uiModel;
  final VoidCallback? onSubmit;
  final TextEditingController credentialsController;
  final ValueChanged<int>? onTabChanged;
  final ValueChanged<CountryModel>? onCountrySelected;
  final GlobalKey<FormState> formKey;
  final String? Function(String?)? credentialsValidator;
  final bool? loading;

  const PersonalCredentialsVerificationComponent({
    super.key,
    required this.uiModel,
    required this.formKey,
    this.loading,
    this.onSubmit,
    this.onTabChanged,
    this.onCountrySelected,
    this.credentialsValidator,
    required this.credentialsController,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['personal_credentials_verification']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final title = model.content.title?[ContentItemType.text]?.properties?.keys.first ?? '';
    final subtitle = model.content.subtitle?[ContentItemType.text]?.properties?.keys.first ?? '';
    final decorationLink = model.content.properties?.values.first;
    // final inputs = model.content.body?[ContentItemType.input]?.properties?.values.first;
    // final inputHint = model.content.body?[ContentItemType.input]?.title?[ContentItemType.text]?.properties?.keys.first;
    final countrySelectorTitle =
        model.content.body?[ContentItemType.countrySelector]?.title?[ContentItemType.text]?.properties?.keys.first ?? '';
    final tabBar = model.content.body?[ContentItemType.tabBar]?.properties;

    return Form(
      key: formKey,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + SpacingFoundation.verticalSpacing6,
            right: SpacingFoundation.horizontalSpacing16,
            child: ImageWidget(
              link: decorationLink?.imageLink ?? '',
              fit: BoxFit.fitWidth,
              width: 1.sw,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MediaQuery.of(context).viewPadding.top + SpacingFoundation.verticalSpacing16,
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
                title: countrySelectorTitle,
                onSelected: (country) => onCountrySelected?.call(country),
              ),
              SpacingFoundation.verticalSpace16,
              // if (uiModel.selectedTab == 'phone')
              UiKitCardWrapper(
                color: ColorsFoundation.surface1,
                borderRadius: BorderRadiusFoundation.max,
                child: UiKitPhoneNumberInput(
                  enabled: true,
                  controller: credentialsController,
                  countryCode: uiModel.selectedCountry?.countryPhoneCode ?? '',
                  fillColor: ColorsFoundation.surface3,
                  validator: credentialsValidator,
                ).paddingAll(EdgeInsetsFoundation.all4),
              ),
              // if (uiModel.selectedTab == 'email')
              //   UiKitInputFieldNoIcon(
              //     controller: credentialsController,
              //     hintText: inputHint,
              //   ),
              SpacingFoundation.verticalSpace16,
              context.button(
                data: BaseUiKitButtonData(
                  text: 'GET CODE',
                  onPressed: onSubmit,
                  loading: loading,
                ),
              ),
            ],
          ).paddingSymmetric(
            horizontal: horizontalMargin,
            vertical: verticalMargin,
          ),
        ],
      ),
    );
  }
}
