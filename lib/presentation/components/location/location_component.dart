import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'google_maps_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationComponent extends StatefulWidget {
  final VoidCallback onLocationConfirmed;
  final void Function({String address, double latitude, double longitude}) onLocationChanged;
  final ValueChanged<KnownLocation>? onKnownLocationConfirmed;
  final VoidCallback? onNewPlaceTap;
  final Future<List<KnownLocation>?> Function(LatLng coordinates)? onPlacesCheck;
  final CameraPosition? initialPosition;
  final void Function(String placeName)? onConfirmPlaceTap;
  final Future<LatLng?> Function()? onDetermineLocation;

  const LocationComponent({
    super.key,
    required this.onLocationChanged,
    required this.onLocationConfirmed,
    this.onPlacesCheck,
    this.onNewPlaceTap,
    this.initialPosition,
    this.onConfirmPlaceTap,
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
  Set<Marker> mapMarkers = {};
  List<KnownLocation>? _suggestionPlaces = [];
  bool _newPlaceTapped = true;
  final LocationPickerSearchOverlayController locationPickerSearchOverlayController =
      LocationPickerSearchOverlayController();
  Timer? _debounceTimer;
  final LocationDetailsSheetController locationDetailsSheetController = LocationDetailsSheetController();

  @override
  void initState() {
    super.initState();
    cameraPosition = widget.initialPosition ??
        const CameraPosition(
          target: LatLng(25.276987, 55.296249),
          zoom: 14.4746,
        );
    searchTextController.addListener(_onSearchListener);
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

      widget.onLocationChanged.call(
        address: suggestion.title,
        latitude: placeDetails?.locationDetails?.geometry?.location?.lat ?? 0,
        longitude: placeDetails?.locationDetails?.geometry?.location?.lng ?? 0,
      );

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

      final marker = Marker(
        markerId: const MarkerId('1'),
        position: LatLng(
          placeDetails?.locationDetails?.geometry?.location?.lat ?? 0,
          placeDetails?.locationDetails?.geometry?.location?.lng ?? 0,
        ),
      );

      final placeCoordinates = LatLng(
        placeDetails?.locationDetails?.geometry?.location?.lat ?? 0,
        placeDetails?.locationDetails?.geometry?.location?.lng ?? 0,
      );

      await widget.onPlacesCheck?.call(placeCoordinates);

      final placeFromCoordinates = await GoogleMapsApi.fetchPlaceFromCoordinates(
        latlng: '${placeCoordinates.latitude}, ${placeCoordinates.longitude}',
      );

      setState(() {
        mapMarkers.clear();
        mapMarkers = {marker};
        _newPlaceTapped = true;
      });

      locationDetailsSheetController.updateKnownLocations(
        placeFromCoordinates?.results
                ?.map(
                  (place) => KnownLocation(title: place.formattedAddress ?? ''),
                )
                .toList() ??
            [],
      );
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
      await mapsController.animateCamera(CameraUpdate.newLatLng(newLocation));
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
    debugPrint('decodeCoordinates resulted with: ${placeFromCoordinates?.results?.map((e) => e.formattedAddress)}');
    final place = placeFromCoordinates?.results?.first;
    locationDetailsSheetController.updateKnownLocations(
      placeFromCoordinates?.results
              ?.map(
                (place) => KnownLocation(title: place.formattedAddress ?? ''),
              )
              .toList() ??
          [],
    );
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
    );
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
    widget.onPlacesCheck?.call(coordinates).then((places) => setState(() {
          _newPlaceTapped = true;
          _suggestionPlaces = places;
        }));
  }

  void onKnownLocationConfirmed(KnownLocation location) {
    log('KnownLocation is $location', name: 'LocationComponent');
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
        newPlace: _newPlaceTapped,
        suggestionPlaces: _suggestionPlaces,
        onNewPlaceTap: (value) {
          widget.onNewPlaceTap?.call();
          setState(() => _newPlaceTapped = value);
        },
        onConfirmPlaceTap: widget.onConfirmPlaceTap,
        onMapCreated: (controller) {
          setState(() => mapsController = controller);
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
        onKnownLocationConfirmed: (location) {
          onKnownLocationConfirmed(location);
          widget.onKnownLocationConfirmed?.call(location);
        },
        onCurrentLocationTapped: onCurrentLocationTapped,
        onLocationConfirmed: widget.onLocationConfirmed,
      ),
    );
  }
}
