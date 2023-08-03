import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiAboutCompanyModel {
  final UiKitMenuItem<String>? selectedMenuItem;
  final List<String>? selectedAudiences;
  final List<String>? selectedAgeRanges;
  String? errorSelectedMenuItem;
  String? errorSelectedAudiences;
  String? errorSelectedAgeRanges;

  bool get checkFields {
    final hasNull = selectedMenuItem == null || selectedAudiences == null || selectedAgeRanges == null;
    final hasEmptySelection =
        selectedMenuItem == null || (selectedAudiences?.isEmpty ?? false) || (selectedAgeRanges?.isEmpty ?? false);

    if (hasNull || hasEmptySelection) {
      return false;
    }

    return true;
  }

  UiAboutCompanyModel({
    this.selectedMenuItem,
    this.selectedAudiences,
    this.selectedAgeRanges,
    this.errorSelectedMenuItem,
    this.errorSelectedAudiences,
    this.errorSelectedAgeRanges,
  });

  UiAboutCompanyModel copyWith({
    UiKitMenuItem<String>? selectedMenuItem,
    List<String>? selectedAudiences,
    List<String>? selectedAgeRanges,
  }) {
    return UiAboutCompanyModel(
      selectedMenuItem: selectedMenuItem ?? this.selectedMenuItem,
      selectedAudiences: selectedAudiences ?? this.selectedAudiences,
      selectedAgeRanges: selectedAgeRanges ?? this.selectedAgeRanges,
      errorSelectedMenuItem: selectedMenuItem == null ? errorSelectedMenuItem : null,
      errorSelectedAudiences: (selectedAudiences?.isEmpty ?? true) ? errorSelectedAudiences : null,
      errorSelectedAgeRanges: (selectedAgeRanges?.isEmpty ?? true) ? errorSelectedAgeRanges : null,
    );
  }

  UiAboutCompanyModel withErrors() {
    return UiAboutCompanyModel(
      selectedMenuItem: selectedMenuItem,
      selectedAudiences: selectedAudiences,
      selectedAgeRanges: selectedAgeRanges,
      errorSelectedMenuItem: selectedMenuItem == null ? 'Please select a niche' : null,
      errorSelectedAudiences: (selectedAudiences?.isEmpty ?? true) ? 'Please select at least one target audience' : null,
      errorSelectedAgeRanges: (selectedAgeRanges?.isEmpty ?? true) ? 'Please select at least one age range' : null,
    );
  }
}
