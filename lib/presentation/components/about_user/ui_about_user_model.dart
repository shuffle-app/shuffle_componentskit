import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiAboutUserModel {
  final UiKitMenuItem<String>? selectedPersonType;
  final List<String>? selectedReligions;

  final String? selectedGender;
  final int? selectedAge;
  String? errorPersonTypeMessage;
  String? errorGenderMessage;
  String? errorReligionMessage;

  bool get checkFields {
    if (selectedPersonType != null &&
        selectedGender != null &&
        selectedAge != null &&
        selectedReligions != null &&
        selectedReligions!.isNotEmpty) {
      return true;
    }

    return false;
  }

  UiAboutUserModel({
    this.selectedPersonType,
    this.selectedReligions,
    this.selectedGender,
    this.selectedAge,
    this.errorReligionMessage,
    this.errorGenderMessage,
    this.errorPersonTypeMessage,
  });

  UiAboutUserModel copyWith({
    UiKitMenuItem<String>? selectedPersonType,
    List<String>? selectedReligions,
    String? selectedGender,
    int? selectedAge,
  }) =>
      UiAboutUserModel(
        selectedPersonType: selectedPersonType ?? this.selectedPersonType,
        selectedReligions: selectedReligions ?? this.selectedReligions,
        selectedGender: selectedGender ?? this.selectedGender,
        selectedAge: selectedAge ?? this.selectedAge,
      );

  UiAboutUserModel withErrors() => UiAboutUserModel(
        selectedPersonType: selectedPersonType,
        selectedReligions: selectedReligions,
        selectedGender: selectedGender,
        selectedAge: selectedAge,
      )
        ..errorPersonTypeMessage = selectedPersonType != null ? null : S.current.PleaseSelectOneType
        ..errorGenderMessage = selectedGender != null ? null : S.current.PleaseSelectGender
        ..errorReligionMessage = (selectedReligions != null && selectedReligions!.isNotEmpty)
            ? null
            : S.current.PleaseSelectAtLeastNReligion(1);
}
