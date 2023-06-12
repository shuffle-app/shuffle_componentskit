class UiDescriptionItemModel {
  final String title;
  final String description;
  final bool active;

  const UiDescriptionItemModel({
    required this.title,
    required this.description,
    this.active = true
  });
}
