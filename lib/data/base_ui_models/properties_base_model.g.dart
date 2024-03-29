// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'properties_base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertiesBaseModel _$PropertiesBaseModelFromJson(Map<String, dynamic> json) =>
    PropertiesBaseModel(
      color: _fromHex(json['color'] as String?),
      type: json['type'] as String?,
      duration: json['duration'] == null
          ? const Duration(milliseconds: 250)
          : _intToDuration(json['duration']),
      imageLink: json['imageLink'] as String?,
      gradient: _stringToGradient(json['gradient']),
      value: json['value'] as String?,
      startDelay: _intToDuration(json['startDelay']),
      sortNumber: json['sortNumber'] as num? ?? 0,
    );

Map<String, dynamic> _$PropertiesBaseModelToJson(
        PropertiesBaseModel instance) =>
    <String, dynamic>{
      'sortNumber': instance.sortNumber,
      'duration': instance.duration?.inMicroseconds,
      'startDelay': instance.startDelay?.inMicroseconds,
      'imageLink': instance.imageLink,
      'value': instance.value,
      'gradient': _gradientToJson(instance.gradient),
      'color': _colorToJson(instance.color),
      'type': instance.type,
    };
