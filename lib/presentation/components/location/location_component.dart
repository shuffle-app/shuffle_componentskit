import 'dart:async';
import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huawei_map/huawei_map.dart' as hms;
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'google_maps_api.dart';

class LocationComponent extends StatefulWidget {
  final VoidCallback onLocationConfirmed;
  final void Function(
      {String address,
      double latitude,
      double longitude,
      String? cityName,
      String? countryName,
      String? countryCode}) onLocationChanged;
  final ValueChanged<KnownLocation>? onKnownLocationConfirmed;
  final Future<List<KnownLocation>> Function(String? address)? onPlacesCheck;
  final double? initialLatitude;
  final double? initialLongitude;
  final Future<LatLng?> Function()? onDetermineLocation;
  final bool isHuawei;

  const LocationComponent({
    super.key,
    required this.onLocationChanged,
    required this.onLocationConfirmed,
    required this.isHuawei,
    this.onPlacesCheck,
    this.initialLatitude,
    this.initialLongitude,
    this.onDetermineLocation,
    this.onKnownLocationConfirmed,
  });

  @override
  State<LocationComponent> createState() => _LocationComponentState();
}

class _LocationComponentState extends State<LocationComponent> {
  late CameraPosition cameraPosition;
  final TextEditingController searchTextController = TextEditingController();
  final List<LocationSuggestion> locationSuggestions = [];
  late final GoogleMapController mapsController;
  late final hms.HuaweiMapController huaweiController;
  Set<Marker> mapMarkers = {};
  List<KnownLocation>? _suggestionPlaces = [];
  bool _newPlaceTapped = true;
  final LocationPickerSearchOverlayController locationPickerSearchOverlayController =
      LocationPickerSearchOverlayController();
  Timer? _debounceTimer;
  final LocationDetailsSheetController locationDetailsSheetController = LocationDetailsSheetController();

