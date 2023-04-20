// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionModel _$PositionModelFromJson(Map<String, dynamic> json) =>
    PositionModel(
      verticalMargin: (json['vertical_margin'] as num?)?.toDouble(),
      horizontalMargin: (json['horizontal_margin'] as num?)?.toDouble(),
      version: json['version'] as String,
      titleAlignment: _stringToAlignment(json['title_alignment'] as String?),
      bodyAlignment: _stringToAlignment(json['body_alignment'] as String?),
    );

Map<String, dynamic> _$PositionModelToJson(PositionModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'title_alignment': _alignmentToString(instance.titleAlignment),
      'body_alignment': _alignmentToString(instance.bodyAlignment),
      'vertical_margin': instance.verticalMargin,
      'horizontal_margin': instance.horizontalMargin,
    };
