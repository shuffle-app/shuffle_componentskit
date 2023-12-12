import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../../domain/location_models/location_details_response.dart';
import '../../../domain/location_models/location_search_autocomplete_response.dart';
import '../../../domain/location_models/place_geocoding_response.dart';

const apiKey = String.fromEnvironment('googleApiKey');
const proxyPrefix = String.fromEnvironment('proxyPrefix', defaultValue: '');

class GoogleMapsApi {
  static const String _baseUrl = 'maps.googleapis.com';

  static String get baseUrl => (proxyPrefix.isNotEmpty ? '$proxyPrefix/proxy/https://' : proxyPrefix) + _baseUrl;

  static Future<PlaceGeocodingResponse?> fetchPlaceFromCoordinates({
    required String latlng,
    String language = 'en',
  }) async {
    const path = '/maps/api/geocode/json';
    final url = _getUri(path, {
      'key': apiKey,
      'latlng': latlng,
      'language': language,
    });
    final result = await http.get(
      url,
    );
    if (result.statusCode == 200) {
      return PlaceGeocodingResponse.fromJson(json.decode(result.body));
    }

    return null;
  }

  static Future<LocationDetailsResponse?> fetchPlaceDetails({
    required String placeId,
  }) async {
    const path = '/maps/api/place/details/json';
    final url = _getUri(path, {
      'key': apiKey,
      'place_id': placeId,
    });
    final result = await http.get(url);
    if (result.statusCode == 200) {
      return LocationDetailsResponse.fromJson(json.decode(result.body));
    }

    return null;
  }

  static Future<LocationSearchAutocompleteResponse?> completeQuery({
    required String query,
  }) async {
    const path = '/maps/api/place/queryautocomplete/json';
    final url = _getUri(path, {
      'key': apiKey,
      'input': query,
    });
    final result = await http.get(url);
    if (result.statusCode == 200) {
      return LocationSearchAutocompleteResponse.fromJson(json.decode(result.body));
    }

    return null;
  }

  static _getUri(path, Map<String, String> queryParameters) {
    final url = Uri.https(proxyPrefix.isNotEmpty ? proxyPrefix : _baseUrl,
        proxyPrefix.isNotEmpty ? '/proxy/https://$_baseUrl$path' : path, queryParameters);

    log('_getUri resulted url: $url ${url.host}', name: 'GoogleMapsApi');
    return url;
  }
}
