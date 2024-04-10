import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiAboutUserModel {
  final UiKitMenuItem<int>? selectedPersonType;
  final List<int>? selectedReligionsIds;

  final int? selectedGenderId;
  final int? selectedAge;
  String? errorPersonTypeMessage;
  String? errorGenderMessage;
  String? errorReligionMessage;

  bool get checkFields {
    if (selectedPersonType != null &&
        selectedGenderId != null &&
        selectedAge != null &&
        selectedReligionsIds != null &&
        selectedReligionsIds!.isNotEmpty) {
      return true;
    }

    return false;
  }

  UiAboutUserModel({
    this.selectedPersonType,
    this.selectedReligionsIds,
    this.selectedGenderId,
    this.selectedAge,
    this.errorReligionMessage,
    this.errorGenderMessage,
    this.errorPersonTypeMessage,
  });

  UiAboutUserModel copyWith({
    UiKitMenuItem<int>? selectedPersonType,
    List<int>? selectedReligionsIds,
    int? selectedGenderId,
    int? selectedAge,
  }) =>
      UiAboutUserModel(
        selectedPersonType: selectedPersonType ?? this.selectedPersonType,
        selectedReligionsIds: selectedReligionsIds ?? this.selectedReligionsIds,
        selectedGenderId: selectedGenderId ?? this.selectedGenderId,
        selectedAge: selectedAge ?? this.selectedAge,
      );

  UiAboutUserModel withErrors() => UiAboutUserModel(
        selectedPersonType: selectedPersonType,
        selectedReligionsIds: selectedReligionsIds,
        selectedGenderId: selectedGenderId,
        selectedAge: selectedAge,
      )
        ..errorPersonTypeMessage = selectedPersonType != null ? null : S.current.PleaseSelectOneType;
        // ..errorGenderMessage = selectedGenderId != null ? null : S.current.PleaseSelectGender
        // ..errorReligionMessage = (selectedReligionsIds != null && selectedReligionsIds!.isNotEmpty)
        //     ? null
        //     : S.current.PleaseSelectAtLeastNReligion(1);
}
