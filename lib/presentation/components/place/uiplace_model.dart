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
  final ValueNotifier<List<HorizontalCaptionedImageData>?>? branches;
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
  String? chainName;
  int? chainId;

  UiPlaceModel({
    required this.id,
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
    this.archived = false,
    this.chainName,
    this.chainId,
    String? houseNumber,
    String? apartmentNumber,
  })  : descriptionItems = [
          if (website != null && website.isNotEmpty)
            UiDescriptionItemModel(title: S.current.Website, description: title ?? '', descriptionUrl: website),
          if (phone != null && phone.isNotEmpty) UiDescriptionItemModel(title: S.current.Phone, description: phone),
          UiDescriptionItemModel(title: S.current.Location, description: location ?? ''),
          if (scheduleString != null)
            UiDescriptionItemModel(title: S.current.WorkHours, description: scheduleString, descriptionUrl: 'times'),
        ],
        houseNumberController = TextEditingController(text: houseNumber),
        apartmentNumberController = TextEditingController(text: apartmentNumber) {
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
    final ValueNotifier<List<HorizontalCaptionedImageData>?>? branches,
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
    String? chainName,
    int? chainId,
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
        chainName: chainName ?? this.chainName,
        chainId: chainId ?? this.chainId,
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
        branches = null,
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

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'tags': tags.map((tag) => tag.toMap()).toList(),
        'baseTags': baseTags.map((tag) => tag.toMap()).toList(),
        'logo': logo,
        'website': website,
        // 'location': location,
        'phone': phone,
        'price': price,
        'placeType': placeType?.toMap(),
        'weekdays': weekdays,
        // 'descriptionItems': descriptionItems?.map((item) => item.toMap())?.toList(),
        'cityId': cityId,
        'city': city,
        'houseNumber': houseNumberController.text,
        'apartmentNumber': apartmentNumberController.text,
        'weatherType': weatherType?.toString(),
        'bookingUrl': bookingUrl,
        // 'bookingUiModel': bookingUiModel?.toMap(),
        'updatedAt': updatedAt?.millisecondsSinceEpoch,
        'moderationStatus': moderationStatus,
        'chainName': chainName,
        'chainId': chainId,
        'archived': archived,
        'currency': currency,
        'userPoints': userPoints,
        'scheduleString': scheduleString,
        'scheduleType': schedule.runtimeType.toString(),
        'schedule': schedule?.encodeSchedule(),
        'niche': niche?.id,
        'contentType': contentType,
        // 'branches': branches?.map((branch) => branch.toMap())?.toList(),
        'media': media.map((media) => media.toMap()).toList(),
      }..removeWhere((k, v) => v == null);

  static UiPlaceModel fromMap(Map<String, dynamic> map) => UiPlaceModel(
        id: map['id'] as int? ?? -1,
        title: map['title'] as String,
        description: map['description'] as String? ?? '',
        tags: (map['tags'] as List?)?.map((item) => UiKitTag.fromMap(item)).toList() ?? const [],
        baseTags: (map['baseTags'] as List?)?.map((item) => UiKitTag.fromMap(item)).toList() ?? const [],
        logo: map['logo'] as String?,
        website: map['website'] as String?,
        // location: map['location'] as String,
        phone: map['phone'] as String?,
        price: map['price'] as String?,
        placeType: map['placeType'] != null ? UiKitTag.fromMap(map['placeType']) : null,
        weekdays: map['weekdays'] as List<String>,
        // descriptionItems: (map['descriptionItems'] as List?)?.map((item) => UiDescriptionItemModel.fromMap(item))?.toList(),
        cityId: map['cityId'] as int?,
        city: map['city'] as String?,
        houseNumber: map['houseNumber'] as String?,
        apartmentNumber: map['apartmentNumber'] as String?,
        weatherType: map['weatherType'] as PlaceWeatherType?,
        bookingUrl: map['bookingUrl'] as String?,
        // bookingUiModel: map['bookingUiModel']!= null? BookingUiModel.fromMap(map['bookingUiModel']) : null,
        // updatedAt: map['updatedAt']?.toDateTimeFromMillisecondsSinceEpoch(),
        moderationStatus: map['moderationStatus'] as String?,
        chainName: map['chainName'] as String?,
        chainId: map['chainId'] as int?,
        archived: map['archived'] as bool? ?? false,
        currency: map['currency'] as String?,
        userPoints: map['userPoints'] as int?,
        scheduleString: map['scheduleString'] as String?,
        schedule: map['schedule'] != null && map['scheduleType'] != null
            ? UiScheduleModel.fromCachedString(map['scheduleType'], map['schedule'])
            : null,
        niche: map['niche'] != null ? UiKitTag.fromMap(map['niche']) : null,
        contentType: map['contentType'] as String?,
        // branches: map['branches']!= null? List.from(map['branches'].map((item) => HorizontalCaptionedImageData.fromMap(item))) : null,
        media: map['media'] != null ? List.from(map['media'].map((item) => BaseUiKitMedia.fromMap(item))) : const [],
        // branches: map['branches']!= null? ValueNotifier<List<HorizontalCaptionedImageData>?>.value(List.from(map['branches'].map((item) => HorizontalCaptionedImageData.fromMap(item)))) : null,
      );
}
