import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'content_base_model.g.dart';

@JsonSerializable()
class ContentBaseModel {

  @JsonKey(name: 'title',)
  final Map<ContentItemType,ContentBaseModel>? title;

  @JsonKey(name: 'body')
  final Map<ContentItemType,ContentBaseModel>? body;

  @JsonKey(name: 'properties')
  final Map<String,PropertiesBaseModel>? properties;

  const ContentBaseModel({
    this.title,
    this.body,
    this.properties,
  });

  factory ContentBaseModel.fromJson(Map<String, dynamic> json) =>
      _$ContentBaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContentBaseModelToJson(this);
}
