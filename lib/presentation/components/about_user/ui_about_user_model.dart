import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiAboutUserModel {
  final List<UiKitBorderedChipWithIconData>? religions;
  final List<UiKitSignWithCaptionModel>? genders;
  final List<String>? personTypes;
  final String? selectedPersonType;

  UiAboutUserModel({
    this.religions,
    this.genders,
    this.personTypes,
    this.selectedPersonType,
  });
}
