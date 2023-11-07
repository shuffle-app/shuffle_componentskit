import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class CompanyProfileEditComponent extends StatelessWidget {
  final List<String> selectedAudience;
  final List<String> selectedAgeRanges;
  final VoidCallback? onProfileEditSubmitted;
  final GlobalKey? formKey;
  final VoidCallback? onAudienceChangeRequested;
  final VoidCallback? onAgeRangesChangeRequested;
  final VoidCallback? onPhotoChangeRequested;
  final VoidCallback? onNicheChangeRequested;
  final String? avatarUrl;
  final String selectedNiche;

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

  const CompanyProfileEditComponent({
    Key? key,
    required this.selectedAudience,
    required this.selectedAgeRanges,
    required this.selectedNiche,
    this.onProfileEditSubmitted,
    this.onNicheChangeRequested,
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
    this.onAudienceChangeRequested,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentEditProfileModel model = ComponentEditProfileModel.fromJson(config['edit_profile']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final textTheme = context.uiKitTheme?.boldTextTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        // wrapSliverBox: false,
        title: S.of(context).EditProfile,
        autoImplyLeading: true,
        centerTitle: true,
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
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (availableLocales != null && availableLocales!.isNotEmpty) ...[
                  UiKitCardWrapper(
                    color: context.uiKitTheme?.colorScheme.surface1,
                    borderRadius: BorderRadiusFoundation.max,
                    child: UiKitLocaleSelector(
                      selectedLocale: availableLocales!.firstWhere(
                        (localeModel) => localeModel.locale.languageCode == Intl.getCurrentLocale(),
                      ),
                      availableLocales: availableLocales!,
                      onLocaleChanged: (localeModel) =>
                          context.findAncestorWidgetOfExactType<UiKitTheme>()?.onLocaleUpdated(
                                localeModel.locale,
                              ),
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
                  onSelectionChanged: onNicheChangeRequested,
                  selectedItems: [selectedNiche],
                  title: S.of(context).YourNiche,
                ),
                SpacingFoundation.verticalSpace16,
                UiKitTitledSelectionTile(
                  onSelectionChanged: onAudienceChangeRequested,
                  selectedItems: selectedAudience,
                  title: S.of(context).YourAudience,
                ),
                SpacingFoundation.verticalSpace16,
                UiKitTitledSelectionTile(
                  onSelectionChanged: onAgeRangesChangeRequested,
                  selectedItems: selectedAgeRanges,
                  title: S.of(context).YourAudienceAge,
                ),
              ],
            ).paddingSymmetric(
              horizontal: horizontalMargin,
              vertical: verticalMargin,
            ),
          ),
        ),
      ),
      bottomNavigationBar: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        curve: Curves.bounceIn,
        opacity: MediaQuery.viewInsetsOf(context).bottom == 0 ? 1 : 0,
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
    );
  }
}
