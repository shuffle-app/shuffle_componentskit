import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AboutUserComponent extends StatelessWidget {
  final UiAboutUserModel aboutUserModel;
  final ValueChanged<UiAboutUserModel>? onSubmitUserData;
  final ValueChanged<String>? onReligionSelected;
  // final ValueChanged<String>? onNameChanged;
  // final ValueChanged<String>? onNickNameChanged;
  final ValueChanged<UiKitMenuItem<String>?>? onPersonTypeChanged;
  final ValueChanged<int?>? onAgeChanged;
  final String? Function(String?)? inputFieldValidator;
  final ValueChanged<String>? onGenderChanged;

  final TextEditingController nameController;
  final TextEditingController nickNameController;
  final GlobalKey _myKey = GlobalKey();
  final GlobalKey? formKey;

  AboutUserComponent({
    Key? key,
    required this.aboutUserModel,
    this.onReligionSelected,
    this.inputFieldValidator,
    required this.nameController,
    required this.nickNameController,
    this.onPersonTypeChanged,
    this.onAgeChanged,
    this.formKey,
    this.onGenderChanged,
    this.onSubmitUserData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentAboutUserModel model = ComponentAboutUserModel.fromJson(config['about_user']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final subHeadline = context.uiKitTheme?.boldTextTheme.subHeadline;

    return KeyboardDismisser(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Now let\'s get to know each other',
            style: context.uiKitTheme?.boldTextTheme.title1,
          ),
          SpacingFoundation.verticalSpace16,
          RichText(
            key: _myKey,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'The more info we get about you, the better ',
                  style: subHeadline,
                ),
                TextSpan(
                  text: 'your leisure selection',
                  style: subHeadline?.copyWith(
                      foreground: Paint()
                        ..shader = GradientFoundation.buttonGradient
                            .createShader(_myKey.currentContext?.findRenderObject()?.paintBounds ?? Rect.zero)),
                ),
                TextSpan(
                  text: ' will be.',
                  style: subHeadline,
                )
              ],
            ),
          ),
          SpacingFoundation.verticalSpace16,
          UiKitCardWrapper(
            color: ColorsFoundation.surface1,
            child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: (model.positionModel?.titleAlignment).mainAxisAlignment,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: (model.positionModel?.titleAlignment).crossAxisAlignment,
                  children: [
                    UiKitInputFieldNoIcon(
                      controller: nameController,
                      hintText: 'NAME',
                      validator: inputFieldValidator,
                      fillColor: ColorsFoundation.surface3,
                      // onChanged: (value) => onNameChanged?.call(value),
                    ),
                    SpacingFoundation.verticalSpace16,
                    UiKitInputFieldNoIcon(
                      controller: nickNameController,
                      hintText: 'NICKNAME',
                      validator: inputFieldValidator,
                      fillColor: ColorsFoundation.surface3,
                      // onChanged: (value) => onNickNameChanged?.call(value),
                    ),
                  ],
                )).paddingAll(EdgeInsetsFoundation.all4),
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
              onSelected: (personType) => onPersonTypeChanged?.call(personType),
            ),
          ],
          if (aboutUserModel.religions != null) ...[
            SpacingFoundation.verticalSpace16,
            UiKitTitledSection(
              title: 'Select your religions',
              child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final data = aboutUserModel.religions![index];

                      return UiKitBorderedChipWithIcon(
                        icon: data.icon,
                        title: data.title,
                        isSelected: aboutUserModel.selectedReligions?.contains(data.title) ?? false,
                        onPressed: () => onReligionSelected?.call(data.title),
                      );
                    },
                    separatorBuilder: (context, index) => SpacingFoundation.horizontalSpace8,
                    itemCount: aboutUserModel.religions!.length,
                  )).paddingOnly(
                left: EdgeInsetsFoundation.horizontal4,
                bottom: EdgeInsetsFoundation.vertical4,
              ),
            ),
          ],
          SpacingFoundation.verticalSpace16,
          UiKitHorizontalWheelNumberSelector(
            values: List<int>.generate(70, (index) => index + 16),
            title: 'Your age',
            onValueChanged: (age) => onAgeChanged?.call(age),
          ),
          if (aboutUserModel.genders != null) ...[
            SpacingFoundation.verticalSpace16,
            UiKitTitledSection(
              title: 'Gender',
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SpacingFoundation.horizontalSpace16,
                  ...aboutUserModel.genders!
                      .map(
                        (e) => Expanded(
                          child: UiKitVerticalChip(
                            selected: aboutUserModel.selectedGender == e.caption,
                            caption: e.caption,
                            sign: e.sign,
                            onTap: () => onGenderChanged?.call(e.caption),
                          ).paddingOnly(right: EdgeInsetsFoundation.horizontal4),
                        ),
                      )
                      .toList(),
                  SpacingFoundation.horizontalSpace16,
                ],
              ).paddingOnly(bottom: SpacingFoundation.horizontalSpacing8),
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
      ),
    );
  }
}
