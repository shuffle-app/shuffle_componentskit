// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComponentFeedModel _$ComponentFeedModelFromJson(Map<String, dynamic> json) =>
    ComponentFeedModel(
      showPlaces: json['show_places'] as bool?,
      showFeelings: json['show_feelings'] as bool?,
      showDailyRecomendation: json['show_daily_recomendation'] as bool?,
      showStories: json['show_stories'] as bool?,
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
      positionModel: json['position_model'] == null
          ? null
          : PositionModel.fromJson(
              json['position_model'] as Map<String, dynamic>),
      version: json['version'] as String? ?? '0',
    );

Map<String, dynamic> _$ComponentFeedModelToJson(ComponentFeedModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
      'position_model': instance.positionModel,
      'show_daily_recomendation': instance.showDailyRecomendation,
      'show_stories': instance.showStories,
      'show_feelings': instance.showFeelings,
      'show_places': instance.showPlaces,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
};
