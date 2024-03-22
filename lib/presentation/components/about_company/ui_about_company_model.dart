import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiAboutCompanyModel {
  final UiKitMenuItem<int>? selectedMenuItem;
  final List<String>? selectedPriceSegments;
  final List<String>? selectedAgeRanges;
  String? errorSelectedMenuItem;
  String? errorSelectedAudiences;
  String? errorSelectedAgeRanges;

  bool get checkFields {
    final hasNull = selectedMenuItem == null || selectedPriceSegments == null || selectedAgeRanges == null;
    final hasEmptySelection =
        selectedMenuItem == null || (selectedPriceSegments?.isEmpty ?? false) || (selectedAgeRanges?.isEmpty ?? false);

    if (hasNull || hasEmptySelection) {
      return false;
    }

    return true;
  }

  UiAboutCompanyModel({
    this.selectedMenuItem,
    this.selectedPriceSegments,
    this.selectedAgeRanges,
    this.errorSelectedMenuItem,
    this.errorSelectedAudiences,
    this.errorSelectedAgeRanges,
  });

  UiAboutCompanyModel copyWith({
    UiKitMenuItem<int>? selectedMenuItem,
    List<String>? selectedPriceSegments,
    List<String>? selectedAgeRanges,
  }) {
    return UiAboutCompanyModel(
      selectedMenuItem: selectedMenuItem ?? this.selectedMenuItem,
      selectedPriceSegments: selectedPriceSegments ?? this.selectedPriceSegments,
      selectedAgeRanges: selectedAgeRanges ?? this.selectedAgeRanges,
      errorSelectedMenuItem: selectedMenuItem == null ? errorSelectedMenuItem : null,
      errorSelectedAudiences: (selectedPriceSegments?.isEmpty ?? true) ? errorSelectedAudiences : null,
      errorSelectedAgeRanges: (selectedAgeRanges?.isEmpty ?? true) ? errorSelectedAgeRanges : null,
    );
  }

  UiAboutCompanyModel withErrors() {
    return UiAboutCompanyModel(
      selectedMenuItem: selectedMenuItem,
      selectedPriceSegments: selectedPriceSegments,
      selectedAgeRanges: selectedAgeRanges,
      errorSelectedMenuItem: selectedMenuItem == null ? S.current.PleaseSelectANiche : null,
      errorSelectedAudiences:
          (selectedPriceSegments?.isEmpty ?? true) ? S.current.PleaseSelectAtLeastOnePriceSegment : null,
      errorSelectedAgeRanges: (selectedAgeRanges?.isEmpty ?? true) ? S.current.PleaseSelectAtLeastOneAgeRange : null,
    );
  }
}
