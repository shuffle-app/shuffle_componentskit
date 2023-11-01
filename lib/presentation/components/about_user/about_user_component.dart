import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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

  final GlobalKey? formKey;

  const AboutUserComponent({
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
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => onAgeChanged?.call(24));
    }
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['about_user']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final theme = context.uiKitTheme;
    final subHeadline = theme?.boldTextTheme.subHeadline;
    final titleAlignment = model.positionModel?.titleAlignment;

    final AutoSizeGroup genderGroup = AutoSizeGroup();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (model.content.title != null)
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: titleAlignment.crossAxisAlignment,
              mainAxisAlignment: titleAlignment.mainAxisAlignment,
              children: () {
                final List<ContentItemType> contentTypeList = model.content.title!.keys.toList();
                final List<ContentBaseModel> contents = model.content.title!.values.toList();

                return [
                  if (contentTypeList.first == ContentItemType.text)
                    Text(
                      contents.first.properties?.keys.first ?? 'Now let\'s get to know each other',
                      style: theme?.boldTextTheme.title1,
                    ),
                  SpacingFoundation.verticalSpace16,
                  Stack(children: [
                    RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'The more info we get about you, the better ',
                          style: subHeadline?.copyWith(color: Colors.white.withOpacity(1)),
                        ),
                        TextSpan(
                            text: 'your leisure selection',
                            style: subHeadline?.copyWith(color: Colors.white.withOpacity(0))),
                        TextSpan(
                          text: ' will be.',
                          style: subHeadline?.copyWith(color: Colors.white.withOpacity(1)),
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
                            style: subHeadline?.copyWith(color: Colors.white.withOpacity(0)),
                          ),
                          TextSpan(text: 'your leisure selection', style: subHeadline),
                          TextSpan(
                            text: ' will be.',
                            style: subHeadline?.copyWith(color: Colors.white.withOpacity(0)),
                          )
                        ],
                      )),
                    )
                  ]),
                  SpacingFoundation.verticalSpace16,
                ];
              }()),
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
        if (model.content.body?[ContentItemType.singleDropdown] != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
              color: Colors.black,
              title: model.content.body?[ContentItemType.singleDropdown]?.title?.entries.first.value.properties?.keys
                      .first ??
                  'Describe yourself',
              hasError: aboutUserModel.errorPersonTypeMessage != null,
              errorText: aboutUserModel.errorPersonTypeMessage,
              child: UiKitMenu<String>(
                title: model.content.body?[ContentItemType.singleDropdown]?.title?.entries.first.value.properties?.keys
                        .first ??
                    'Describe yourself',
                selectedItem: aboutUserModel.selectedPersonType,
                items: () {
                  final rawItems = model
                      .content.body?[ContentItemType.singleDropdown]?.body?[ContentItemType.singleDropdown]?.properties;

                  return (rawItems?.entries
                          .map<UiKitMenuItem<String>>(
                            (e) => UiKitMenuItem<String>(
                              title: e.key,
                              value: e.value.value,
                              iconPath: e.value.imageLink,
                            ),
                          )
                          .toList() ??
                      [])
                    ..sort((a, b) =>
                        (rawItems?[a.title]?.sortNumber ?? 0).compareTo((rawItems?[b.title]?.sortNumber ?? 0)));
                }(),
                onSelected: (personType) => onPersonTypeChanged?.call(personType),
              )),
        ],
        if (model.content.body?[ContentItemType.multiSelect] != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
              title:
                  model.content.body?[ContentItemType.multiSelect]?.title?.entries.first.value.properties?.keys.first ??
                      'Select your religions',
              hasError: aboutUserModel.errorReligionMessage != null,
              errorText: aboutUserModel.errorReligionMessage,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: SpacingFoundation.horizontalSpacing8,
                  children: () {
                    final rawItems = model
                        .content.body?[ContentItemType.multiSelect]?.body?[ContentItemType.multiSelect]?.properties;

                    final items = (rawItems?.entries.map((e) {
                          return UiKitBorderedChipWithIcon(
                            icon: ImageWidget(
                              link: e.value.imageLink,
                            ),
                            title: e.key,
                            isSelected: aboutUserModel.selectedReligions?.contains(e.value.value) ?? false,
                            onPressed: () => onReligionSelected?.call(e.value.value ?? ''),
                          );
                        }).toList() ??
                        [])
                      ..sort((a, b) =>
                          (rawItems?[a.title]?.sortNumber ?? 0).compareTo((rawItems?[b.title]?.sortNumber ?? 0)));

                    return items.map((e) => e).toList();
                  }(),
                ).paddingOnly(
                  left: EdgeInsetsFoundation.horizontal4,
                  bottom: EdgeInsetsFoundation.vertical4,
                ),
              )),
        ],
        SpacingFoundation.verticalSpace16,
        UiKitHorizontalWheelNumberSelector(
          values: List<int>.generate(70, (index) => index + 16),
          title: 'Your age',
          initialValue: aboutUserModel.selectedAge == null ? null : aboutUserModel.selectedAge! - 16,
          onValueChanged: (age) => onAgeChanged?.call(age),
        ),
        if (model.content.body?[ContentItemType.singleSelect] != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
            title:
                model.content.body?[ContentItemType.singleSelect]?.title?.entries.first.value.properties?.keys.first ??
                    'Gender',
            hasError: aboutUserModel.errorGenderMessage != null,
            errorText: aboutUserModel.errorGenderMessage,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SpacingFoundation.horizontalSpace16,
                ...() {
                  final rawItems = model
                      .content.body?[ContentItemType.singleSelect]?.body?[ContentItemType.singleSelect]?.properties;

                  final items = (rawItems?.entries
                          .map((e) => UiKitVerticalChip(
                                selected: aboutUserModel.selectedGender == e.key,
                                caption: e.key,
                                sign: ImageWidget(link: e.value.imageLink),
                                autoSizeGroup: genderGroup,
                                onTap: () => onGenderChanged?.call(e.key),
                              ))
                          .toList() ??
                      [])
                    ..sort((a, b) =>
                        (rawItems?[a.caption]?.sortNumber ?? 0).compareTo((rawItems?[b.caption]?.sortNumber ?? 0)));

                  return items
                      .map((e) => Expanded(
                            child: e.paddingOnly(right: EdgeInsetsFoundation.horizontal4),
                          ))
                      .toList();
                }(),
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
