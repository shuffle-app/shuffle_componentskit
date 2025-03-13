import 'package:shuffle_uikit/shuffle_uikit.dart';

class AudienceUiModel {
  final int? id;
  final String? title;
  final List<UiKitTag>? genders;
  final int? fromAge;
  final int? toAge;
  final List<String>? languages;
  final List<UiKitTag>? devices;
  final List<String>? birthdayOptions;
  final List<UiKitTag>? selectedCategories;
  final List<UiKitTag>? selectedMindsets;
  final List<UiKitTag>? selectedPrefs;

  const AudienceUiModel({
    this.id,
    this.title,
    this.genders,
    this.fromAge,
    this.toAge,
    this.languages,
    this.devices,
    this.birthdayOptions,
    this.selectedCategories,
    this.selectedMindsets,
    this.selectedPrefs,
  });

  AudienceUiModel copyWith({
    int? id,
    String? title,
    List<UiKitTag>? gender,
    int? fromAge,
    int? toAge,
    List<String>? languages,
    List<UiKitTag>? devices,
    List<String>? birthdayOptions,
    List<UiKitTag>? selectedCategories,
    List<UiKitTag>? selectedMindsets,
    List<UiKitTag>? selectedPrefs,
  }) =>
      AudienceUiModel(
        id: id ?? this.id,
        title: title ?? this.title,
        genders: genders ?? this.genders,
        fromAge: fromAge ?? this.fromAge,
        toAge: toAge ?? this.toAge,
        languages: languages ?? this.languages,
        devices: devices ?? this.devices,
        birthdayOptions: birthdayOptions ?? this.birthdayOptions,
        selectedCategories: selectedCategories ?? this.selectedCategories,
        selectedMindsets: selectedMindsets ?? this.selectedMindsets,
        selectedPrefs: selectedPrefs ?? this.selectedPrefs,
      );

  @override
  bool operator ==(Object other) => other is AudienceUiModel && id == other.id;

  @override
  int get hashCode => id?.hashCode ?? 0;
}
