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
      errorSelectedMenuItem: selectedMenuItem == null ? S.current.PleaseSelectANiche : null,
      errorSelectedAudiences:
          (selectedAudiences?.isEmpty ?? true) ? S.current.PleaseSelectAtLeastOneTargetAudience : null,
      errorSelectedAgeRanges: (selectedAgeRanges?.isEmpty ?? true) ? S.current.PleaseSelectAtLeastOneAgeRange : null,
    );
  }
}
