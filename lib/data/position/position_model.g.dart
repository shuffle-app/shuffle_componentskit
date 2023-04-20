// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionModel _$PositionModelFromJson(Map<String, dynamic> json) =>
    PositionModel(
      version: json['version'] as String,
      alignment: _stringToAlignment(json['alignment'] as String?),
    );

Map<String, dynamic> _$PositionModelToJson(PositionModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'alignment': _alignmentToString(instance.alignment),
    };
