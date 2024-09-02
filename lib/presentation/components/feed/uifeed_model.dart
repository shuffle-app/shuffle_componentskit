import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiFeedModel {
  final UiEventModel? recommendedEvent;
  final List<UiEventModel>? recommendedBusinessEvents;
  final bool showHowItWorksTitle;
  final bool showHowItWorksBody;
  final bool isHealthKitEnabled;
  final bool shouldRecallOnMoodTap;

  // final List<UiUniversalModel>? mixedItems;
  final List<UiKitTag>? filterChips;
  final List<UiKitTag>? activeFilterChips;
  final List<UiKitTag>? niches;

  // final List<BusinessGlobalEventUiModel>? globalEvents;

  UiFeedModel({
    this.filterChips,
    // this.globalEvents,
    this.activeFilterChips,
    this.showHowItWorksBody = false,
    this.shouldRecallOnMoodTap = false,
    this.isHealthKitEnabled = true,
    this.recommendedEvent,
    this.showHowItWorksTitle = false,
    // this.mixedItems
    this.recommendedBusinessEvents,
    this.niches,
  });
}

class UiUniversalModel extends Advertisable {
  final int id;
  final String type;
  final String? source;
  final double? rating;
  final List<BaseUiKitMedia> media;
  final String description;
  final List<UiKitTag> tags;
  final List<UiKitTag>? baseTags;
  final List<String>? weekdays;
  final String? title;
  final String? website;
  final String? location;
  final Stream<bool>? isFavorite;
  final VoidCallback? onFavoriteChanged;
  final PlaceWeatherType? weatherType;
  DateTime? shouldVisitAt;
  final String? placeName;

  UiUniversalModel({
    required this.id,
    required this.type,
    required this.media,
    required this.description,
    required this.tags,
    this.baseTags,
    this.rating,
    this.website,
    this.weekdays,
    this.location,
    this.source,
    this.title,
    this.isFavorite,
    this.onFavoriteChanged,
    this.shouldVisitAt,
    this.weatherType,
    this.placeName,
  }) : super(isAdvertisement: false);

  UiUniversalModel.advertisement({
    this.id = -1,
    this.type = 'advertisement',
    this.media = const [],
    this.description = '',
    this.tags = const [],
    this.baseTags,
    this.rating,
    this.website,
    this.weekdays,
    this.location,
    this.source,
    this.title,
    this.isFavorite,
    this.onFavoriteChanged,
    this.shouldVisitAt,
    this.weatherType,
    this.placeName,
  }) : super(isAdvertisement: true);

  UiUniversalModel.checkIn({
    required this.id,
    required this.type,
    this.media = const [],
    this.description = '',
    this.tags = const [],
    this.baseTags,
    this.website,
    this.rating,
    this.weekdays,
    this.location,
    this.source,
    this.title,
    this.isFavorite,
    this.onFavoriteChanged,
    this.shouldVisitAt,
    this.weatherType,
    this.placeName,
  }) : super(isAdvertisement: false);

  factory UiUniversalModel.fromPlaceUiModel(UiPlaceModel placeModel) => UiUniversalModel(
      id: placeModel.id,
      type: 'place',
      media: placeModel.media,
      rating: placeModel.rating,
      description: placeModel.description,
      tags: placeModel.tags,
      title: placeModel.title,
      weatherType: placeModel.weatherType);

  factory UiUniversalModel.fromEventUiModel(UiEventModel eventModel) => UiUniversalModel(
      id: eventModel.id,
      placeName: eventModel.owner?.name,
      type: 'event',
      media: eventModel.media,
      description: eventModel.description ?? '',
      tags: eventModel.tags,
      rating: eventModel.rating,
      title: eventModel.title,
      weatherType: eventModel.weatherType);

  factory UiUniversalModel.empty() => UiUniversalModel(
        id: -1,
        type: 'empty',
        media: [],
        description: '',
        tags: [],
      );

  bool get isEventContent => type == 'event';

  bool get isPlaceContent => type == 'place';

  @override
  String toString() {
    return 'UiUniversalModel(id: $id, type: $type, shouldVisitAt: $shouldVisitAt)';
  }

  @override
  bool operator ==(Object other) {
    return other is UiUniversalModel && other.id == id && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}
