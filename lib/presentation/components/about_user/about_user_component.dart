import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/config_models/about_user/component_about_user_model.dart';
import 'package:shuffle_components_kit/presentation/components/about_user/ui_about_user_model.dart';
import 'package:shuffle_components_kit/presentation/widgets/global_component.dart';
import 'package:shuffle_components_kit/services/configuration/global_configuration.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AboutUserComponent extends StatelessWidget {
  final UiAboutUserModel aboutUserModel;
  final ValueChanged<UiAboutUserModel>? onSubmitUserData;
  final ValueChanged<String>? onReligionSelected;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<String>? onNickNameChanged;
  final ValueChanged<String?>? onPersonTypeChanged;
  final ValueChanged<int?>? onAgeChanged;
  final String? Function(String?)? inputFieldValidator;
  final ValueChanged<String>? onGenderChanged;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();

  AboutUserComponent({
    Key? key,
    required this.aboutUserModel,
    this.onReligionSelected,
    this.inputFieldValidator,
    this.onNameChanged,
    this.onNickNameChanged,
    this.onPersonTypeChanged,
    this.onAgeChanged,
    this.onGenderChanged,
    this.onSubmitUserData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentAboutUserModel model = ComponentAboutUserModel.fromJson(config['about_user']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UiKitCardWrapper(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UiKitInputFieldNoIcon(
                controller: nameController,
                hintText: 'NAME',
                validator: inputFieldValidator,
                onChanged: (value) => onNameChanged?.call(value),
              ),
              SpacingFoundation.verticalSpace16,
              UiKitInputFieldNoIcon(
                controller: nickNameController,
                hintText: 'NICKNAME',
                validator: inputFieldValidator,
                onChanged: (value) => onNickNameChanged?.call(value),
              ),
            ],
          ).paddingAll(EdgeInsetsFoundation.all4),
        ),
        if (aboutUserModel.personTypes != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitMenu<String>(
            title: 'Describe yourself',
            selectedItem: aboutUserModel.selectedPersonType,
            items: aboutUserModel.personTypes!
                .map<UiKitMenuItem<String>>(
                  (e) => UiKitMenuItem<String>(
                    title: e.title,
                    value: e.value,
                    icon: e.icon,
                  ),
                )
                .toList(),
            onSelected: (personType) => onPersonTypeChanged?.call(personType.value),
          ),
        ],
        if (aboutUserModel.religions != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
            title: 'Select your religions',
            child: ListView.separated(
              itemBuilder: (context, index) {
                final data = aboutUserModel.religions![index];

                return UiKitBorderedChipWithIcon(
                  icon: data.icon,
                  title: data.title,
                  isSelected: data.isSelected,
                  onPressed: () => onReligionSelected?.call(data.title),
                );
              },
              separatorBuilder: (context, index) => SpacingFoundation.horizontalSpace8,
              itemCount: aboutUserModel.religions!.length,
            ),
          ),
        ],
        SpacingFoundation.verticalSpace16,
        UiKitHorizontalWheelNumberSelector(
          values: List<int>.generate(70, (index) => index + 10),
          title: 'Your age',
          onValueChanged: (age) => onAgeChanged?.call(age),
        ),
        if (aboutUserModel.genders != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
            title: 'Gender',
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: aboutUserModel.genders!
                  .map(
                    (e) => UiKitVerticalChip(
                      selected: aboutUserModel.selectedGender == e.caption,
                      caption: e.caption,
                      sign: e.sign,
                      onTap: () => onGenderChanged?.call(e.caption),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
        SpacingFoundation.verticalSpace16,
        context.button(
          text: 'CONFIRM',
          onPressed: () => onSubmitUserData?.call(aboutUserModel),
        ),
      ],
    ).paddingSymmetric(
      vertical: verticalMargin,
      horizontal: horizontalMargin,
    );
  }
}
