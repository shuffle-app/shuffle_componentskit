import 'package:json_annotation/json_annotation.dart';

part 'configuration_model.g.dart';

@JsonSerializable()
class ConfigurationModel {
  @JsonKey(name: 'updated')
  final DateTime updated;

  @JsonKey(name: 'content')
  final Map<String, dynamic> content;

  @JsonKey(name: 'theme')
  final String theme;

  ConfigurationModel({
    required this.updated,
    required this.content,
    required this.theme,
  });

  factory ConfigurationModel.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigurationModelToJson(this);
}
