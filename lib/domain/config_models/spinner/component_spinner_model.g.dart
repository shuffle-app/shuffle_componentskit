// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_spinner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComponentSpinnerModel _$ComponentSpinnerModelFromJson(
        Map<String, dynamic> json) =>
    ComponentSpinnerModel(
      showFavorite: json['show_favorite'] as bool?,
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
      positionModel: json['position_model'] == null
          ? null
          : PositionModel.fromJson(
              json['position_model'] as Map<String, dynamic>),
      version: json['version'] as String? ?? '0',
    );

Map<String, dynamic> _$ComponentSpinnerModelToJson(
        ComponentSpinnerModel instance) =>
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
