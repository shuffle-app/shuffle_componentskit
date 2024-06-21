class UiModelPropertyType {
  final String title;
  final int id;
  final String? iconPath;

  UiModelPropertyType( {
    required this.title,
    required this.id,
    this.iconPath,
  });

  UiModelPropertyType copyWith({
    String? title,
    int? id,
    String? iconPath,
  }) {
    return UiModelPropertyType(
      title: title ?? this.title,
      id: id ?? this.id,
      iconPath: iconPath ?? this.iconPath,
    );
  }
}
