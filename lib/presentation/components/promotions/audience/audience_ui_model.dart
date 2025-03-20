import 'package:shuffle_uikit/shuffle_uikit.dart';

class AudienceUiModel {
  final int? id;
  final String? title;
  final List<UiKitTag>? genders;
  final int? fromAge;
  final int? toAge;
  final List<String>? languages;
  final List<String>? devices;
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
    List<UiKitTag>? genders,
    int? fromAge,
    int? toAge,
    List<String>? languages,
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

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'genders': genders?.map((tag) => tag.toMap()).toList(),
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
