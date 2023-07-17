import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/auth/company/ui_company_login_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CompanyLoginComponent extends StatelessWidget {
  final UiCompanyLoginModel model;
  final VoidCallback? onSubmitted;
  final ValueChanged<RegistrationType>? onRegistrationTypeChanged;
  final TextEditingController nameController;
  final TextEditingController positionController;
  final TextEditingController anotherFieldController;

  const CompanyLoginComponent({
    super.key,
    required this.model,
    this.onSubmitted,
    this.onRegistrationTypeChanged,
    required this.nameController,
    required this.positionController,
    required this.anotherFieldController,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            width: 1.sw,
            top: SpacingFoundation.verticalSpacing6,
            left: -SpacingFoundation.horizontalSpacing16,
            child: ImageWidget(
              svgAsset: GraphicsFoundation.instance.svg.bigArrow,
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
                  model.welcomeMessageTitle ?? '',
                  style: boldTextTheme?.titleLarge,
                ),
                SpacingFoundation.verticalSpace16,
                Text(
                  model.welcomeMessageBody ?? '',
                  style: boldTextTheme?.subHeadline,
                ),
                const Spacer(),
                if (model.registrationTypes != null && model.registrationTypes!.length > 1) ...[
                  UiKitCustomTabBar(
                    tabs: model.registrationTypes!.map((e) => UiKitCustomTab(title: e.title)).toList(),
                    onTappedTab: (index) => onRegistrationTypeChanged?.call(
                      model.registrationTypes![index].type,
                    ),
                  ),
                  SpacingFoundation.verticalSpace16,
                ],
                UiKitCountrySelector(
                  selectedCountry: model.selectedCountry,
                  onSelected: (country) => onRegistrationTypeChanged?.call(
                    RegistrationType.phone,
                  ),
                  title: 'Where are you located',
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
                if (model.selectedRegistrationType == RegistrationType.phone) ...[
                  SpacingFoundation.verticalSpace16,
                  UiKitCardWrapper(
                    color: ColorsFoundation.surface1,
                    borderRadius: BorderRadiusFoundation.max,
                    child: UiKitPhoneNumberInput(
                      controller: anotherFieldController,
                      enabled: true,
                      fillColor: ColorsFoundation.surface3,
                      countryCode: model.selectedCountry?.countryPhoneCode ?? '',
                    ).paddingAll(EdgeInsetsFoundation.all4),
                  ),
                ],
                if (model.selectedRegistrationType == RegistrationType.email) ...[
                  SpacingFoundation.verticalSpace16,
                  UiKitCardWrapper(
                    color: ColorsFoundation.surface1,
                    borderRadius: BorderRadiusFoundation.max,
                    child: UiKitInputFieldNoIcon(
                      fillColor: ColorsFoundation.surface3,
                      controller: anotherFieldController,
                      hintText: 'Johndoe@gmail.com',
                    ).paddingAll(EdgeInsetsFoundation.all4),
                  ),
                ],
                SpacingFoundation.verticalSpace16,
                context.button(
                  data: BaseUiKitButtonData(
                    text: 'get code'.toUpperCase(),
                    onPressed: onSubmitted,
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
          ),
        ],
      ),
    );
  }
}
