import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class EditProfileDefaultComponent extends StatelessWidget {
  final List<String> selectedPreferences;
  final UiKitMenuItem<String> activityItem;
  final VoidCallback? onProfileEditSubmitted;
  final GlobalKey? formKey;
  final VoidCallback? onPreferencesChangeRequested;
  final VoidCallback? onPhotoChangeRequested;
  final VoidCallback? onPremiumAccountRequested;
  final VoidCallback? onProAccountRequested;
  final VoidCallback? onActivityTileTap;
  final ValueChanged<bool> onBeInSearchChanged;
  final List<LocaleModel>? availableLocales;
  final ValueChanged<bool>? onIsLightThemeChanged;
  final String? avatarUrl;

  final ValueChanged<List<String>>? onPreferencesChanged;
  final ValueChanged<String>? onLocaleUpdated;
  final String? Function(String?)? nameValidator;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? phoneValidator;
  final String? Function(String?)? dateOfBirthValidator;

  final TextEditingController nameController;
  final TextEditingController nickNameController;
  final TextEditingController emailController;
  final TextEditingController dateOfBirthController;
  final TextEditingController phoneController;
  final bool isLightTheme;
  final bool beInSearch;
  final bool isLoading;

  const EditProfileDefaultComponent({
    Key? key,
    this.onProfileEditSubmitted,
    this.onPremiumAccountRequested,
    this.onProAccountRequested,
    this.formKey,
    this.onPhotoChangeRequested,
    this.onPreferencesChanged,
    this.onLocaleUpdated,
    this.nameValidator,
    this.emailValidator,
    this.avatarUrl,
    this.phoneValidator,
    this.dateOfBirthValidator,
    this.onPreferencesChangeRequested,
    this.onActivityTileTap,
    this.availableLocales,
    this.isLoading = false,
    this.isLightTheme = false,
    this.onIsLightThemeChanged,
    required this.onBeInSearchChanged,
    required this.selectedPreferences,
    required this.nameController,
    required this.nickNameController,
    required this.emailController,
    required this.dateOfBirthController,
    required this.phoneController,
    required this.beInSearch,
    required this.activityItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentEditProfileModel model = ComponentEditProfileModel.fromJson(config['edit_profile']);
    final hintTitle = model.content.body?[ContentItemType.popover]?.title?[ContentItemType.text]?.properties?.keys.first ?? '';
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? EdgeInsetsFoundation.horizontal16).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final textTheme = context.uiKitTheme?.boldTextTheme;
    final theme = context.uiKitTheme;

    return Scaffold(
      body: Form(
        key: formKey,
        child: BlurredAppBarPage(
          title: S.of(context).EditProfile,
          autoImplyLeading: true,
          centerTitle: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          childrenPadding: EdgeInsets.symmetric(
            horizontal: horizontalMargin,
          ),
          appBarBody: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onPhotoChangeRequested,
                child: Ink(
                  child: CircularAvatar(
                    avatarUrl: avatarUrl ?? '',
                    name: nameController.text,
                    height: 0.15.sw,
                  ),
                ),
              ),
              InkWell(
                onTap: onPhotoChangeRequested,
                child: Text(
                  S.of(context).ChangePhoto,
                  style: textTheme?.caption2Bold,
                ),
              ),
            ],
          ),
          children: [
            verticalMargin.heightBox,
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: context.smallButton(
                    blurred: false,
                    data: BaseUiKitButtonData(
                      fit: ButtonFit.fitWidth,
                      text: S.of(context).Premium.toUpperCase(),
                      iconInfo: BaseUiKitButtonIconData(
                        iconData: ShuffleUiKitIcons.star2,
                      ),
                      onPressed: onPremiumAccountRequested,
                    ),
                  ),
                ),
                SpacingFoundation.horizontalSpace16,
                Expanded(
                  child: context.smallButton(
                    blurred: false,
                    data: BaseUiKitButtonData(
                      fit: ButtonFit.fitWidth,
                      text: S.of(context).Pro.toUpperCase(),
                      onPressed: onProAccountRequested,
                    ),
                  ),
                ),
              ],
            ),
            SpacingFoundation.verticalSpace16,
            Row(
              children: [
                Text(
                  S.of(context).BeInSearch,
                  style: theme?.regularTextTheme.labelSmall,
                ),
                SpacingFoundation.horizontalSpace16,
                Builder(
                  builder: (context) {
                    return GestureDetector(
                      onTap: () => showUiKitPopover(
                        context,
                        showButton: false,
                        title: Text(
                          hintTitle,
                          style: theme?.regularTextTheme.body.copyWith(
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      child: ImageWidget(
                        iconData: ShuffleUiKitIcons.info,
                        width: 16.w,
                        color: theme?.colorScheme.darkNeutral900,
                      ),
                    );
                  },
                ),
                const Spacer(),
                UiKitGradientSwitch(
                  switchedOn: beInSearch,
                  onChanged: (value) => onBeInSearchChanged.call(value),
                ),
              ],
            ),
            if (onIsLightThemeChanged != null) ...[
              SpacingFoundation.verticalSpace16,
              Row(
                children: [
                  Text(S.of(context).WhiteTheme, style: theme?.regularTextTheme.labelSmall),
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
                color: theme?.colorScheme.surface1,
                borderRadius: BorderRadiusFoundation.max,
                child: UiKitLocaleSelector(
                  selectedLocale: availableLocales!.firstWhere(
                    (localeModel) => localeModel.locale.languageCode == Intl.getCurrentLocale(),
                  ),
                  availableLocales: availableLocales!,
                  onLocaleChanged: (localeModel) {
                    onLocaleUpdated?.call(localeModel.locale.languageCode);
                    context.findAncestorWidgetOfExactType<UiKitTheme>()?.onLocaleUpdated(
                          localeModel.locale,
                        );
                  },
                ),
              ),
              SpacingFoundation.verticalSpace16,
            ],
            UiKitInputFieldNoFill(
              controller: nameController,
              label: S.of(context).Name,
              hintText: S.of(context).Name,
              validator: nameValidator,
              keyboardType: TextInputType.name,
            ),
            SpacingFoundation.verticalSpace16,
            UiKitInputFieldNoFill(
              controller: nickNameController,
              label: S.of(context).Nickname,
              hintText: S.of(context).Nickname,
              validator: nameValidator,
            ),
            SpacingFoundation.verticalSpace16,
            GestureDetector(
              onTap: () => showUiKitCalendarDialog(context, firstDate: DateTime(1960, 1, 1)).then((d) {
                if (d != null) {
                  dateOfBirthController.text = '${leadingZeros(d.day)}.${leadingZeros(d.month)}.${d.year}';
                }
              }),
              child: AbsorbPointer(
                child: UiKitInputFieldNoFill(
                  controller: dateOfBirthController,
                  label: S.of(context).DateOfBirth,
                  hintText: S.of(context).DateOfBirth,
                  validator: dateOfBirthValidator,
                  inputFormatters: [dateInputFormatter],
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            UiKitInputFieldNoFill(
              controller: phoneController,
              label: S.of(context).Phone,
              hintText: S.of(context).Phone,
              validator: phoneValidator,
              keyboardType: TextInputType.phone,
              inputFormatters: [americanInputFormatter],
            ),
            SpacingFoundation.verticalSpace16,
            UiKitInputFieldNoFill(
              controller: emailController,
              label: S.of(context).Email,
              hintText: S.of(context).Email,
              validator: emailValidator,
              keyboardType: TextInputType.emailAddress,
            ),
            SpacingFoundation.verticalSpace16,
            Text(
              S.of(context).ActivityType,
              style: context.uiKitTheme?.regularTextTheme.labelSmall,
            ),
            SpacingFoundation.verticalSpace4,
            UiKitMenuItemTile.custom(
              paddingSymmetric: EdgeInsets.zero,
              onTap: onActivityTileTap,
              item: activityItem,
              autoPopUp: false,
            ),
            SpacingFoundation.verticalSpace16,
            UiKitTitledSelectionTile(
              onSelectionChanged: onPreferencesChangeRequested,
              selectedItems: selectedPreferences,
              title: S.of(context).Preferences,
            ),
            verticalMargin.heightBox,
          ],
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
