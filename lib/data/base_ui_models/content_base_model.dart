import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'content_base_model.g.dart';

@JsonSerializable()
class ContentBaseModel {
  @JsonKey(name: 'title')
  final Map<ContentItemType, ContentBaseModel>? title;

  @JsonKey(name: 'subtitle')
  final Map<ContentItemType, ContentBaseModel>? subtitle;

  @JsonKey(name: 'body')
  final Map<ContentItemType, ContentBaseModel>? body;

  @JsonKey(name: 'properties')
  final Map<String, PropertiesBaseModel>? properties;

  @JsonKey(name: 'decoration')
  final Map<String, PropertiesBaseModel>? decoration;

  const ContentBaseModel({
    this.title,
    this.subtitle,
    this.decoration,
    this.body,
    this.properties,
  });

  factory ContentBaseModel.fromJson(Map<String, dynamic> json) => _$ContentBaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContentBaseModelToJson(this);
}
