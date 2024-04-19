import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'google_maps_api.dart';

class LocationComponent extends StatefulWidget {
  final VoidCallback onLocationConfirmed;
  final void Function({String address, double latitude, double longitude}) onLocationChanged;
  final ValueChanged<KnownLocation>? onKnownLocationConfirmed;
  final Future<List<KnownLocation>> Function(String? address)? onPlacesCheck;
  final double? initialLatitude;
  final double? initialLongitude;
  final Future<LatLng?> Function()? onDetermineLocation;

  const LocationComponent({
    super.key,
    required this.onLocationChanged,
    required this.onLocationConfirmed,
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

      final placeCoordinates = LatLng(
        placeDetails?.locationDetails?.geometry?.location?.lat ?? 0,
        placeDetails?.locationDetails?.geometry?.location?.lng ?? 0,
      );

      final marker = Marker(
        markerId: const MarkerId('1'),
        position: placeCoordinates,
      );

      final placeFromCoordinates = await GoogleMapsApi.fetchPlaceFromCoordinates(
        latlng: '${placeCoordinates.latitude}, ${placeCoordinates.longitude}',
      );

      await widget.onPlacesCheck
          ?.call(placeFromCoordinates?.results?.firstOrNull?.formattedAddress)
          .then((places) => places.isNotEmpty ? locationDetailsSheetController.updateKnownLocations(places) : null);

      setState(() {
        mapMarkers.clear();
        mapMarkers = {marker};
        _newPlaceTapped = true;
      });

      widget.onLocationChanged.call(
        address: placeFromCoordinates?.results?.firstOrNull?.formattedAddress ?? suggestion.title,
        latitude: placeCoordinates.latitude,
        longitude: placeCoordinates.longitude,
      );

      setState(() => _suggestionPlaces = placeFromCoordinates?.results
              ?.map(
                (place) => KnownLocation(
                  title: place.formattedAddress ?? '',
                  latitude: place.geometry?.location?.lat,
                  longitude: place.geometry?.location?.lon,
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
              ),
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
        onLocationChanged: widget.onLocationChanged,
        newPlace: _newPlaceTapped,
        suggestionPlaces: _suggestionPlaces,
        onNewPlaceTap: (value) => setState(() => _newPlaceTapped = value),
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
        onKnownLocationConfirmed: widget.onKnownLocationConfirmed,
        onCurrentLocationTapped: onCurrentLocationTapped,
        onLocationConfirmed: widget.onLocationConfirmed,
      ),
    );
  }
}
