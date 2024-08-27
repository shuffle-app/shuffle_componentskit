import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiUnifiedVerificationModel {
  final CountryModel? selectedCountry;
  final String? selectedTab;
  final RegistrationType? selectedRegistrationType;

  UiUnifiedVerificationModel({
    this.selectedCountry,
    this.selectedRegistrationType,
    this.selectedTab,
  });

  UiUnifiedVerificationModel copyWith({
    CountryModel? selectedCountry,
    String? selectedTab,
  }) {
    return UiUnifiedVerificationModel(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