  @override
  void initState() {
    if (widget.isHuawei) {
      hms.HuaweiMapInitializer.initializeMap();
    }
    super.initState();
    cameraPosition = CameraPosition(
      target: LatLng(widget.initialLatitude ?? 25.276987, widget.initialLongitude ?? 55.296249),
      zoom: 14.4746,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      mapMarkers = {
        Marker(
          markerId: const MarkerId('1'),
          position: LatLng(widget.initialLatitude ?? 25.276987, widget.initialLongitude ?? 55.296249),
        ),
      };
      searchTextController.addListener(_onSearchListener);
      setState(() {});
    });
  }

  _onSearchListener() {
    final canRequestSuggestions = locationPickerSearchOverlayController.selectedSuggestion == null ||
        locationPickerSearchOverlayController.currentState != LocationPickerOverlayState.hidden;
    log('searchTextController.addListener is triggered', name: 'LocationComponent');
    final text = searchTextController.value.text;
    if (text.length >= 3 && canRequestSuggestions) {
      onDebounceTriggered(query: text);
    }
  }

  Future<void> onDebounceTriggered({required String query}) async {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      locationPickerSearchOverlayController.updateState(LocationPickerOverlayState.loading);
      final result = await GoogleMapsApi.completeQuery(query: query);
      if (result?.predictions?.isEmpty ?? false) {
        locationPickerSearchOverlayController.updateState(LocationPickerOverlayState.noSuggestions);
      } else {
        locationPickerSearchOverlayController.updateSuggestions(
          result?.predictions
                  ?.map<LocationSuggestion>(
                    (element) => LocationSuggestion(
                      title: element.structuredFormatting?.mainText ?? '',
                      subtitle: element.description ?? '',
                      placeId: element.placeId ?? '',
                    ),
                  )
                  .toList(growable: true) ??
              [],
        );
      }
      locationPickerSearchOverlayController.updateState(LocationPickerOverlayState.loaded);
    });
  }

  Future<void> suggestionSelected(LocationSuggestion? suggestion) async {
    log('suggestion chosen: ${suggestion?.title}', name: 'LocationComponent');
    locationPickerSearchOverlayController.updateSelectedSuggestion(suggestion);
    locationPickerSearchOverlayController.updateState(LocationPickerOverlayState.hidden);
    if (suggestion != null) {
      searchTextController.text = suggestion.title;
      final placeId = suggestion.placeId;

      final placeDetails = await GoogleMapsApi.fetchPlaceDetails(placeId: placeId);
      if (widget.isHuawei) {
        await huaweiController.animateCamera(
          hms.CameraUpdate.newLatLngBounds(
            hms.LatLngBounds(
              northeast: hms.LatLng(
                placeDetails?.locationDetails?.geometry?.viewport?.northeast?.lat ?? 0,
                placeDetails?.locationDetails?.geometry?.viewport?.northeast?.lng ?? 0,
              ),
              southwest: hms.LatLng(
                placeDetails?.locationDetails?.geometry?.viewport?.southwest?.lat ?? 0,
                placeDetails?.locationDetails?.geometry?.viewport?.southwest?.lng ?? 0,
              ),
            ),
            0,
          ),
        );
      } else {
        await mapsController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                placeDetails?.locationDetails?.geometry?.viewport?.northeast?.lat ?? 0,
                placeDetails?.locationDetails?.geometry?.viewport?.northeast?.lng ?? 0,
              ),
              southwest: LatLng(
                placeDetails?.locationDetails?.geometry?.viewport?.southwest?.lat ?? 0,
                placeDetails?.locationDetails?.geometry?.viewport?.southwest?.lng ?? 0,
              ),
            ),
            0,
          ),
        );
      }

      final placeCoordinates = LatLng(
        placeDetails?.locationDetails?.geometry?.location?.lat ?? 0,
        placeDetails?.locationDetails?.geometry?.location?.lng ?? 0,
      );

      final marker = Marker(
        markerId: const MarkerId('1'),
        position: placeCoordinates,
      );

      setState(() {
        mapMarkers.clear();
        mapMarkers = {marker};
        _newPlaceTapped = true;
      });

      final placeFromCoordinates = await GoogleMapsApi.fetchPlaceFromCoordinates(
        latlng: '${placeCoordinates.latitude}, ${placeCoordinates.longitude}',
      );

      await widget.onPlacesCheck
          ?.call(placeFromCoordinates?.results?.firstOrNull?.formattedAddress)
          .then((places) => places.isNotEmpty ? locationDetailsSheetController.updateKnownLocations(places) : null);

      final place = placeFromCoordinates?.results?.firstOrNull;

      widget.onLocationChanged.call(
          address: placeFromCoordinates?.results?.firstOrNull?.formattedAddress ?? suggestion.title,
          latitude: placeCoordinates.latitude,
          longitude: placeCoordinates.longitude,
          cityName: place?.addressComponents
              ?.firstWhereOrNull((element) =>
                  element.types!.contains(cityGoogleType) || element.types!.contains(cityAdditionalGoogleType))
              ?.longName,
          countryName: place?.addressComponents
              ?.firstWhereOrNull((element) => element.types!.contains(countryGoogleType))
              ?.longName,
          countryCode: place?.addressComponents
              ?.firstWhereOrNull((element) => element.types!.contains(countryGoogleType))
              ?.shortName);

      setState(() => _suggestionPlaces = placeFromCoordinates?.results
              ?.map(
                (place) => KnownLocation(
                  title: place.formattedAddress ?? '',
                  latitude: place.geometry?.location?.lat,
                  longitude: place.geometry?.location?.lon,
                  cityName: place.addressComponents
                      ?.firstWhereOrNull((element) =>
                          element.types!.contains(cityGoogleType) || element.types!.contains(cityAdditionalGoogleType))
                      ?.longName,
                  countryName: place.addressComponents
                      ?.firstWhereOrNull((element) => element.types!.contains(countryGoogleType))
                      ?.longName,
                  countryCode: place.addressComponents
                      ?.firstWhereOrNull((element) => element.types!.contains(countryGoogleType))
                      ?.shortName,
                ),
              )
              .toList() ??
          []);
    }
  }

  void onPickFromMap() {
    locationPickerSearchOverlayController.updateState(LocationPickerOverlayState.hidden);
    locationDetailsSheetController.updateSheetState(LocationDetailsSheetState.visible);
  }

  void onSearchTapped() {
    suggestionSelected(null);
    locationPickerSearchOverlayController.updateState(LocationPickerOverlayState.noSuggestions);
    locationDetailsSheetController.updateSheetState(LocationDetailsSheetState.hidden);
  }

  Future<void> onCurrentLocationTapped() async {
    final newLocation = await widget.onDetermineLocation?.call();
    if (newLocation != null) {
      if (widget.isHuawei) {
        await huaweiController.animateCamera(
          hms.CameraUpdate.newLatLng(hms.LatLng(newLocation.latitude, newLocation.longitude)),
        );
      } else {
        await mapsController.animateCamera(CameraUpdate.newLatLng(newLocation));
      }
    }
  }

  void onSearchInputCleaned() {
    searchTextController.clear();
  }

  void _setStatusBarBrightness(Brightness brightness) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: brightness,
        statusBarIconBrightness: brightness,
        systemNavigationBarIconBrightness: brightness,
      ),
    );
  }

  void onCameraMoved(CameraPosition position) {
    setState(() {
      cameraPosition = position;
    });
  }

  Future<void> decodeCoordinates(LatLng latLng) async {
    final placeFromCoordinates = await GoogleMapsApi.fetchPlaceFromCoordinates(
      latlng: '${latLng.latitude}, ${latLng.longitude}',
    );
    if (placeFromCoordinates?.results?.isEmpty ?? true) {
      return;
    }
    final place = placeFromCoordinates?.results?.first;
    await widget.onPlacesCheck
        ?.call(placeFromCoordinates!.results!.first.formattedAddress)
        .then((places) => places.isNotEmpty ? locationDetailsSheetController.updateKnownLocations(places) : null);

    setState(() => _suggestionPlaces = placeFromCoordinates?.results
            ?.map(
              (place) => KnownLocation(
                  title: place.formattedAddress ?? '',
                  latitude: place.geometry?.location?.lat,
                  longitude: place.geometry?.location?.lon,
                  cityName: place.addressComponents
                      ?.firstWhereOrNull((element) =>
                          element.types!.contains(cityGoogleType) || element.types!.contains(cityAdditionalGoogleType))
                      ?.longName,
                  countryName: place.addressComponents
                      ?.firstWhereOrNull((element) => element.types!.contains(countryGoogleType))
                      ?.longName,
                  countryCode: place.addressComponents
                      ?.firstWhereOrNull((element) => element.types!.contains(countryGoogleType))
                      ?.shortName),
            )
            .toList() ??
        []);

    final newSuggestion = LocationSuggestion(
      title: place?.formattedAddress ?? '',
      subtitle: place?.formattedAddress ?? '',
      placeId: place?.placeId ?? '',
    );
    locationPickerSearchOverlayController.updateSelectedSuggestion(newSuggestion);
    locationDetailsSheetController.updateSheetState(LocationDetailsSheetState.placeSelected);
    searchTextController.text = place?.formattedAddress ?? '';
    widget.onLocationChanged.call(
        address: place?.formattedAddress ?? '',
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        cityName: place?.addressComponents
            ?.firstWhereOrNull((element) =>
                element.types!.contains(cityGoogleType) || element.types!.contains(cityAdditionalGoogleType))
            ?.longName,
        countryName: place?.addressComponents
            ?.firstWhereOrNull((element) => element.types!.contains(countryGoogleType))
            ?.longName,
        countryCode: place?.addressComponents
            ?.firstWhereOrNull((element) => element.types!.contains(countryGoogleType))
            ?.shortName);
  }

  void onMapTapped(LatLng coordinates) {
    final marker = Marker(
      markerId: const MarkerId('1'),
      position: coordinates,
    );
    setState(() {
      mapMarkers.clear();
      mapMarkers = {marker};
    });
    decodeCoordinates(coordinates);
  }

  @override
  void dispose() {
    searchTextController.removeListener(_onSearchListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: UiKitThemeFoundation.defaultTheme,
      child: UiKitLocationPicker(
        isHuawei: widget.isHuawei,
        onLocationChanged: widget.onLocationChanged,
        newPlace: _newPlaceTapped,
        suggestionPlaces: _suggestionPlaces,
        onNewPlaceTap: (value) => setState(() => _newPlaceTapped = value),
        onMapCreated: (controller) {
          if (widget.isHuawei) {
            setState(() {
              huaweiController = controller;
            });
          } else {
            setState(() => mapsController = controller);
          }
        },
        initialCameraPosition: cameraPosition,
        onCameraMoved: onCameraMoved,
        onMapTapped: onMapTapped,
        markers: mapMarkers,
        onSuggestionChosen: (suggestion) {
          suggestionSelected(suggestion);
          _setStatusBarBrightness(Brightness.dark);
        },
        onSearchInputCleaned: onSearchInputCleaned,
        onPickFromMap: () {
          _setStatusBarBrightness(Brightness.dark);
          onPickFromMap();
        },
        onSearchTapped: () {
          _setStatusBarBrightness(Brightness.light);
          onSearchTapped();
        },
        searchController: searchTextController,
        locationPickerSearchOverlayController: locationPickerSearchOverlayController,
        locationDetailsSheetController: locationDetailsSheetController,
        onKnownLocationConfirmed: widget.onKnownLocationConfirmed,
        onCurrentLocationTapped: onCurrentLocationTapped,
        onLocationConfirmed: widget.onLocationConfirmed,
      ),
    );
  }

  static const String cityGoogleType = 'locality';
  static const String cityAdditionalGoogleType = 'administrative_area_level_1';
  static const String countryGoogleType = 'country';
}
