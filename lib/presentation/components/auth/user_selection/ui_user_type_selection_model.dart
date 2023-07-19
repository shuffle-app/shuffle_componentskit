class UiUserTypeSelectionModel {
  final String? pageTitle;
  final String? pageBodyText;
  final List<UserTypeModel>? userTypes;

  UiUserTypeSelectionModel({
    this.pageTitle,
    this.pageBodyText,
    this.userTypes,
  });
}

class UserTypeModel {
  final String? iconPath;
  final String? title;
  final String type;

  UserTypeModel({
    this.iconPath,
    this.title,
    required this.type,
  });
}
