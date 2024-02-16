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
  final tabs = [
    UiKitCustomTab(title: S.current.Leisure, customValue: 'leisure'),
    UiKitCustomTab(title: S.current.Business, customValue: 'business'),
  ];

  AboutUserComponent({
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

              return [
                if (contentTypeList.first == ContentItemType.text)
                  Text(
                    S.of(context).NowLetsGetToKnowEachOther,
                    style: theme?.boldTextTheme.title1,
                  ),
                SpacingFoundation.verticalSpace16,
                Stack(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${S.of(context).TheMoreInfoWeGetTheBetter} ',
                            style: subHeadline,
                          ),
                          TextSpan(
                            text: S.of(context).YourLeisureSelection,
                            style: subHeadline?.copyWith(color: Colors.transparent),
                          ),
                          if (Localizations.localeOf(context).languageCode != 'ru')
                            TextSpan(
                              text: ' ${S.of(context).WillBe}',
                              style: subHeadline,
                            ),
                        ],
                      ),
                    ),
                    GradientableWidget(
                      gradient: GradientFoundation.attentionCard,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${S.of(context).TheMoreInfoWeGetTheBetter} ',
                              style: subHeadline?.copyWith(color: Colors.transparent),
                            ),
                            TextSpan(
                              text: S.of(context).YourLeisureSelection.toLowerCase(),
                              style: subHeadline?.copyWith(color: Colors.white),
                            ),
                            if (Localizations.localeOf(context).languageCode != 'ru')
                              TextSpan(
                                text: ' ${S.of(context).WillBe}',
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
            title: S.current.TypeOfContent,
            infoText: S.of(context).SwitchAnyTime,
            child: UiKitCustomTabBar(
              tabs: tabs,
              onTappedTab: (index) {
                final value = tabs.elementAt(index).customValue;
                if (value != null) onTypeOfContentChanged?.call(value);
              },
            ),
          ),
        ],
        //Religions selection section
        if (model.content.body?[ContentItemType.multiSelect] != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitTitledSection(
            title: S.of(context).SelectYourReligions,
            hasError: aboutUserModel.errorReligionMessage != null,
            errorText: aboutUserModel.errorReligionMessage,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  UiKitBorderedChipWithIcon(
                    icon: ImageWidget(link: GraphicsFoundation.instance.png.hindu.path),
                    title: S.current.Hindu,
                    isSelected: aboutUserModel.selectedReligions?.contains('hindu') ?? false,
                    onPressed: () => onReligionSelected?.call('hindu'),
                  ).paddingOnly(right: EdgeInsetsFoundation.horizontal8),
                  UiKitBorderedChipWithIcon(
                    icon: ImageWidget(link: GraphicsFoundation.instance.png.muslimFlag.path),
                    title: S.current.Islam,
                    isSelected: aboutUserModel.selectedReligions?.contains('islam') ?? false,
                    onPressed: () => onReligionSelected?.call('islam'),
                  ).paddingOnly(right: EdgeInsetsFoundation.horizontal8),
                  UiKitBorderedChipWithIcon(
                    icon: ImageWidget(link: GraphicsFoundation.instance.png.atheist.path),
                    title: S.current.Atheism,
                    isSelected: aboutUserModel.selectedReligions?.contains('atheism') ?? false,
                    onPressed: () => onReligionSelected?.call('atheism'),
                  ).paddingOnly(right: EdgeInsetsFoundation.horizontal8),
                  UiKitBorderedChipWithIcon(
                    icon: ImageWidget(link: GraphicsFoundation.instance.png.buddismFlag.path),
                    title: S.current.Buddhism,
                    isSelected: aboutUserModel.selectedReligions?.contains('buddism') ?? false,
                    onPressed: () => onReligionSelected?.call('buddism'),
                  ).paddingOnly(right: EdgeInsetsFoundation.horizontal8),
                  UiKitBorderedChipWithIcon(
                    icon: ImageWidget(link: GraphicsFoundation.instance.png.judaism.path),
                    title: S.current.Judaism,
                    isSelected: aboutUserModel.selectedReligions?.contains('judaism') ?? false,
                    onPressed: () => onReligionSelected?.call('judaism'),
                  ).paddingOnly(right: EdgeInsetsFoundation.horizontal8),
                  UiKitBorderedChipWithIcon(
                    icon: ImageWidget(link: GraphicsFoundation.instance.png.christianity.path),
                    title: S.current.Christianity,
                    isSelected: aboutUserModel.selectedReligions?.contains('christianity') ?? false,
                    onPressed: () => onReligionSelected?.call('christianity'),
                  ).paddingOnly(right: EdgeInsetsFoundation.horizontal8),
                ],
              ).paddingOnly(
                left: EdgeInsetsFoundation.horizontal4,
                bottom: EdgeInsetsFoundation.vertical4,
              ),
            ),
          ),
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
            title: S.of(context).Gender,
            hasError: aboutUserModel.errorGenderMessage != null,
            errorText: aboutUserModel.errorGenderMessage,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SpacingFoundation.horizontalSpace16,
                Expanded(
                  child: UiKitVerticalChip(
                    selected: aboutUserModel.selectedGender == 'male',
                    caption: S.current.Male,
                    sign: ImageWidget(link: GraphicsFoundation.instance.png.male.path),
                    autoSizeGroup: genderGroup,
                    onTap: () => onGenderChanged?.call('male'),
                  ).paddingOnly(right: EdgeInsetsFoundation.horizontal4),
                ),
                Expanded(
                  child: UiKitVerticalChip(
                    selected: aboutUserModel.selectedGender == 'female',
                    caption: S.current.Female,
                    sign: ImageWidget(link: GraphicsFoundation.instance.png.male.path),
                    autoSizeGroup: genderGroup,
                    onTap: () => onGenderChanged?.call('female'),
                  ).paddingOnly(right: EdgeInsetsFoundation.horizontal4),
                ),
                Expanded(
                  child: UiKitVerticalChip(
                    selected: aboutUserModel.selectedGender == 'other',
                    caption: S.current.Other,
                    sign: ImageWidget(link: GraphicsFoundation.instance.png.male.path),
                    autoSizeGroup: genderGroup,
                    onTap: () => onGenderChanged?.call('other'),
                  ).paddingOnly(right: EdgeInsetsFoundation.horizontal4),
                ),
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
          ),
        ),
        SpacingFoundation.verticalSpace24,
      ],
    ).paddingSymmetric(
      vertical: verticalMargin,
      horizontal: horizontalMargin,
    );
  }
}
