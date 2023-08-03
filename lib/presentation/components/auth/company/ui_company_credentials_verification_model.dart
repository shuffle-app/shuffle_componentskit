import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/foundation/countries_foundation.dart';

class UiCompanyCredentialsVerificationModel {
  /// phone/email or anything else
  final CountryModel? selectedCountry;
  final RegistrationType? selectedRegistrationType;
  final String? selectedTab;

  UiCompanyCredentialsVerificationModel({
    this.selectedCountry,
    this.selectedRegistrationType = RegistrationType.phone,
    this.selectedTab,
  });

  UiCompanyCredentialsVerificationModel copyWith({
    CountryModel? selectedCountry,
    RegistrationType? selectedRegistrationType,
    String? selectedTab,
  }) {
    return UiCompanyCredentialsVerificationModel(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedRegistrationType: selectedRegistrationType ?? this.selectedRegistrationType,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
