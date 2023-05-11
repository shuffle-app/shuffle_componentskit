// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComponentEventModel _$ComponentEventModelFromJson(Map<String, dynamic> json) =>
    ComponentEventModel(
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
      positionModel: json['position_model'] == null
          ? null
          : PositionModel.fromJson(
              json['position_model'] as Map<String, dynamic>),
      version: json['version'] as String? ?? '0',
      showReviews: json['show_reviews'] as bool?,
      bookingElementModel: json['booking_element_model'] == null
          ? null
          : BookingElementModel.fromJson(
              json['booking_element_model'] as Map<String, dynamic>),
      showReactions: json['show_reactions'] as bool?,
    );

Map<String, dynamic> _$ComponentEventModelToJson(
        ComponentEventModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
      'position_model': instance.positionModel,
      'booking_element_model': instance.bookingElementModel,
      'show_reviews': instance.showReviews,
      'show_reactions': instance.showReactions,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
};
