import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class EditProfileDefaultComponent extends StatelessWidget {
  final List<String> selectedPreferences;
  final VoidCallback? onProfileEditSubmitted;
  final GlobalKey? formKey;
  final VoidCallback? onPreferencesChangeRequested;
  final ValueChanged<String>? onPhotoChanged;

  final ValueChanged<List<String>>? onPreferencesChanged;
  final String? Function(String?)? textValidator;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? phoneValidator;
  final String? Function(String?)? dateOfBirthValidator;

  final TextEditingController nameController;

  final TextEditingController nickNameController;

  final TextEditingController emailController;

  final TextEditingController dateOfBirthController;
  final TextEditingController phoneController;

  const EditProfileDefaultComponent({
    Key? key,
    required this.selectedPreferences,
    this.onProfileEditSubmitted,
    this.formKey,
    this.onPhotoChanged,
    this.onPreferencesChanged,
    this.textValidator,
    this.emailValidator,
    this.phoneValidator,
    this.dateOfBirthValidator,
    required this.nameController,
    required this.nickNameController,
    required this.emailController,
    required this.dateOfBirthController,
    required this.phoneController,
     this.onPreferencesChangeRequested,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentEditProfileModel model =
        ComponentEditProfileModel.fromJson(config['edit_profile']);
    final horizontalMargin =
        (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin =
        (model.positionModel?.verticalMargin ?? 0).toDouble();
    final textTheme = context.uiKitTheme?.boldTextTheme;

    return Scaffold(
      body: BlurredAppBarPage(
          title: 'Edit Profile',
          autoImplyLeading: true,
          centerTitle: true,
          appBarBody: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageWidget(
                rasterAsset: GraphicsFoundation.instance.png.mockUserAvatar,
                height: 48,
              ),
              SpacingFoundation.verticalSpace4,
              Text(
                'Change Photo',
                style: textTheme?.caption2Bold,
              ),
            ],
          ),
          body: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UiKitInputFieldNoFill(
                  controller: nameController,
                  label: 'Name',
                  validator: textValidator,
                  keyboardType: TextInputType.name,
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  controller: nickNameController,
                  label: 'Nickname',
                  validator: textValidator,
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  controller: dateOfBirthController,
                  label: 'Date of birth',
                  validator: dateOfBirthValidator,
                  inputFormatters: [dateInputFormatter],
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  prefixText: '+',
                  controller: phoneController,
                  label: 'Phone',
                  validator: phoneValidator,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [americanInputFormatter],
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoFill(
                  controller: emailController,
                  label: 'Email',
                  validator: emailValidator,
                  keyboardType: TextInputType.emailAddress,
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
          )),
      bottomSheet: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0,
        child: context
            .gradientButton(
              text: 'SAVE',
              onPressed: () => onProfileEditSubmitted?.call(),
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
