import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CompanyProfileEditComponent extends StatelessWidget {
  final List<String> selectedPriceSegments;
  final List<String> selectedAgeRanges;
  final VoidCallback? onProfileEditSubmitted;
  final GlobalKey? formKey;
  final VoidCallback? onPriceSegmentChangeRequested;
  final VoidCallback? onAgeRangesChangeRequested;
  final VoidCallback? onPhotoChangeRequested;
  final ValueChanged<String>? onLanguageChanged;
  final ValueChanged<bool>? onIsLightThemeChanged;
  final String? avatarUrl;
  final UiKitMenuItem<int> selectedNiche;
  final VoidCallback? onNicheChanged;
  final bool hasChanges;

  final ValueChanged<List<String>>? onPreferencesChanged;
  final List<LocaleModel>? availableLocales;
  final String? Function(String?)? titleValidator;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? phoneValidator;
  final String? Function(String?)? contactPersonValidator;

  final TextEditingController contactPersonController;

  final TextEditingController titleController;

  final TextEditingController emailController;

  final TextEditingController positionController;
  final TextEditingController phoneController;
  final bool isLoading;
  final bool isLightTheme;
  final ScrollController scrollController;

  const CompanyProfileEditComponent({
    super.key,
    required this.selectedPriceSegments,
    required this.selectedAgeRanges,
    required this.selectedNiche,
    required this.scrollController,
    this.onLanguageChanged,
    this.onProfileEditSubmitted,
    this.formKey,
    this.onPhotoChangeRequested,
    this.onPreferencesChanged,
    this.titleValidator,
    this.emailValidator,
    this.avatarUrl,
    this.phoneValidator,
    this.availableLocales,
    this.contactPersonValidator,
    required this.contactPersonController,
    required this.titleController,
    required this.emailController,
    required this.positionController,
    required this.phoneController,
    this.onAgeRangesChangeRequested,
    this.onPriceSegmentChangeRequested,
    this.onIsLightThemeChanged,
    this.isLoading = false,
    this.isLightTheme = false,
    this.onNicheChanged,
    this.hasChanges = false,
  });

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentEditProfileModel model = ComponentEditProfileModel.fromJson(config['edit_profile']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final textTheme = context.uiKitTheme?.boldTextTheme;

    return Scaffold(
      body: Form(
        key: formKey,
        child: BlurredAppBarPage(
          title: S.of(context).EditProfile,
          autoImplyLeading: true,
          centerTitle: true,
          controller: scrollController,
          appBarBody: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularAvatar(
                avatarUrl: avatarUrl ?? '',
                name: contactPersonController.text,
                height: 48,
              ),
              SpacingFoundation.verticalSpace4,
              InkWell(
                onTap: onPhotoChangeRequested,
                child: Text(
                  S.of(context).ChangePhoto,
                  style: textTheme?.caption2Bold,
                ),
              ),
            ],
          ),
          childrenPadding: EdgeInsets.symmetric(
            horizontal: horizontalMargin,
          ),
          children: [
            if (onIsLightThemeChanged != null) ...[
              SpacingFoundation.verticalSpace16,
              Row(
                children: [
                  Text(S.of(context).WhiteTheme, style: context.uiKitTheme?.regularTextTheme.labelSmall),
                  SpacingFoundation.horizontalSpace16,
                  const Spacer(),
                  UiKitGradientSwitch(
                    switchedOn: isLightTheme,
                    onChanged: (value) => onIsLightThemeChanged!.call(value),
                  )
                ],
              ),
            ],
            SpacingFoundation.verticalSpace16,
            if (availableLocales != null && availableLocales!.isNotEmpty) ...[
              UiKitCardWrapper(
                color: context.uiKitTheme?.colorScheme.surface1,
                borderRadius: BorderRadiusFoundation.max,
                child: UiKitLocaleSelector(
                  selectedLocale: availableLocales!.firstWhere(
                    (localeModel) => localeModel.locale.languageCode == Intl.getCurrentLocale(),
                  ),
                  availableLocales: availableLocales!,
                  onLocaleChanged: (localeModel) {
                    onLanguageChanged?.call(localeModel.locale.languageCode);
                    context.findAncestorWidgetOfExactType<UiKitTheme>()?.onLocaleUpdated(
                          localeModel.locale,
                        );
                  },
                ),
              ),
              SpacingFoundation.verticalSpace16,
            ],
            UiKitInputFieldNoFill(
              controller: titleController,
              label: S.of(context).Title,
              validator: titleValidator,
            ),
            SpacingFoundation.verticalSpace16,
            UiKitInputFieldNoFill(
              controller: contactPersonController,
              label: S.of(context).ContactPerson,
              validator: contactPersonValidator,
              keyboardType: TextInputType.name,
            ),
            SpacingFoundation.verticalSpace16,
            UiKitInputFieldNoFill(
              controller: positionController,
              label: S.of(context).Position,
              validator: contactPersonValidator,
              inputFormatters: [dateInputFormatter],
            ),
            SpacingFoundation.verticalSpace16,
            UiKitInputFieldNoFill(
              prefixText: '+',
              controller: phoneController,
              label: S.of(context).Phone,
              validator: phoneValidator,
              keyboardType: TextInputType.phone,
              inputFormatters: [americanInputFormatter],
            ),
            SpacingFoundation.verticalSpace16,
            UiKitInputFieldNoFill(
              controller: emailController,
              label: S.of(context).Email,
              validator: emailValidator,
              keyboardType: TextInputType.emailAddress,
            ),
            SpacingFoundation.verticalSpace16,
            UiKitTitledSelectionTile(
              title: S.current.YourNiche,
              imagePath: selectedNiche.iconLink,
              onSelectionChanged: onNicheChanged,
              selectedItems: [selectedNiche.title],
            ),
            SpacingFoundation.verticalSpace16,
            UiKitTitledSelectionTile(
              onSelectionChanged: onPriceSegmentChangeRequested,
              selectedItems: selectedPriceSegments,
              title: S.of(context).YourPriceSegment,
            ),
            SpacingFoundation.verticalSpace16,
            UiKitTitledSelectionTile(
              onSelectionChanged: onAgeRangesChangeRequested,
              selectedItems: selectedAgeRanges,
              title: S.of(context).YourAudienceAge,
            ),
            SpacingFoundation.verticalSpace24,
          ],
        ),
      ),
      bottomNavigationBar: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(animation),
            child: MediaQuery.viewInsetsOf(context).bottom == 0 && hasChanges ? child : const SizedBox.shrink(),
          );
        },
        child: SizedBox(
          width: double.infinity,
          child: context
              .gradientButton(
                data: BaseUiKitButtonData(
                  text: S.of(context).Save.toUpperCase(),
                  loading: isLoading,
                  onPressed: onProfileEditSubmitted?.call,
                ),
              )
              .paddingOnly(
                left: horizontalMargin,
                right: horizontalMargin,
                bottom: EdgeInsetsFoundation.vertical24,
              ),
        ),
      ),
    );
  }
}
