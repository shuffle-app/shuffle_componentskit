import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiAboutCompanyModel {
  final UiKitMenuItem? selectedMenuItem;
  final List<String>? selectedAudiences;
  final List<String>? selectedAgeRanges;

  UiAboutCompanyModel({
    this.selectedMenuItem,
    this.selectedAudiences,
    this.selectedAgeRanges,
  });

  UiAboutCompanyModel copyWith({
    UiKitMenuItem? selectedMenuItem,
    List<String>? selectedAudiences,
    List<String>? selectedAgeRanges,
  }) {
    return UiAboutCompanyModel(
      selectedMenuItem: selectedMenuItem ?? this.selectedMenuItem,
      selectedAudiences: selectedAudiences ?? this.selectedAudiences,
      selectedAgeRanges: selectedAgeRanges ?? this.selectedAgeRanges,
    );
  }
}
