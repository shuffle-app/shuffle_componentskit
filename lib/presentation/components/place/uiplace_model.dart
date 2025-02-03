import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiPlaceModel {
  int id;
  List<BaseUiKitMedia> media;
  BaseUiKitMedia? verticalPreview;
  List<String> weekdays;
  String description;
  List<UiKitTag> tags;
  List<UiKitTag> baseTags;
  double? rating;
  String? title;
  String? source;
  UiKitTag? placeType;
  String? status;
  String? logo;
  List<UiDescriptionItemModel>? descriptionItems;
  String? scheduleString;
  String? location;
  int? cityId;
  String? city;
  String? website;
  String? phone;
  String? price;
  Future<List<HorizontalCaptionedImageData>?>? Function()? branches;
  UiScheduleModel? schedule;
  UiKitTag? niche;
  String? contentType;
  int? userPoints;
  String? currency;
  TextEditingController houseNumberController;
  TextEditingController apartmentNumberController;
  PlaceWeatherType? weatherType;
  String? bookingUrl;
  BookingUiModel? bookingUiModel;
  DateTime? updatedAt;
  String? moderationStatus;
  bool archived;

  UiPlaceModel(
      {required this.id,
      this.title,
      this.scheduleString,
      this.location,
      this.cityId,
      this.city,
      this.media = const [],
      this.verticalPreview,
      this.logo,
      this.phone,
      this.website,
      this.source,
      required this.description,
      this.rating,
      this.status,
      this.price,
      this.placeType,
      this.branches,
      this.updatedAt,
      required this.tags,
      this.baseTags = const [],
      this.weekdays = const [],
      this.schedule,
      this.niche,
      this.contentType = 'both',
      this.userPoints,
      this.currency,
      this.weatherType,
      this.bookingUrl,
      this.bookingUiModel,
      this.moderationStatus,
      this.archived = false})
      : descriptionItems = [
          if (website != null && website.isNotEmpty)
            UiDescriptionItemModel(title: S.current.Website, description: title ?? '', descriptionUrl: website),
          if (phone != null && phone.isNotEmpty) UiDescriptionItemModel(title: S.current.Phone, description: phone),
          UiDescriptionItemModel(title: S.current.Location, description: location ?? ''),
          if (scheduleString != null)
            UiDescriptionItemModel(title: S.current.WorkHours, description: scheduleString, descriptionUrl: 'times'),
        ],
        houseNumberController = TextEditingController(),
        apartmentNumberController = TextEditingController() {
    if (baseTags.isEmpty) {
      baseTags = List.empty(growable: true);
    }
    if (tags.isEmpty) {
      tags = List.empty(growable: true);
    }
  }

  String? validateCreation() {
    if (title == null || title!.isEmpty) {
      return S.current.XIsRequired(S.current.Title);
    } else if (description.isEmpty) {
      return S.current.XIsRequired(S.current.Description);
    } else if (media.isEmpty) {
      return S.current.XIsRequired(S.current.Photos);
    } else if (logo == null || logo!.isEmpty) {
      return S.current.XIsRequired(S.current.Logo);
    } else if (phone == null || phone!.isEmpty) {
      return S.current.XIsRequired(S.current.Phone);
    } else if (location == null || location!.isEmpty) {
      return S.current.XIsRequired(S.current.Location);
    }
    //  else if (baseTags.isEmpty) {
    //   return S.current.XIsRequired(S.current.BaseProperties);
    // }
    else if (tags.isEmpty) {
      return S.current.XIsRequired(S.current.UniqueProperties);
    } else if (website == null || website!.isEmpty) {
      return S.current.XIsRequired(S.current.Website);
    } else if (placeType == null || placeType!.title.isEmpty) {
      return S.current.XIsRequired(S.current.PlaceType);
    } else if (media.isEmpty) {
      return S.current.XIsRequired(S.current.Photos);
    } else if (schedule != null && !schedule!.validateDate) {
      return S.current.APeriodOrPartOfPeriodOfTimeCannotBeInPast;
    }

    return null;
  }

  UiPlaceModel copyWith({
    int? id,
    List<BaseUiKitMedia>? media,
    BaseUiKitMedia? verticalPreview,
    List<String>? weekdays,
    String? description,
    List<UiKitTag>? tags,
    List<UiKitTag>? baseTags,
    double? rating,
    String? title,
    String? source,
    UiKitTag? placeType,
    String? status,
    String? logo,
    List<UiDescriptionItemModel>? descriptionItems,
    String? scheduleString,
    String? location,
    int? cityId,
    String? city,
    String? website,
    String? phone,
    String? price,
    Future<List<HorizontalCaptionedImageData>?>? Function()? branches,
    UiScheduleModel? schedule,
    UiKitTag? niche,
    String? contentType,
    int? userPoints,
    String? currency,
    TextEditingController? houseNumberController,
    TextEditingController? apartmentNumberController,
    PlaceWeatherType? weatherType,
    String? bookingUrl,
    BookingUiModel? bookingUiModel,
    DateTime? updatedAt,
    String? moderationStatus,
  }) =>
      UiPlaceModel(
        id: id ?? this.id,
        media: media ?? this.media,
        verticalPreview: verticalPreview ?? this.verticalPreview,
        weekdays: weekdays ?? this.weekdays,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        baseTags: baseTags ?? this.baseTags,
        rating: rating ?? this.rating,
        title: title ?? this.title,
        source: source ?? this.source,
        placeType: placeType ?? this.placeType,
        status: status ?? this.status,
        logo: logo ?? this.logo,
        scheduleString: scheduleString ?? this.scheduleString,
        location: location ?? this.location,
        cityId: cityId ?? this.cityId,
        city: city ?? this.city,
        website: website ?? this.website,
        phone: phone ?? this.phone,
        price: price ?? this.price,
        branches: branches ?? this.branches,
        schedule: schedule ?? this.schedule,
        niche: niche ?? this.niche,
        contentType: contentType ?? this.contentType,
        userPoints: userPoints ?? this.userPoints,
        weatherType: weatherType ?? this.weatherType,
        bookingUrl: bookingUrl ?? this.bookingUrl,
        bookingUiModel: bookingUiModel ?? this.bookingUiModel,
        currency: currency ?? this.currency,
        updatedAt: updatedAt ?? this.updatedAt,
        moderationStatus: moderationStatus ?? this.moderationStatus,
      );

  UiPlaceModel.empty()
      : id = -1,
        media = const [],
        weekdays = const [],
        description = '',
        contentType = 'both',
        tags = const [],
        houseNumberController = TextEditingController(),
        apartmentNumberController = TextEditingController(),
        bookingUiModel = null,
        archived = false,
        baseTags = const [] {
    if (baseTags.isEmpty) {
      baseTags = List.empty(growable: true);
    }
    if (tags.isEmpty) {
      tags = List.empty(growable: true);
    }
  }

  bool selectableDayPredicate(DateTime day) {
    return schedule?.selectableDayPredicate(day) ?? true;
  }

  @override
  bool operator ==(Object other) {
    return other is UiPlaceModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
