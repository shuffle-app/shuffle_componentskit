import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/profile/edit_profile_component/ui_edit_profile_model.dart';
import 'package:shuffle_components_kit/presentation/utils/input_formatters.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class EditProfileComponent extends StatelessWidget {
  final UiEditProfileModel editProfileModel;
  final ValueChanged<UiEditProfileModel>? onProfileEditSubmitted;
  final ValueChanged<String>? onPhotoChanged;

  final ValueChanged<List<String>>? onPreferencesChanged;
  final String? Function(String?)? textValidator;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? phoneValidator;
  final String? Function(String?)? dateOfBirthValidator;

  late final TextEditingController nameController = TextEditingController(text: editProfileModel.name);
  late final TextEditingController nickNameController = TextEditingController(text: editProfileModel.nickName);
  late final TextEditingController emailController = TextEditingController(text: editProfileModel.email);
  late final TextEditingController dateOfBirthController = TextEditingController(text: editProfileModel.dateOfBirth);
  late final TextEditingController phoneController = TextEditingController(text: editProfileModel.phone);

  EditProfileComponent({
    Key? key,
    required this.editProfileModel,
    this.onProfileEditSubmitted,
    this.onPhotoChanged,
    this.onPreferencesChanged,
    this.textValidator,
    this.emailValidator,
    this.phoneValidator,
    this.dateOfBirthValidator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    // final ComponentEditProfileModel model = ComponentEditProfileModel.fromJson(config['edit_profile']);
    // final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    // final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UiKitInputFieldNoFill(
              controller: nameController,
              label: 'Name',
              validator: textValidator,
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
              inputFormatters: [americanInputFormatter],
            ),
            SpacingFoundation.verticalSpace16,
            UiKitInputFieldNoFill(
              controller: emailController,
              label: 'Email',
              validator: emailValidator,
            ),
            SpacingFoundation.verticalSpace16,
            UiKitTitledSelectionTile(
              onSelectionChanged: () {
                /// push to screen and get preferences and update ui model
              },
              selectedItems: editProfileModel.preferences,
              title: 'Preferences',
            ),
          ],
        ).paddingSymmetric(
          horizontal: EdgeInsetsFoundation.horizontal16,
          vertical: EdgeInsetsFoundation.vertical16,
        ),
      ),
      bottomSheet: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0,
        child: context
            .gradientButton(
              text: 'SAVE',
              onPressed: () => onProfileEditSubmitted?.call(editProfileModel),
            )
            .paddingOnly(
              left: EdgeInsetsFoundation.horizontal16,
              right: EdgeInsetsFoundation.horizontal16,
              bottom: EdgeInsetsFoundation.vertical24,
            ),
      ),
    );
  }
}
