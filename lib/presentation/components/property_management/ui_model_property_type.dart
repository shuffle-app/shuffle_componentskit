class UiModelPropertyType {
  final String title;
  final int id;

  UiModelPropertyType({
    required this.title,
    required this.id,
  });

  UiModelPropertyType copyWith({
    String? title,
    int? id,
  }) {
    return UiModelPropertyType(
      title: title ?? this.title,
      id: id ?? this.id,
    );
  }
}
