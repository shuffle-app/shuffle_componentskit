class UiDescriptionItemModel {
  final String title;
  final String description;
  final String? descriptionUrl;
  final bool active;

  const UiDescriptionItemModel({
    required this.title,
    required this.description,
    this.active = true,
    this.descriptionUrl,
  });
}
