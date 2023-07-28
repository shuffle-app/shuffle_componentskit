import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiCredentialsVerificationModel {
  final CountryModel? selectedCountry;
  final String? selectedTab;

  UiCredentialsVerificationModel({
    this.selectedCountry,
    this.selectedTab,
  });

  UiCredentialsVerificationModel copyWith({
    CountryModel? selectedCountry,
    String? selectedTab,
  }) {
    return UiCredentialsVerificationModel(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
