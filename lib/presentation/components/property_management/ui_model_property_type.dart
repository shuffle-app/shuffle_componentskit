class UiModelProperty {
  final String title;
  final int id;
  final String? iconPath;
  final bool? isSelected;

  UiModelProperty(  {
    required this.title,
    required this.id,
    this.iconPath,
    this.isSelected,
  });

  UiModelProperty copyWith({
    String? title,
    int? id,
    String? iconPath,
    bool? isSelected,
  }) {
    return UiModelProperty(
      title: title ?? this.title,
      id: id ?? this.id,
      iconPath: iconPath ?? this.iconPath,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
