// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComponentPreferencesModel _$ComponentPreferencesModelFromJson(
        Map<String, dynamic> json) =>
    ComponentPreferencesModel(
      content:
          ContentBaseModel.fromJson(json['content'] as Map<String, dynamic>),
      showBubbleSearch: json['show_search_bubbles'] as bool?,
      version: json['version'] as String? ?? '0',
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
      positionModel: json['position_model'] == null
          ? null
          : PositionModel.fromJson(
              json['position_model'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ComponentPreferencesModelToJson(
        ComponentPreferencesModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
      'position_model': instance.positionModel,
      'content': instance.content,
      'show_search_bubbles': instance.showBubbleSearch,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
  PageBuilderType.dialog: 'dialog',
};
