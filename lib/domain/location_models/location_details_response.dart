import 'package:json_annotation/json_annotation.dart';

part 'location_details_response.g.dart';

@JsonSerializable()
class LocationDetailsResponse {
  @JsonKey(name: 'html_attributions')
  final List<String>? htmlAttributions;

  @JsonKey(name: 'result')
  final LocationDetails? locationDetails;

  @JsonKey(name: 'status')
  final String? status;

  LocationDetailsResponse(this.htmlAttributions, this.locationDetails, this.status);

  factory LocationDetailsResponse.fromJson(Map<String, dynamic> json) => _$LocationDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDetailsResponseToJson(this);
}

@JsonSerializable()
class LocationDetails {
  @JsonKey(name: 'address_components')
  final List<LocationAddressComponent>? addressComponents;

  @JsonKey(name: 'adr_address')
  final String? adrAddress;

  @JsonKey(name: 'formatted_address')
  final String? formattedAddress;

  @JsonKey(name: 'geometry')
  final LocationGeometry? geometry;

  @JsonKey(name: 'icon')
  final String? icon;

  @JsonKey(name: 'icon_background_color')
  final String? iconBackgroundColor;

  @JsonKey(name: 'icon_mask_base_uri')
  final String? iconMaskBaseUri;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'photos')
  final List<LocationPhoto>? photos;

  @JsonKey(name: 'place_id')
  final String? placeId;

  @JsonKey(name: 'reference')
  final String? reference;

  @JsonKey(name: 'types')
  final List<String>? types;

  @JsonKey(name: 'url')
  final String? url;

  @JsonKey(name: 'utc_offset')
  final int? utcOffset;

  LocationDetails(this.addressComponents, this.adrAddress, this.formattedAddress, this.geometry, this.icon, this.iconBackgroundColor, this.iconMaskBaseUri, this.name, this.photos, this.placeId, this.reference, this.types, this.url, this.utcOffset);

  factory LocationDetails.fromJson(Map<String, dynamic> json) => _$LocationDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDetailsToJson(this);
}

@JsonSerializable()
class LocationAddressComponent {
  @JsonKey(name: 'long_name')
  final String? longName;

  @JsonKey(name: 'short_name')
  final String? shortName;

  @JsonKey(name: 'types')
  final List<String>? types;

  LocationAddressComponent(this.longName, this.shortName, this.types);

  factory LocationAddressComponent.fromJson(Map<String, dynamic> json) => _$LocationAddressComponentFromJson(json);

  Map<String, dynamic> toJson() => _$LocationAddressComponentToJson(this);
}

@JsonSerializable()
class LocationGeometry {
  @JsonKey(name: 'location')
  final LocationCoordinates? location;

  @JsonKey(name: 'viewport')
  final LocationViewport? viewport;

  LocationGeometry(this.location, this.viewport);

  factory LocationGeometry.fromJson(Map<String, dynamic> json) => _$LocationGeometryFromJson(json);

  Map<String, dynamic> toJson() => _$LocationGeometryToJson(this);
}

@JsonSerializable()
class LocationCoordinates {
  @JsonKey(name: 'lat')
  final double? lat;

  @JsonKey(name: 'lng')
  final double? lng;

  LocationCoordinates(this.lat, this.lng);

  factory LocationCoordinates.fromJson(Map<String, dynamic> json) => _$LocationCoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$LocationCoordinatesToJson(this);
}

@JsonSerializable()
class LocationViewport {
  @JsonKey(name: 'northeast')
  final LocationCoordinates? northeast;

  @JsonKey(name: 'southwest')
  final LocationCoordinates? southwest;

  LocationViewport(this.northeast, this.southwest);

  factory LocationViewport.fromJson(Map<String, dynamic> json) => _$LocationViewportFromJson(json);

  Map<String, dynamic> toJson() => _$LocationViewportToJson(this);
}

@JsonSerializable()
class LocationPhoto {
  @JsonKey(name: 'height')
  final int? height;

  @JsonKey(name: 'html_attributions')
  final List<String>? htmlAttributions;

  @JsonKey(name: 'photo_reference')
  final String? photoReference;

  @JsonKey(name: 'width')
  final int? width;

  LocationPhoto(this.height, this.htmlAttributions, this.photoReference, this.width);

  factory LocationPhoto.fromJson(Map<String, dynamic> json) => _$LocationPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationPhotoToJson(this);
}

