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

RegistrationType indentifyRegistrationType(String value) {
  switch (value) {
    case 'phone':
      return RegistrationType.phone;
    case 'email':
      return RegistrationType.email;
    default:
      return RegistrationType.another;
  }
}
