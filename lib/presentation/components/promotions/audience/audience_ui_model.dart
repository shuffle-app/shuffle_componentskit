import 'package:shuffle_uikit/shuffle_uikit.dart';

class AudienceUiModel {
  final int? id;
  final String? title;
  final List<UiKitTag>? genders;
  final int? gender;
  final int? fromAge;
  final int? toAge;
  final List<LocaleModel>? languages;
  final List<String>? devices;
  final List<String>? birthdayOptions;
  final List<UiKitTag>? selectedCategories;
  final List<UiKitTag>? selectedMindsets;
  final List<UiKitTag>? selectedPrefs;

  const AudienceUiModel({
    this.id,
    this.title,
    this.genders,
    this.gender,
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
    List<UiKitTag>? genders,
    int? gender,
    int? fromAge,
    int? toAge,
    List<LocaleModel>? languages,
    List<String>? devices,
    List<String>? birthdayOptions,
    List<UiKitTag>? selectedCategories,
    List<UiKitTag>? selectedMindsets,
    List<UiKitTag>? selectedPrefs,
  }) =>
      AudienceUiModel(
        id: id ?? this.id,
        title: title ?? this.title,
        genders: genders ?? this.genders,
        gender: gender ?? this.gender,
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

  bool isIdentical(AudienceUiModel other) {
    return (genders ?? []).every((e) => (other.genders ?? []).contains(e)) &&
        gender == other.gender &&
        fromAge == other.fromAge &&
        toAge == other.toAge &&
        (languages ?? []).every((e) => (other.languages ?? []).contains(e)) &&
        (devices ?? []).every((e) => (other.devices ?? []).contains(e)) &&
        (birthdayOptions ?? []).every((e) => (other.birthdayOptions ?? []).contains(e)) &&
        // selectedCategories == other.selectedCategories &&
        (selectedMindsets ?? []).every((e) => (other.selectedMindsets ?? []).contains(e)) &&
        (selectedPrefs ?? []).every((e) => (other.selectedPrefs ?? []).contains(e));
  }

  @override
  String toString() =>
      'AudienceUiModel{id: $id, title: $title, genders: $genders, gender: $gender, fromAge: $fromAge, toAge: $toAge, languages: $languages, devices: $devices, birthdayOptions: $birthdayOptions, selectedCategories: $selectedCategories, selectedMindsets: $selectedMindsets, selectedPrefs: $selectedPrefs}';

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'genders': genders?.map((tag) => tag.toMap()).toList(),
        'gender': gender,
        'fromAge': fromAge,
        'toAge': toAge,
        'languages': languages,
        'devices': devices,
        'birthdayOptions': birthdayOptions,
        'selectedCategories': selectedCategories?.map((tag) => tag.toMap()).toList(),
        'selectedMindsets': selectedMindsets?.map((tag) => tag.toMap()).toList(),
        'selectedPrefs': selectedPrefs?.map((tag) => tag.toMap()).toList(),
      }..removeWhere((k, v) => v == null);

  static AudienceUiModel fromMap(Map<String, dynamic> map) => AudienceUiModel(
        id: map['id'],
        title: map['title'],
        genders: map['genders']?.map<UiKitTag>((item) => UiKitTag.fromMap(item)).toList(),
        gender: map['gender'],
        fromAge: map['fromAge'],
        toAge: map['toAge'],
        languages: map['languages']?.map<String>((e) => e as String).toList(),
        devices: map['devices']?.map<String>((e) => e as String).toList(),
        birthdayOptions: map['birthdayOptions']?.map<String>((e) => e as String).toList(),
        selectedCategories: map['selectedCategories']?.map<UiKitTag>((item) => UiKitTag.fromMap(item))?.toList(),
        selectedMindsets: map['selectedMindsets']?.map<UiKitTag>((item) => UiKitTag.fromMap(item))?.toList(),
        selectedPrefs: map['selectedPrefs']?.map<UiKitTag>((item) => UiKitTag.fromMap(item))?.toList(),
      );
}
