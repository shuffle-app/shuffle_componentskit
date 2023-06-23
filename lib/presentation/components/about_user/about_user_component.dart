import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AboutUserComponent extends StatelessWidget {
  final UiAboutUserModel aboutUserModel;
  final VoidCallback? onSubmitUserData;
  final ValueChanged<String>? onReligionSelected;
  final ValueChanged<UiKitMenuItem<String>?>? onPersonTypeChanged;
  final ValueChanged<int?>? onAgeChanged;
  final String? Function(String?)? inputFieldValidator;
  final ValueChanged<String>? onGenderChanged;

  final TextEditingController nameController;
  final TextEditingController nickNameController;
  final GlobalKey _richTextKey = GlobalKey();

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
    if (aboutUserModel.selectedAge == null) {
      onAgeChanged?.call(24);
    }
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentAboutUserModel model =
        ComponentAboutUserModel.fromJson(config['about_user']);
    final horizontalMargin =
        (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin =
        (model.positionModel?.verticalMargin ?? 0).toDouble();
    final subHeadline = context.uiKitTheme?.boldTextTheme.subHeadline;

    final AutoSizeGroup genderGroup = AutoSizeGroup();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Now let\'s get to know each other',
          style: context.uiKitTheme?.boldTextTheme.title1,
        ),
        SpacingFoundation.verticalSpace16,
        Stack(children: [
          RichText(
              text: TextSpan(
            children: [
              TextSpan(
                text: 'The more info we get about you, the better ',
                style:
                    subHeadline?.copyWith(color: Colors.white.withOpacity(1)),
              ),
              TextSpan(
                  text: 'your leisure selection',
                  style: subHeadline?.copyWith(
                      color: Colors.white.withOpacity(0))),
              TextSpan(
                text: ' will be.',
                style:
                    subHeadline?.copyWith(color: Colors.white.withOpacity(1)),
              )
            ],
          )),
          GradientableWidget(
            gradient: GradientFoundation.attentionCard,
            child: RichText(
                // key: _richTextKey,
                text: TextSpan(
              children: [
                TextSpan(
                  text: 'The more info we get about you, the better ',
                  style:
                      subHeadline?.copyWith(color: Colors.white.withOpacity(0)),
                ),
                TextSpan(text: 'your leisure selection', style: subHeadline),
                TextSpan(
                  text: ' will be.',
                  style:
                      subHeadline?.copyWith(color: Colors.white.withOpacity(0)),
                )
              ],
            )),
          )
        ]),
        SpacingFoundation.verticalSpace16,
        UiKitCardWrapper(
          color: ColorsFoundation.surface1,
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment:
                    (model.positionModel?.titleAlignment).mainAxisAlignment,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    (model.positionModel?.titleAlignment).crossAxisAlignment,
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
          UiKitTitledSection(
              color: Colors.black,
              title: 'Describe yourself',
              hasError: aboutUserModel.errorPersonTypeMessage != null,
              errorText: aboutUserModel.errorPersonTypeMessage,
              child: UiKitMenu<String>(
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
                onSelected: (personType) =>
                    onPersonTypeChanged?.call(personType),
              )),
        ],
        if (aboutUserModel.religions != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
            title: 'Select your religions',
            hasError: aboutUserModel.errorReligionMessage != null,
            errorText: aboutUserModel.errorReligionMessage,
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
                      isSelected: aboutUserModel.selectedReligions
                              ?.contains(data.title) ??
                          false,
                      onPressed: () => onReligionSelected?.call(data.title),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      SpacingFoundation.horizontalSpace8,
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
            hasError: aboutUserModel.errorGenderMessage != null,
            errorText: aboutUserModel.errorGenderMessage,
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
                          autoSizeGroup: genderGroup,
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
            data: BaseUiKitButtonData(
          text: 'CONFIRM',
          onPressed: onSubmitUserData,
        )),
        SpacingFoundation.verticalSpace24,
      ],
    ).paddingSymmetric(
      vertical: verticalMargin,
      horizontal: horizontalMargin,
    );
  }
}
