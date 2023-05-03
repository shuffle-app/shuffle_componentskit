// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComponentPlaceModel _$PlaceModelFromJson(Map<String, dynamic> json) => ComponentPlaceModel(
      showRating: json['show_rating'] as bool?,
      showReviews: json['show_reviews'] as bool?,
      bookingElementModel: json['booking_element_model'] == null
          ? null
          : BookingElementModel.fromJson(
              json['booking_element_model'] as Map<String, dynamic>),
      showReactions: json['show_reactions'] as bool?,
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
      positionModel: json['position_model'] == null
          ? null
          : PositionModel.fromJson(
              json['position_model'] as Map<String, dynamic>),
      version: json['version'] as String? ?? '0',
    );

Map<String, dynamic> _$PlaceModelToJson(ComponentPlaceModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
      'position_model': instance.positionModel,
      'booking_element_model': instance.bookingElementModel,
      'show_rating': instance.showRating,
      'show_reviews': instance.showReviews,
      'show_reactions': instance.showReactions,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
};
