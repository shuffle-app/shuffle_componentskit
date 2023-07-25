import 'package:shuffle_uikit/foundation/countries_foundation.dart';

class UiCompanyLoginModel {
  final String? welcomeMessageTitle;
  final String? welcomeMessageBody;

  /// phone/email or anything else
  final List<RegistrationTypeData>? registrationTypes;
  final String? registrationPageDecorationImage;
  final CountryModel? selectedCountry;
  final RegistrationType? selectedRegistrationType;

  UiCompanyLoginModel({
    this.welcomeMessageTitle,
    this.welcomeMessageBody,
    this.registrationTypes,
    this.registrationPageDecorationImage,
    this.selectedCountry,
    this.selectedRegistrationType,
  });
}

enum RegistrationType {
  phone,
  email,
  another,
}

class RegistrationTypeData {
  final String title;
  final RegistrationType type;

  RegistrationTypeData({
    required this.title,
    required this.type,
  });
}
