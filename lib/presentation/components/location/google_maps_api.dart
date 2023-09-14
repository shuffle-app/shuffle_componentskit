import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../domain/location_models/location_details_response.dart';
import '../../../domain/location_models/location_search_autocomplete_response.dart';
import '../../../domain/location_models/place_geocoding_response.dart';

const apiKey = String.fromEnvironment('googleApiKey');


class GoogleMapsApi {
  static const baseUrl = 'maps.googleapis.com';

  static Future<PlaceGeocodingResponse?> fetchPlaceFromCoordinates({
    required String latlng,
    String language = 'en',
  }) async {
    const path = '/maps/api/geocode/json';
    final url = Uri.https(baseUrl, path, {
      'key': apiKey,
      'latlng': latlng,
      'language': language,
    });
    final _result = await http.get(url, );
    if (_result.statusCode == 200) {
      return PlaceGeocodingResponse.fromJson(json.decode(_result.body));
    }

    return null;
  }

  static Future<LocationDetailsResponse?> fetchPlaceDetails({
    required String placeId,
  }) async {
    const path = '/maps/api/place/details/json';
    final url = Uri.https(baseUrl, path, {
      'key': apiKey,
      'place_id': placeId,
    });
    final _result = await http.get(url);
    if (_result.statusCode == 200) {
      return LocationDetailsResponse.fromJson(json.decode(_result.body));
    }

    return null;
  }

  static Future<LocationSearchAutocompleteResponse?> completeQuery({
    required String query,
  }) async {
    const path = '/maps/api/place/queryautocomplete/json';
    final url = Uri.https(baseUrl, path, {
      'key': apiKey,
      'input': query,
    });
    final _result = await http.get(url);
    if (_result.statusCode == 200) {
      return LocationSearchAutocompleteResponse.fromJson(json.decode(_result.body));
    }

    return null;
  }
}
