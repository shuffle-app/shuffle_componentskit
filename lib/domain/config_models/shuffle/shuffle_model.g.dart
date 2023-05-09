// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shuffle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComponentShuffleModel _$ComponentShuffleModelFromJson(
        Map<String, dynamic> json) =>
    ComponentShuffleModel(
      showFavorite: json['show_favorite'] as bool?,
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
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
};
