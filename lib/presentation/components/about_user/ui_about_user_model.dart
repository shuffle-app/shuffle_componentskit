import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiAboutUserModel {
  final List<UiKitBorderedChipWithIconData>? religions;
  final List<UiKitSignWithCaptionModel>? genders;
  final List<UiKitMenuItemTileModel<String>>? personTypes;
  final UiKitMenuItem<String?>? selectedPersonType;
  final String? name;
  final String? nickName;
  final List<String?>? selectedReligions;
  final String? selectedGender;
  final int? selectedAge;

  UiAboutUserModel({
    this.religions,
    this.genders,
    this.personTypes,
    this.selectedPersonType,
    this.name,
    this.nickName,
    this.selectedReligions,
    this.selectedGender,
    this.selectedAge,
  });

  UiAboutUserModel copyWith({
    List<UiKitBorderedChipWithIconData>? religions,
    List<UiKitSignWithCaptionModel>? genders,
    List<UiKitMenuItemTileModel<String>>? personTypes,
    UiKitMenuItem<String?>? selectedPersonType,
    String? name,
    String? nickName,
    List<String?>? selectedReligions,
    String? selectedGender,
    int? selectedAge,
  }) =>
      UiAboutUserModel(
        religions: religions ?? this.religions,
        genders: genders ?? this.genders,
        personTypes: personTypes ?? this.personTypes,
        selectedPersonType: selectedPersonType ?? this.selectedPersonType,
        name: name ?? this.name,
        nickName: nickName ?? this.nickName,
        selectedReligions: selectedReligions ?? this.selectedReligions,
        selectedGender: selectedGender ?? this.selectedGender,
        selectedAge: selectedAge ?? this.selectedAge,
      );
}
