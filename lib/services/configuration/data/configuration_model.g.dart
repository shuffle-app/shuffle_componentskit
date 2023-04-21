// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigurationModel _$ConfigurationModelFromJson(Map<String, dynamic> json) =>
    ConfigurationModel(
      updated: DateTime.parse(json['updated'] as String),
      content: json['content'] as Map<String, dynamic>,
      theme: json['theme'] as String,
    );

Map<String, dynamic> _$ConfigurationModelToJson(ConfigurationModel instance) =>
    <String, dynamic>{
      'updated': instance.updated.toIso8601String(),
      'content': instance.content,
      'theme': instance.theme,
    };
