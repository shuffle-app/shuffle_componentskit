class UiEditDefaultProfileModel {
  final String? photo;
  final String? name;
  final String? email;
  final String? nickName;
  final String? phone;
  final String? dateOfBirth;
  final List<String>? preferences;

  String get preferencesString => preferences?.join(', ') ?? '';

  UiEditDefaultProfileModel({
    this.photo,
    this.name,
    this.email,
    this.nickName,
    this.phone,
    this.dateOfBirth,
    this.preferences,
  });
}
