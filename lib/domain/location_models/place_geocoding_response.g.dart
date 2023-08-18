// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_geocoding_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceGeocodingResponse _$PlaceGeocodingResponseFromJson(
        Map<String, dynamic> json) =>
    PlaceGeocodingResponse(
      (json['results'] as List<dynamic>?)
          ?.map((e) => GeocodingResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['status'] as String?,
    );

Map<String, dynamic> _$PlaceGeocodingResponseToJson(
        PlaceGeocodingResponse instance) =>
    <String, dynamic>{
      'results': instance.results,
      'status': instance.status,
    };

GeocodingResult _$GeocodingResultFromJson(Map<String, dynamic> json) =>
    GeocodingResult(
      (json['address_components'] as List<dynamic>?)
          ?.map((e) => AddressComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['formatted_address'] as String?,
      json['geometry'] == null
          ? null
          : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      (json['types'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['place_id'] as String?,
      json['partial_match'] as bool?,
    );

Map<String, dynamic> _$GeocodingResultToJson(GeocodingResult instance) =>
    <String, dynamic>{
      'address_components': instance.addressComponents,
      'formatted_address': instance.formattedAddress,
      'geometry': instance.geometry,
      'types': instance.types,
      'place_id': instance.placeId,
      'partial_match': instance.partialMatch,
    };

AddressComponent _$AddressComponentFromJson(Map<String, dynamic> json) =>
    AddressComponent(
      json['long_name'] as String?,
      json['short_name'] as String?,
      (json['types'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AddressComponentToJson(AddressComponent instance) =>
    <String, dynamic>{
      'long_name': instance.longName,
      'short_name': instance.shortName,
      'types': instance.types,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      json['bounds'] == null
          ? null
          : CoordinateBounds.fromJson(json['bounds'] as Map<String, dynamic>),
      json['location'] == null
          ? null
          : Coordinates.fromJson(json['location'] as Map<String, dynamic>),
      json['location_type'] as String?,
      json['viewport'] == null
          ? null
          : CoordinateBounds.fromJson(json['viewport'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'bounds': instance.bounds,
      'location': instance.location,
      'location_type': instance.locationType,
      'viewport': instance.viewport,
    };

CoordinateBounds _$CoordinateBoundsFromJson(Map<String, dynamic> json) =>
    CoordinateBounds(
      json['northeast'] == null
          ? null
          : Coordinates.fromJson(json['northeast'] as Map<String, dynamic>),
      json['southwest'] == null
          ? null
          : Coordinates.fromJson(json['southwest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CoordinateBoundsToJson(CoordinateBounds instance) =>
    <String, dynamic>{
      'northeast': instance.northeast,
      'southwest': instance.southwest,
    };

Coordinates _$CoordinatesFromJson(Map<String, dynamic> json) => Coordinates(
      (json['lat'] as num?)?.toDouble(),
      (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CoordinatesToJson(Coordinates instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lon,
    };
