import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CredentialsVerificationComponent extends StatelessWidget {
  final UiCredentialsVerificationModel uiModel;
  final VoidCallback? onSubmit;
  final TextEditingController credentialsController;
  final ValueChanged<int>? onTabChanged;
  final ValueChanged<CountryModel>? onCountrySelected;

  const CredentialsVerificationComponent({
    super.key,
    required this.uiModel,
    this.onSubmit,
    this.onTabChanged,
    this.onCountrySelected,
    required this.credentialsController,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['phone_verification']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final title = model.content.title?[ContentItemType.text]?.properties?.keys.first ?? '';
    final subtitle = model.content.subtitle?[ContentItemType.text]?.properties?.keys.first ?? '';
    final decorationLink = model.content.decoration?.values.first;
    // final input = model.content.body?[ContentItemType.input]?.properties?.values.first;
    // final inputHint = model.content.body?[ContentItemType.input]?.title?[ContentItemType.text]?.properties?.keys.first;
    final countrySelectorTitle =
        model.content.body?[ContentItemType.countrySelector]?.title?[ContentItemType.text]?.properties?.keys.first ?? '';
    final tabBar = model.content.body?[ContentItemType.tabBar]?.properties;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          top: SpacingFoundation.verticalSpacing6,
          right: SpacingFoundation.horizontalSpacing16,
          child: ImageWidget(
            link: decorationLink?.imageLink ?? '',
            fit: BoxFit.fitWidth,
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
              title: countrySelectorTitle,
              onSelected: (country) => onCountrySelected?.call(country),
            ),
            SpacingFoundation.verticalSpace16,
            // if (uiModel.selectedTab == 'phone')
            UiKitPhoneNumberInput(
              enabled: true,
              controller: credentialsController,
            ),
            // if (uiModel.selectedTab == 'email')
            //   UiKitInputFieldNoIcon(
            //     controller: dataController,
            //     hintText: inputHint,
            //   ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'GET CODE',
                onPressed: onSubmit,
              ),
            ),
          ],
        ).paddingSymmetric(
          horizontal: horizontalMargin,
          vertical: verticalMargin,
        ),
      ],
    );
  }
}
