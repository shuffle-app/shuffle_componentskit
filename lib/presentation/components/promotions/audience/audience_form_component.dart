import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/promotions/audience/audience_ui_model.dart';
import 'package:shuffle_components_kit/services/navigation_service/navigation_key.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../common/select_one_type_with_bottom.dart';
import '../../../common/tags_selection_component.dart';

class AudienceFormComponent extends StatefulWidget {
  final List<AudienceUiModel>? preSavedAudience;
  final ValueChanged<AudienceUiModel>? onSaveTemplate;
  final ValueChanged<AudienceUiModel>? onAudienceDrafted;

  final List<UiKitTag> allGenders;
  final List<UiKitTag> allCategories;
  final List<UiKitTag> allMindsets;
  final List<String> allDevices;

  final List<LocaleModel> allLanguages;
  final List<String> allBirthdayTypes;
  final getPrefsForMindsetList;

  const AudienceFormComponent(
      {super.key,
      this.preSavedAudience,
      this.getPrefsForMindsetList,
      this.onSaveTemplate,
      this.onAudienceDrafted,
      this.allGenders = const [],
      this.allCategories = const [],
      this.allMindsets = const [],
      this.allDevices = const [],
      this.allLanguages = const [],
      this.allBirthdayTypes = const []});

  @override
  State<AudienceFormComponent> createState() => _AudienceFormComponentState();
}

class _AudienceFormComponentState extends State<AudienceFormComponent> {
  final autoSizeGroup = AutoSizeGroup();
  AudienceUiModel? selectedAudience;
  bool wasSelectedTemplate = false;

  // List<UiKitTag> selectedGenders = [];
  int? selectedGenderId;
  List<UiKitTag> selectedCategories = [];
  List<UiKitTag> selectedMindsets = [];
  List<String> selectedDevices = [];
  List<UiKitTag> selectedPrefs = [];
  List<LocaleModel> selectedLanguages = [];
  List<String> selectedBirthdays = [];
  late final List<String> savedAudience;

  // final TextEditingController _languageController = TextEditingController();

  int? selectedAgeFrom;
  int? selectedAgeTo;

  @override
  void initState() {
    FocusManager.instance.addListener(_sendDraftUpdatedAudience);
    savedAudience =
        List.of(widget.preSavedAudience?.map((e) => e.title).nonNulls.where((e) => e.isNotEmpty).toList() ?? []);
    super.initState();
  }

  onSelectSavedAudience(AudienceUiModel audience) {
    selectedAudience = audience;
    // selectedGenders = audience.genders ?? [];
    selectedGenderId = audience.gender;
    selectedCategories = audience.selectedCategories ?? [];
    selectedMindsets = audience.selectedMindsets ?? [];
    selectedDevices = audience.devices ?? [];
    selectedPrefs = audience.selectedPrefs ?? [];
    selectedLanguages = audience.languages ?? [];
    selectedAgeFrom = audience.fromAge;
    selectedAgeTo = audience.toAge;
    selectedBirthdays = audience.birthdayOptions ?? [];
    setState(() {});
  }

  _sendDraftUpdatedAudience() {
    if (!mounted) return;
    if (widget.onAudienceDrafted != null) {
      widget.onAudienceDrafted!((selectedAudience ?? AudienceUiModel()).copyWith(
        // genders: selectedGenders,
        gender: selectedGenderId,
        selectedCategories: selectedCategories,
        selectedMindsets: selectedMindsets,
        devices: selectedDevices,
        selectedPrefs: selectedPrefs,
        languages: selectedLanguages,
        fromAge: selectedAgeFrom,
        toAge: selectedAgeTo,
        birthdayOptions: selectedBirthdays,
      ));
    }
  }

  bool get canSaveTemplate => selectedGenderId != null && selectedMindsets.isNotEmpty;

