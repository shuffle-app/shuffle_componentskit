import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiPersonalCredentialsVerificationModel {
  final CountryModel? selectedCountry;
  final String? selectedTab;
  final RegistrationType? selectedRegistrationType;

  UiPersonalCredentialsVerificationModel({
    this.selectedCountry,
    this.selectedRegistrationType,
    this.selectedTab,
  });

  UiPersonalCredentialsVerificationModel copyWith({
    CountryModel? selectedCountry,
    String? selectedTab,
  }) {
    return UiPersonalCredentialsVerificationModel(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
