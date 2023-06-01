import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/config_models/profile/component_edit_profile_model.dart';
import 'package:shuffle_components_kit/presentation/components/profile/edit_profile_component/ui_edit_profile_model.dart';
import 'package:shuffle_components_kit/presentation/utils/input_formatters.dart';
import 'package:shuffle_components_kit/presentation/widgets/global_component.dart';
import 'package:shuffle_components_kit/services/configuration/global_configuration.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class EditProfileComponent extends StatelessWidget {
  final UiEditProfileModel editProfileModel;
  final ValueChanged<UiEditProfileModel>? onProfileEditSubmitted;
  final ValueChanged<String>? onPhotoChanged;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onNickNameChanged;
  final ValueChanged<String>? onPhoneChanged;
  final ValueChanged<String>? onDateOfBirthChanged;
  final ValueChanged<List<String>>? onPreferencesChanged;
  final String? Function(String?)? textValidator;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? phoneValidator;
  final String? Function(String?)? dateOfBirthValidator;

  late final TextEditingController _nameController = TextEditingController(text: editProfileModel.name);
  late final TextEditingController _nickNameController = TextEditingController(text: editProfileModel.nickName);
  late final TextEditingController _emailController = TextEditingController(text: editProfileModel.email);
  late final TextEditingController _dateOfBirthController = TextEditingController(text: editProfileModel.dateOfBirth);
  late final TextEditingController _phoneController = TextEditingController(text: editProfileModel.phone);

  EditProfileComponent({
    Key? key,
    required this.editProfileModel,
    this.onProfileEditSubmitted,
    this.onPhotoChanged,
    this.onNameChanged,
    this.onEmailChanged,
    this.onNickNameChanged,
    this.onPhoneChanged,
    this.onDateOfBirthChanged,
    this.onPreferencesChanged,
    this.textValidator,
    this.emailValidator,
    this.phoneValidator,
    this.dateOfBirthValidator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentEditProfileModel model = ComponentEditProfileModel.fromJson(config['edit_profile']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final textTheme = context.uiKitTheme?.boldTextTheme;

    return BlurredAppBarPage(
      title: 'Edit Profile',
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
            controller: _nameController,
            label: 'Name',
            validator: textValidator,
            onChanged: (value) => onNameChanged?.call(value),
          ),
          SpacingFoundation.verticalSpace16,
          UiKitInputFieldNoFill(
            controller: _nickNameController,
            label: 'Nickname',
            validator: textValidator,
            onChanged: (value) => onNickNameChanged?.call(value),
          ),
          SpacingFoundation.verticalSpace16,
          UiKitInputFieldNoFill(
            controller: _dateOfBirthController,
            label: 'Date of birth',
            validator: dateOfBirthValidator,
            onChanged: (value) => onDateOfBirthChanged?.call(value),
            inputFormatters: [dateInputFormatter],
          ),
          SpacingFoundation.verticalSpace16,
          UiKitInputFieldNoFill(
            prefixText: '+',
            controller: _phoneController,
            label: 'Phone',
            validator: phoneValidator,
            inputFormatters: [americanInputFormatter],
            onChanged: (value) => onPhoneChanged?.call(value),
          ),
          SpacingFoundation.verticalSpace16,
          UiKitInputFieldNoFill(
            controller: _emailController,
            label: 'Email',
            validator: emailValidator,
            onChanged: (value) => onEmailChanged?.call(value),
          ),
          SpacingFoundation.verticalSpace16,
        ],
      ).paddingSymmetric(
        horizontal: horizontalMargin,
        vertical: verticalMargin,
      ),
    );
  }
}
