// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_shuffle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComponentShuffleModel _$ComponentShuffleModelFromJson(
        Map<String, dynamic> json) =>
    ComponentShuffleModel(
      showFavorite: json['show_favorite'] as bool?,
      content: json['content'] == null
          ? const ContentBaseModel()
          : ContentBaseModel.fromJson(json['content'] as Map<String, dynamic>),
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
      positionModel: json['position_model'] == null
          ? null
          : PositionModel.fromJson(
              json['position_model'] as Map<String, dynamic>),
      version: json['version'] as String? ?? '0',
    );

Map<String, dynamic> _$ComponentShuffleModelToJson(
        ComponentShuffleModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
      'position_model': instance.positionModel,
      'show_favorite': instance.showFavorite,
      'content': instance.content,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
  PageBuilderType.dialog: 'dialog',
};