  @override
  void dispose() {
    FocusManager.instance.removeListener(_sendDraftUpdatedAudience);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final bodyBold = theme?.boldTextTheme.body;
    final titleStyle = theme?.boldTextTheme.title2;

    return BlurredAppBarPage(
      title: S.current.Audience,
      centerTitle: true,
      autoImplyLeading: true,
      childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.verticalSpacing16),
      children: [
        SpacingFoundation.verticalSpace16,
        if (savedAudience.isNotEmpty) ...[
          Text(
            S.current.CreateAudienceOrSelectOne,
            style: bodyBold,
          ),
          SpacingFoundation.verticalSpace16,
          SelectOneTypeWithBottom(
            items: savedAudience,
            selectedItem: selectedAudience?.title,
            onSelect: (title) {
              final audience = widget.preSavedAudience!.firstWhere((e) => e.title == title);
              onSelectSavedAudience(audience);

              navigatorKey.currentContext?.pop();
            },
          ),
          SpacingFoundation.verticalSpace24,
        ],
        Text(
          S.current.Gender,
          style: titleStyle,
        ),
        SpacingFoundation.verticalSpace16,
        Wrap(
          spacing: SpacingFoundation.verticalSpacing4,
          children: widget.allGenders
              .map((gender) => SizedBox(
                  width: 0.4.sw,
                  child: UiKitRadioTile(
                    title: gender.title,
                    autoSizeGroup: autoSizeGroup,
                    onTapped: () {
                      setState(() {
                        selectedGenderId = gender.id;
                      });
                    },
                    selected: selectedGenderId == gender.id,
                  )))
              .toList(),
        ),
        // Wrap(
        //   runSpacing: SpacingFoundation.verticalSpacing4,
        //   children: widget.allGenders
        //       .map((gender) => SizedBox(
        //           width: 0.4.sw,
        //           child: UiKitCheckboxFilterItem(
        //             item: TitledFilterItem(
        //                 mask: gender.title, value: gender.title, selected: selectedGenders.contains(gender.title)),
        //             onTap: (selected) {
        //               setState(() {
        //                 if (!selectedGenders.remove(gender)) {
        //                   selectedGenders.add(gender);
        //                 }
        //               });
        //             },
        //             isSelected: selectedGenders.contains(gender),
        //           )))
        //       .toList(),
        // ),
        SpacingFoundation.verticalSpace24,
        Text(
          S.current.Age,
          style: titleStyle,
        ),
        SpacingFoundation.verticalSpace16,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.current.From, style: bodyBold),
            UiKitDropDownList<int>(
              contentBorderRadius: BorderRadiusFoundation.all12,
              maxHeight: .4.sh,
              selectedItem: selectedAgeFrom,
              items: List.generate(60, (i) => i + 18)
                  .map((age) => DropdownMenuItem(value: age, child: Text('$age')))
                  .toList(),
              onChanged: (int? from) {
                setState(() {
                  selectedAgeFrom = from;
                  if (selectedAgeTo != null && selectedAgeTo! < (from ?? 18)) {
                    selectedAgeTo = null;
                  }
                });
              },
            ),
            Text(S.current.To.toLowerCase(), style: bodyBold),
            UiKitDropDownList<int>(
              contentBorderRadius: BorderRadiusFoundation.all12,
              maxHeight: .4.sh,
              selectedItem: selectedAgeTo,
              items: List.generate(60, (i) => i + (selectedAgeFrom ?? 18))
                  .map((age) => DropdownMenuItem(value: age, child: Text('$age')))
                  .toList(),
              onChanged: (int? to) {
                setState(() {
                  selectedAgeTo = to;
                });
              },
            )
          ],
        ),
        SpacingFoundation.verticalSpace24,
        Text(
          S.current.SelectLanguage,
          style: titleStyle,
        ),
        SpacingFoundation.verticalSpace16,
        Wrap(
          runSpacing: SpacingFoundation.verticalSpacing4,
          children: widget.allLanguages
              .map((language) => SizedBox(
                  height: 28.w,
                  width: 0.4.sw,
                  child: UiKitCheckboxFilterItem(
                    item: TitledFilterItem(
                        mask: language.name, value: language, selected: selectedLanguages.contains(language)),
                    onTap: (selected) {
                      setState(() {
                        if (!selectedLanguages.remove(language)) {
                          selectedLanguages.add(language);
                        }
                      });
                    },
                    isSelected: selectedLanguages.contains(language),
                  )))
              .toList(),
        ),
        SpacingFoundation.verticalSpace24,
        Text(
          S.current.Birthday,
          style: titleStyle,
        ),
        SpacingFoundation.verticalSpace16,
        for (var i in widget.allBirthdayTypes)
          UiKitCheckboxFilterItem(
            onTap: (selected) {
              setState(() {
                if (selected) {
                  selectedBirthdays.add(i);
                } else {
                  selectedBirthdays.remove(i);
                }
              });
            },
            item: TitledFilterItem(mask: i, value: i, selected: selectedBirthdays.contains(i)),
            isSelected: selectedBirthdays.contains(i),
          ).paddingOnly(bottom: SpacingFoundation.verticalSpacing12),
        SpacingFoundation.verticalSpace12,
        Text(
          S.current.Device,
          style: titleStyle,
        ),
        SpacingFoundation.verticalSpace16,
        Wrap(
          runSpacing: SpacingFoundation.verticalSpacing8,
          children: widget.allDevices
              .map((device) => SizedBox(
                  width: 0.4.sw,
                  child: UiKitCheckboxFilterItem(
                    item: TitledFilterItem(mask: device, value: device, selected: selectedBirthdays.contains(device)),
                    onTap: (selected) {
                      setState(() {
                        if (!selectedDevices.remove(device)) {
                          selectedDevices.add(device);
                        }
                      });
                    },
                    isSelected: selectedDevices.contains(device),
                  )))
              .toList(),
        ),
        SpacingFoundation.verticalSpace24,
        Text(
          S.current.Information,
          style: titleStyle,
        ),
        // SpacingFoundation.verticalSpace16,
        // UiKitFieldWithTagList(
        //     listUiKitTags: selectedCategories,
        //     title: S.of(context).Categories,
        //     onTap: () async {
        //       final newTags = await context.push(TagsSelectionComponent(
        //         selectedTags: selectedCategories,
        //         title: S.of(context).Categories,
        //         allTags: widget.allCategories,
        //       ));
        //       if (newTags != null) {
        //         setState(() {
        //           selectedCategories.clear();
        //           selectedCategories.addAll(newTags.toSet());
        //         });
        //       }
        //     }),
        SpacingFoundation.verticalSpace16,
        UiKitFieldWithTagList(
            listUiKitTags: selectedMindsets,
            title: S.of(context).ActivityTypes,
            onTap: () async {
              final newTags = await context.push(TagsSelectionComponent(
                selectedTags: selectedMindsets,
                title: S.of(context).ActivityTypes,
                allTags: widget.allMindsets,
              ));
              if (newTags != null) {
                setState(() {
                  selectedMindsets.clear();
                  selectedMindsets.addAll(newTags.toSet());
                  selectedPrefs.clear();
                });
              }
            }),
        if (selectedMindsets.isNotEmpty) ...[
          SpacingFoundation.verticalSpace16,
          UiKitFieldWithTagList(
              listUiKitTags: selectedPrefs,
              title: S.of(context).Preferences,
              onTap: () async {
                final newTags = await context.push(TagsSelectionComponent(
                  selectedTags: selectedPrefs,
                  title: S.of(context).Preferences,
                  allTags: widget.getPrefsForMindsetList(selectedMindsets),
                ));
                if (newTags != null) {
                  setState(() {
                    selectedPrefs.clear();
                    selectedPrefs.addAll(newTags.toSet());
                  });
                }
              }),
        ],
        SpacingFoundation.verticalSpace24,
        if (widget.onSaveTemplate != null)
          context.outlinedButton(
              data: BaseUiKitButtonData(
                  text: '${S.current.Save} ${S.current.Audience.toLowerCase()}',
                  onPressed: canSaveTemplate
                      ? () {
                          final titleController = TextEditingController();
                          enterNameUiKitDialog(context,
                              controller: titleController,
                              title: '${S.current.Save} ${S.current.Audience.toLowerCase()}', onConfirmTap: () {
                            final audience = AudienceUiModel(
                              title: titleController.text,
                              gender: selectedGenderId,
                              // genders: selectedGenders,
                              fromAge: selectedAgeFrom,
                              toAge: selectedAgeTo,
                              languages: selectedLanguages,
                              birthdayOptions: selectedBirthdays,
                              devices: selectedDevices,
                              selectedCategories: selectedCategories.toList(),
                              selectedMindsets: selectedMindsets.toList(),
                              selectedPrefs: selectedPrefs.toList(),
                            );
                            widget.onSaveTemplate?.call(audience);
                            navigatorKey.currentContext?.pop();
                          }).then((_) => titleController.dispose());
                        }
                      : null)),
        SpacingFoundation.verticalSpace24,
      ],
    );
  }
}
