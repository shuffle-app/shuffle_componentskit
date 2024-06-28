import '../components.dart';

class UiModelPropertiesCategory {
  final String title;
  final int id;
  final String? iconPath;
  final List<UiModelProperty>? baseProperties;
  final List<UiModelProperty>? uniqueProperties;
  final List<UiModelRelatedProperties>? relatedProperties;


  UiModelPropertiesCategory( {
    required this.title,
    this.relatedProperties,
    required this.id,
    this.iconPath,this.baseProperties, this.uniqueProperties,
  });

  UiModelPropertiesCategory copyWith({
    String? title,
    int? id,
    String? iconPath,
    List<UiModelProperty>? baseProperties,
    List<UiModelProperty>? uniqueProperties,
    List<UiModelRelatedProperties>? relatedProperties,
  }) {
    return UiModelPropertiesCategory(
      title: title ?? this.title,
      id: id ?? this.id,
      iconPath: iconPath ?? this.iconPath,
      baseProperties: baseProperties ?? this.baseProperties,
      uniqueProperties: uniqueProperties ?? this.uniqueProperties,
      relatedProperties: relatedProperties ?? this.relatedProperties,
    );
  }
}
