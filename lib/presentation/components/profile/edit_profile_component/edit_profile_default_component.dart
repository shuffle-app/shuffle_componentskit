import 'package:flutter/material.dart';
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
  final String? avatarUrl;

  final ValueChanged<List<String>>? onPreferencesChanged;
  final String? Function(String?)? nameValidator;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? phoneValidator;
  final String? Function(String?)? dateOfBirthValidator;

  final TextEditingController nameController;
  final TextEditingController nickNameController;
  final TextEditingController emailController;
  final TextEditingController dateOfBirthController;
  final TextEditingController phoneController;
  final bool isLoading;

  const EditProfileDefaultComponent({
    Key? key,
    this.onProfileEditSubmitted,
    this.onPremiumAccountRequested,
    this.onProAccountRequested,
    this.formKey,
    this.onPhotoChangeRequested,
    this.onPreferencesChanged,
    this.nameValidator,
    this.emailValidator,
    this.avatarUrl,
    this.phoneValidator,
    this.dateOfBirthValidator,
    this.onPreferencesChangeRequested,
    this.onActivityTileTap,
    this.isLoading = false,
    required this.selectedPreferences,
    required this.nameController,
    required this.nickNameController,
    required this.emailController,
    required this.dateOfBirthController,
    required this.phoneController,
    required this.activityItem,
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
        title: 'Edit Profile',
        autoImplyLeading: true,
        centerTitle: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                'Change Photo',
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
                SpacingFoundation.verticalSpace16,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: context.smallButton(
                        blurred: false,
                        data: BaseUiKitButtonData(
                          fit: ButtonFit.fitWidth,
                          text: 'PREMIUM',
                          icon: ImageWidget(
                            svgAsset: GraphicsFoundation.instance.svg.star2,
                            color: Colors.black,
                            height: 18,
                            fit: BoxFit.fitHeight,
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
                          text: 'PRO',
                          onPressed: onProAccountRequested,
                        ),
                      ),
                    ),
                  ],
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  controller: nameController,
                  label: 'Name',
                  hintText: 'Name',
                  validator: nameValidator,
                  keyboardType: TextInputType.name,
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  controller: nickNameController,
                  label: 'Nickname',
                  hintText: 'Nickname',
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
                      label: 'Date of birth',
                      hintText: 'Date of birth',
                      validator: dateOfBirthValidator,
                      inputFormatters: [dateInputFormatter],
                    ),
                  ),
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  prefixText: '+',
                  controller: phoneController,
                  label: 'Phone',
                  hintText: 'Phone',
                  validator: phoneValidator,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [americanInputFormatter],
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  controller: emailController,
                  label: 'Email',
                  hintText: 'Email',
                  validator: emailValidator,
                  keyboardType: TextInputType.emailAddress,
                ),
                SpacingFoundation.verticalSpace16,
                Text(
                  'Activity type',
                  style: context.uiKitTheme?.regularTextTheme.labelSmall,
                ),
                SpacingFoundation.verticalSpace4,
                UiKitMenuItemTile.custom(
                  paddingSymmetric: EdgeInsets.zero,
                  onTap: onActivityTileTap,
                  item: activityItem,
                  autoPopUp: false,
                  showSeparator: false,
                ),
                SpacingFoundation.verticalSpace16,
                UiKitTitledSelectionTile(
                  onSelectionChanged: onPreferencesChangeRequested,
                  selectedItems: selectedPreferences,
                  title: 'Preferences',
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
                text: 'SAVE',
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
