import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiAboutUserModel {
  // final List<UiKitBorderedChipWithIconData>? religions;
  // final List<UiKitSignWithCaptionModel>? genders;
  // final List<UiKitMenuItemTileModel<String>>? personTypes;
  final UiKitMenuItem<String>? selectedPersonType;
  final List<String>? selectedReligions;
  final String? selectedGender;
  final int? selectedAge;
  String? errorPersonTypeMessage;
  String? errorGenderMessage;
  String? errorReligionMessage;


  bool get checkFields {
    if (selectedPersonType != null && selectedGender != null &&
        selectedAge != null && selectedReligions != null &&
        selectedReligions!.isNotEmpty) {
      return true;
    }

    return false;
  }


  UiAboutUserModel({
    // this.religions,
    // this.genders,
    // this.personTypes,
    this.selectedPersonType,
    this.selectedReligions,
    this.selectedGender,
    this.selectedAge,
    this.errorReligionMessage,
    this.errorGenderMessage,
    this.errorPersonTypeMessage,
  });


  UiAboutUserModel copyWith({
    // List<UiKitBorderedChipWithIconData>? religions,
    // List<UiKitSignWithCaptionModel>? genders,
    // List<UiKitMenuItemTileModel<String>>? personTypes,
    UiKitMenuItem<String>? selectedPersonType,
    List<String>? selectedReligions,
    String? selectedGender,
    int? selectedAge,
  }) =>
      UiAboutUserModel(
        // religions: religions ?? this.religions,
        // genders: genders ?? this.genders,
        // personTypes: personTypes ?? this.personTypes,
        selectedPersonType: selectedPersonType ?? this.selectedPersonType,
        selectedReligions: selectedReligions ?? this.selectedReligions,
        selectedGender: selectedGender ?? this.selectedGender,
        selectedAge: selectedAge ?? this.selectedAge,
      );

  UiAboutUserModel withErrors() =>
      UiAboutUserModel(
        // religions: this.religions,
        // genders: this.genders,
        // personTypes: this.personTypes,
        selectedPersonType: this.selectedPersonType,
        selectedReligions: this.selectedReligions,
        selectedGender: this.selectedGender,
        selectedAge: this.selectedAge,
      )
        .. errorPersonTypeMessage =
        selectedPersonType != null
            ? null
            : 'Please select one type'
        ..
        errorGenderMessage =
        selectedGender != null ? null : 'Please select a gender'
        ..
        errorReligionMessage =
        (selectedReligions != null && selectedReligions!.isNotEmpty) ? null : 'Please select at least 1 religion';


}
