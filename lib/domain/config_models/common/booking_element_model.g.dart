// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_element_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingElementModel _$BookingElementModelFromJson(Map<String, dynamic> json) =>
    BookingElementModel(
      showRoute: json['show_route'] as bool?,
      showMagnify: json['show_magnify'] as bool?,
      version: json['version'] as String,
      positionModel: json['position_model'] == null
          ? null
          : PositionModel.fromJson(
              json['position_model'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingElementModelToJson(
        BookingElementModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'position_model': instance.positionModel,
      'show_route': instance.showRoute,
      'show_magnify': instance.showMagnify,
    };
