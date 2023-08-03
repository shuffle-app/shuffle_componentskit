// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComponentProfileModel _$ComponentProfileModelFromJson(
        Map<String, dynamic> json) =>
    ComponentProfileModel(
      showFindPeople: json['show_find_people'] as bool?,
      showMessages: json['show_messages'] as bool?,
      showReviews: json['show_reviews'] as bool?,
      showReactions: json['show_reactions'] as bool?,
      showBalance: json['show_balace'] as bool?,
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
      positionModel: json['position_model'] == null
          ? null
          : PositionModel.fromJson(
              json['position_model'] as Map<String, dynamic>),
      version: json['version'] as String? ?? '0',
    );

Map<String, dynamic> _$ComponentProfileModelToJson(
        ComponentProfileModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
      'position_model': instance.positionModel,
      'show_balace': instance.showBalance,
      'show_find_people': instance.showFindPeople,
      'show_messages': instance.showMessages,
      'show_reviews': instance.showReviews,
      'show_reactions': instance.showReactions,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
  PageBuilderType.dialog: 'dialog',
};
