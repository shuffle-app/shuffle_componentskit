// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_mood_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComponentMoodModel _$ComponentMoodModelFromJson(Map<String, dynamic> json) =>
    ComponentMoodModel(
      showPlaces: json['show_places'] as bool?,
      showStats: json['show_stats'] as bool?,
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
      positionModel: json['position_model'] == null
          ? null
          : PositionModel.fromJson(
              json['position_model'] as Map<String, dynamic>),
      version: json['version'] as String? ?? '0',
    );

Map<String, dynamic> _$ComponentMoodModelToJson(ComponentMoodModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
      'position_model': instance.positionModel,
      'show_stats': instance.showStats,
      'show_places': instance.showPlaces,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
  PageBuilderType.dialog: 'dialog',
  PageBuilderType.generalDialog: 'general_dialog',
};
