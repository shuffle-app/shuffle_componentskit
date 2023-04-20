// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      showReviews: json['show_reviews'] as bool?,
      bookingElementModel: json['booking_element_model'] == null
          ? null
          : BookingElementModel.fromJson(
              json['booking_element_model'] as Map<String, dynamic>),
      showReactions: json['show_reactions'] as bool?,
      version: json['version'] as String,
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
      positionModel: json['position_model'] == null
          ? null
          : PositionModel.fromJson(
              json['position_model'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
      'position_model': instance.positionModel,
      'booking_element_model': instance.bookingElementModel,
      'show_reviews': instance.showReviews,
      'show_reactions': instance.showReactions,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modalBottomSheet',
  PageBuilderType.page: 'page',
};
