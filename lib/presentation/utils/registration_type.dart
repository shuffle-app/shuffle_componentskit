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
