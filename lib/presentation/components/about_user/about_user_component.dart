import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AboutUserComponent extends StatelessWidget {
  final UiAboutUserModel aboutUserModel;
  final VoidCallback? onSubmitUserData;
  final ValueChanged<String>? onReligionSelected;
  final ValueChanged<UiKitMenuItem<String>?>? onPersonTypeChanged;
  final List<UiKitMenuItem<String>> mindsets;
  final ValueChanged<int?>? onAgeChanged;
  final String? Function(String?)? inputFieldValidator;
  final ValueChanged<String>? onGenderChanged;
  final ValueChanged<String>? onTypeOfContentChanged;

  final TextEditingController nameController;
  final TextEditingController nickNameController;

  final GlobalKey? formKey;

  const AboutUserComponent({
    Key? key,
    required this.aboutUserModel,
    required this.mindsets,
    this.onReligionSelected,
    this.inputFieldValidator,
    required this.nameController,
    required this.nickNameController,
    this.onPersonTypeChanged,
    this.onAgeChanged,
    this.formKey,
    this.onGenderChanged,
    this.onSubmitUserData,
    this.onTypeOfContentChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (aboutUserModel.selectedAge == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => onAgeChanged?.call(24));
    }
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['about_user']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final theme = context.uiKitTheme;
    final colorScheme = theme?.colorScheme;
    final subHeadline = theme?.boldTextTheme.subHeadline;
    final titleAlignment = model.positionModel?.titleAlignment;
    final configSubtitle = model.content.subtitle?[ContentItemType.singleSelect];
    final contentTitle = configSubtitle?.title?[ContentItemType.text]?.properties?.keys.first;
    configSubtitle?.body?[ContentItemType.singleSelect]?.properties?.entries.toList().sort(
          (a, b) => a.value.sortNumber?.compareTo(b.value.sortNumber ?? 0) ?? 0,
        );

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
                    contents.first.properties?.keys.first ?? S.of(context).NowLetsGetToKnowEachOther,
                    style: theme?.boldTextTheme.title1,
                  ),
                SpacingFoundation.verticalSpace16,
                Stack(
                  children: [
                    RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                          text: S.of(context).TheMoreInfoWeGetTheBetter,
                          style: subHeadline,
                        ),
                        TextSpan(
                            text: S.of(context).YourLeisureSelection.toLowerCase(),
                            style: subHeadline?.copyWith(color: Colors.transparent)),
                        TextSpan(
                          text: S.of(context).WillBe,
                          style: subHeadline,
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
                              text: S.of(context).TheMoreInfoWeGetTheBetter,
                              style: subHeadline?.copyWith(color: Colors.transparent),
                            ),
                            TextSpan(
                              text: S.of(context).YourLeisureSelection.toLowerCase(),
                              style: subHeadline?.copyWith(color: Colors.white),
                            ),
                            TextSpan(
                              text: S.of(context).WillBe,
                              style: subHeadline?.copyWith(color: Colors.transparent),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SpacingFoundation.verticalSpace16,
              ];
            }(),
          ),
        UiKitCardWrapper(
          borderRadius: BorderRadiusFoundation.all24r,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: (model.positionModel?.titleAlignment).mainAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: (model.positionModel?.titleAlignment).crossAxisAlignment,
              children: [
                UiKitInputFieldNoIcon(
                  controller: nameController,
                  hintText: S.of(context).Name.toUpperCase(),
                  validator: inputFieldValidator,
                  fillColor: colorScheme?.surface3,
                  // onChanged: (value) => onNameChanged?.call(value),
                ),
                SpacingFoundation.verticalSpace16,
                UiKitInputFieldNoIcon(
                  controller: nickNameController,
                  hintText: S.of(context).Nickname.toUpperCase(),
                  validator: inputFieldValidator,
                  fillColor: colorScheme?.surface3,
                  // onChanged: (value) => onNickNameChanged?.call(value),
                ),
              ],
            ),
          ).paddingAll(EdgeInsetsFoundation.all4),
        ),
        if (model.content.body?[ContentItemType.singleDropdown] != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
              color: colorScheme?.surface,
              title:
              // title: model.content.body?[ContentItemType.singleDropdown]?.title?.entries.first.value.properties?.keys.first ??
                  S.of(context).DescribeYourself,
              hasError: aboutUserModel.errorPersonTypeMessage != null,
              errorText: aboutUserModel.errorPersonTypeMessage,
              child: UiKitMenu<String>(
                tilesColor: Colors.transparent,
                useCustomTiles: false,
                title:
                // title: model.content.body?[ContentItemType.singleDropdown]?.title?.entries.first.value.properties?.keys.first ??
                    S.of(context).DescribeYourself,
                selectedItem: aboutUserModel.selectedPersonType,
                items: mindsets,
                onSelected: (personType) => onPersonTypeChanged?.call(personType),
              )),
        ],
        //Type of content selection section
        if (model.content.subtitle?[ContentItemType.singleSelect] != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
            title: contentTitle!,
            infoText: S.of(context).SwitchAnyTime,
            child: UiKitCustomTabBar(
              tabs: configSubtitle!.body![ContentItemType.singleSelect]!.properties!.entries
                  .map((property) => UiKitCustomTab(title: property.key))
                  .toList(),
              onTappedTab: (index) {
                onTypeOfContentChanged?.call(
                  configSubtitle.body![ContentItemType.singleSelect]!.properties!.entries
                      .firstWhere((element) => element.value.sortNumber == index + 1)
                      .key
                      .toLowerCase(),
                );
              },
            ),
          ),
        ],
        //Religions selection section
        if (model.content.body?[ContentItemType.multiSelect] != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
              title: model.content.body?[ContentItemType.multiSelect]?.title?.entries.first.value.properties?.keys.first ??
                  S.of(context).SelectYourReligions,
              hasError: aboutUserModel.errorReligionMessage != null,
              errorText: aboutUserModel.errorReligionMessage,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: SpacingFoundation.horizontalSpacing8,
                  children: () {
                    final rawItems =
                        model.content.body?[ContentItemType.multiSelect]?.body?[ContentItemType.multiSelect]?.properties;

                    final items = (rawItems?.entries.map(
                          (e) {
                            return UiKitBorderedChipWithIcon(
                              icon: ImageWidget(
                                link: e.value.imageLink,
                              ),
                              title: e.key,
                              isSelected: aboutUserModel.selectedReligions?.contains(e.key.toLowerCase()) ?? false,
                              onPressed: () => onReligionSelected?.call(e.value.value ?? ''),
                            );
                          },
                        ).toList() ??
                        [])
                      ..sort((a, b) => (rawItems?[a.title]?.sortNumber ?? 0).compareTo((rawItems?[b.title]?.sortNumber ?? 0)));

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
          values: List<int>.generate(70, (index) => index + 13),
          title: S.of(context).YourAge,
          initialValue: aboutUserModel.selectedAge == null ? 11 : aboutUserModel.selectedAge! - 13,
          onValueChanged: (age) => onAgeChanged?.call(age),
        ),
        if (model.content.body?[ContentItemType.singleSelect] != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
            title: model.content.body?[ContentItemType.singleSelect]?.title?.entries.first.value.properties?.keys.first ??
                S.of(context).Gender,
            hasError: aboutUserModel.errorGenderMessage != null,
            errorText: aboutUserModel.errorGenderMessage,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SpacingFoundation.horizontalSpace16,
                ...() {
                  final rawItems =
                      model.content.body?[ContentItemType.singleSelect]?.body?[ContentItemType.singleSelect]?.properties;

                  final items = (rawItems?.entries
                          .map((e) => UiKitVerticalChip(
                                selected: aboutUserModel.selectedGender == e.value.value,
                                caption: e.key,
                                sign: ImageWidget(link: e.value.imageLink),
                                autoSizeGroup: genderGroup,
                                onTap: () => onGenderChanged?.call(e.value.value ?? ''),
                              ))
                          .toList() ??
                      [])
                    ..sort((a, b) => (rawItems?[a.caption]?.sortNumber ?? 0).compareTo((rawItems?[b.caption]?.sortNumber ?? 0)));

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
          text: S.of(context).Confirm.toUpperCase(),
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
