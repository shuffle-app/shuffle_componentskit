// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationDetailsResponse _$LocationDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    LocationDetailsResponse(
      (json['html_attributions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      json['result'] == null
          ? null
          : LocationDetails.fromJson(json['result'] as Map<String, dynamic>),
      json['status'] as String?,
    );

Map<String, dynamic> _$LocationDetailsResponseToJson(
        LocationDetailsResponse instance) =>
    <String, dynamic>{
      'html_attributions': instance.htmlAttributions,
      'result': instance.locationDetails,
      'status': instance.status,
    };

LocationDetails _$LocationDetailsFromJson(Map<String, dynamic> json) =>
    LocationDetails(
      (json['address_components'] as List<dynamic>?)
          ?.map((e) =>
              LocationAddressComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['adr_address'] as String?,
      json['formatted_address'] as String?,
      json['geometry'] == null
          ? null
          : LocationGeometry.fromJson(json['geometry'] as Map<String, dynamic>),
      json['icon'] as String?,
      json['icon_background_color'] as String?,
      json['icon_mask_base_uri'] as String?,
      json['name'] as String?,
      (json['photos'] as List<dynamic>?)
          ?.map((e) => LocationPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['place_id'] as String?,
      json['reference'] as String?,
      (json['types'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['url'] as String?,
      json['utc_offset'] as int?,
    );

Map<String, dynamic> _$LocationDetailsToJson(LocationDetails instance) =>
    <String, dynamic>{
      'address_components': instance.addressComponents,
      'adr_address': instance.adrAddress,
      'formatted_address': instance.formattedAddress,
      'geometry': instance.geometry,
      'icon': instance.icon,
      'icon_background_color': instance.iconBackgroundColor,
      'icon_mask_base_uri': instance.iconMaskBaseUri,
      'name': instance.name,
      'photos': instance.photos,
      'place_id': instance.placeId,
      'reference': instance.reference,
      'types': instance.types,
      'url': instance.url,
      'utc_offset': instance.utcOffset,
    };

LocationAddressComponent _$LocationAddressComponentFromJson(
        Map<String, dynamic> json) =>
    LocationAddressComponent(
      json['long_name'] as String?,
      json['short_name'] as String?,
      (json['types'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$LocationAddressComponentToJson(
        LocationAddressComponent instance) =>
    <String, dynamic>{
      'long_name': instance.longName,
      'short_name': instance.shortName,
      'types': instance.types,
    };

LocationGeometry _$LocationGeometryFromJson(Map<String, dynamic> json) =>
    LocationGeometry(
      json['location'] == null
          ? null
          : LocationCoordinates.fromJson(
              json['location'] as Map<String, dynamic>),
      json['viewport'] == null
          ? null
          : LocationViewport.fromJson(json['viewport'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationGeometryToJson(LocationGeometry instance) =>
    <String, dynamic>{
      'location': instance.location,
      'viewport': instance.viewport,
    };

LocationCoordinates _$LocationCoordinatesFromJson(Map<String, dynamic> json) =>
    LocationCoordinates(
      (json['lat'] as num?)?.toDouble(),
      (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LocationCoordinatesToJson(
        LocationCoordinates instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

LocationViewport _$LocationViewportFromJson(Map<String, dynamic> json) =>
    LocationViewport(
      json['northeast'] == null
          ? null
          : LocationCoordinates.fromJson(
              json['northeast'] as Map<String, dynamic>),
      json['southwest'] == null
          ? null
          : LocationCoordinates.fromJson(
              json['southwest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationViewportToJson(LocationViewport instance) =>
    <String, dynamic>{
      'northeast': instance.northeast,
      'southwest': instance.southwest,
    };

LocationPhoto _$LocationPhotoFromJson(Map<String, dynamic> json) =>
    LocationPhoto(
      json['height'] as int?,
      (json['html_attributions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      json['photo_reference'] as String?,
      json['width'] as int?,
    );

Map<String, dynamic> _$LocationPhotoToJson(LocationPhoto instance) =>
    <String, dynamic>{
      'height': instance.height,
      'html_attributions': instance.htmlAttributions,
      'photo_reference': instance.photoReference,
      'width': instance.width,
    };
