import 'package:json_annotation/json_annotation.dart';

part 'place_geocoding_response.g.dart';

@JsonSerializable()
class PlaceGeocodingResponse {
  @JsonKey(name: 'results')
  final List<GeocodingResult>? results;

  @JsonKey(name: 'status')
  final String? status;

  PlaceGeocodingResponse(this.results, this.status);

  factory PlaceGeocodingResponse.fromJson(Map<String, dynamic> json) => _$PlaceGeocodingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceGeocodingResponseToJson(this);
}

@JsonSerializable()
class GeocodingResult {
  @JsonKey(name: 'address_components')
  final List<AddressComponent>? addressComponents;

  @JsonKey(name: 'formatted_address')
  final String? formattedAddress;

  @JsonKey(name: 'geometry')
  final Geometry? geometry;

  @JsonKey(name: 'types')
  final List<String>? types;

  @JsonKey(name: 'place_id')
  final String? placeId;

  @JsonKey(name: 'partial_match')
  final bool? partialMatch;

  GeocodingResult(this.addressComponents, this.formattedAddress, this.geometry, this.types, this.placeId, this.partialMatch);

  factory GeocodingResult.fromJson(Map<String, dynamic> json) => _$GeocodingResultFromJson(json);

  Map<String, dynamic> toJson() => _$GeocodingResultToJson(this);
}

@JsonSerializable()
class AddressComponent {
  @JsonKey(name: 'long_name')
  final String? longName;

  @JsonKey(name: 'short_name')
  final String? shortName;

  @JsonKey(name: 'types')
  final List<String>? types;

  AddressComponent(this.longName, this.shortName, this.types);

  factory AddressComponent.fromJson(Map<String, dynamic> json) => _$AddressComponentFromJson(json);

  Map<String, dynamic> toJson() => _$AddressComponentToJson(this);
}

@JsonSerializable()
class Geometry {
  @JsonKey(name: 'bounds')
  final CoordinateBounds? bounds;

  @JsonKey(name: 'location')
  final Coordinates? location;

  @JsonKey(name: 'location_type')
  final String? locationType;

  @JsonKey(name: 'viewport')
  final CoordinateBounds? viewport;

  Geometry(this.bounds, this.location, this.locationType, this.viewport);

  factory Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable()
class CoordinateBounds {
  @JsonKey(name: 'northeast')
  final Coordinates? northeast;

  @JsonKey(name: 'southwest')
  final Coordinates? southwest;

  CoordinateBounds(this.northeast, this.southwest);

  factory CoordinateBounds.fromJson(Map<String, dynamic> json) => _$CoordinateBoundsFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinateBoundsToJson(this);
}

@JsonSerializable()
class Coordinates {
  @JsonKey(name: 'lat')
  final double? lat;

  @JsonKey(name: 'lng')
  final double? lon;

  Coordinates(this.lat, this.lon);

  factory Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}
