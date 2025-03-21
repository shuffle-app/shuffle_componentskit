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
  final bool? loadingFilterChips;

  // final List<BusinessGlobalEventUiModel>? globalEvents;

  const UiFeedModel(
      {this.filterChips,
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
      this.loadingFilterChips});
}

class UiUniversalModel extends Advertisable {
  final int id;
  final int? cityId;
  final int? schedulerId;
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
  DateTime? remaindAt;
  final String? placeName;
  final bool isArchieved;
  final bool hasNotificationSet;
  final UiScheduleModel? schedule;

  UiUniversalModel({
    required this.id,
    required this.type,
    required this.media,
    required this.description,
    required this.tags,
    this.baseTags,
    this.rating,
    this.cityId,
    this.website,
    this.weekdays,
    this.remaindAt,
    this.location,
    this.source,
    this.title,
    this.isFavorite,
    this.onFavoriteChanged,
    this.shouldVisitAt,
    this.weatherType,
    this.schedulerId,
    this.placeName,
    this.isArchieved = false,
    this.hasNotificationSet = false,
    this.schedule,
  }) : super(isAdvertisement: false);

  UiUniversalModel.advertisement({
    this.id = -1,
    this.type = 'advertisement',
    this.media = const [],
    this.description = '',
    this.tags = const [],
    this.baseTags,
    this.rating,
    this.cityId,
    this.schedulerId,
    this.website,
    this.weekdays,
    this.location,
    this.remaindAt,
    this.source,
    this.title,
    this.isFavorite,
    this.onFavoriteChanged,
    this.shouldVisitAt,
    this.weatherType,
    this.placeName,
    this.hasNotificationSet = false,
    this.isArchieved = false,
    this.schedule,
  }) : super(isAdvertisement: true);

  UiUniversalModel.checkIn({
    required this.id,
    required this.type,
    this.media = const [],
    this.description = '',
    this.tags = const [],
    this.baseTags,
    this.website,
    this.cityId,
    this.schedulerId,
    this.rating,
    this.weekdays,
    this.remaindAt,
    this.location,
    this.source,
    this.title,
    this.isFavorite,
    this.onFavoriteChanged,
    this.shouldVisitAt,
    this.weatherType,
    this.placeName,
    this.isArchieved = false,
    this.hasNotificationSet = false,
    this.schedule,
  }) : super(isAdvertisement: false);

  factory UiUniversalModel.fromPlaceUiModel(UiPlaceModel placeModel) => UiUniversalModel(
      id: placeModel.id,
      cityId: placeModel.cityId,
      type: 'place',
      media: placeModel.media,
      rating: placeModel.rating,
      description: placeModel.description,
      tags: placeModel.tags,
      location: placeModel.location,
      baseTags: placeModel.baseTags,
      title: placeModel.title,
      isArchieved: placeModel.archived,
      weatherType: placeModel.weatherType,
      schedule: placeModel.schedule);

  factory UiUniversalModel.fromEventUiModel(UiEventModel eventModel) => UiUniversalModel(
      id: eventModel.id,
      cityId: eventModel.cityId,
      placeName: eventModel.owner?.name,
      type: 'event',
      media: eventModel.media,
      description: eventModel.description ?? '',
      tags: eventModel.tags,
      rating: eventModel.rating,
      title: eventModel.title,
      isArchieved: eventModel.archived,
      baseTags: eventModel.baseTags,
      location: eventModel.location,
      weatherType: eventModel.weatherType,
      schedule: eventModel.schedule);

  factory UiUniversalModel.empty() => UiUniversalModel(
        id: -1,
        type: 'empty',
        media: [],
        description: '',
        tags: [],
      );

  bool get isEventContent => type == 'event';

  bool get isNotArchieved => !isArchieved;

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

  UiUniversalModel copyWith({
    int? id,
    String? type,
    List<BaseUiKitMedia>? media,
    String? description,
    List<UiKitTag>? tags,
    List<UiKitTag>? baseTags,
    double? rating,
    String? website,
    List<String>? weekdays,
    String? location,
    String? source,
    String? title,
    Stream<bool>? isFavorite,
    VoidCallback? onFavoriteChanged,
    DateTime? shouldVisitAt,
    DateTime? remaindAt,
    PlaceWeatherType? weatherType,
    String? placeName,
    bool? isArchieved,
    bool? hasNotificationSet,
    int? cityId,
    int? schedulerId,
  }) =>
      UiUniversalModel(
        id: id ?? this.id,
        type: type ?? this.type,
        media: media ?? this.media,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        baseTags: baseTags ?? this.baseTags,
        rating: rating ?? this.rating,
        website: website ?? this.website,
        weekdays: weekdays ?? this.weekdays,
        location: location ?? this.location,
        source: source ?? this.source,
        title: title ?? this.title,
        isFavorite: isFavorite ?? this.isFavorite,
        onFavoriteChanged: onFavoriteChanged ?? this.onFavoriteChanged,
        shouldVisitAt: shouldVisitAt ?? this.shouldVisitAt,
        weatherType: weatherType ?? this.weatherType,
        placeName: placeName ?? this.placeName,
        isArchieved: isArchieved ?? this.isArchieved,
        hasNotificationSet: hasNotificationSet ?? this.hasNotificationSet,
        cityId: cityId ?? this.cityId,
        schedulerId: schedulerId ?? this.schedulerId,
        remaindAt: remaindAt ?? this.remaindAt,
      );
}
