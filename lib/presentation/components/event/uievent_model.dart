import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiEventModel extends Advertisable {
  final int id;
  String? title;
  UiOwnerModel? owner;
  List<BaseUiKitMedia> media;
  BaseUiKitMedia? verticalPreview;
  bool? favorite;
  bool isRecurrent;
  String? scheduleString;
  String? contentType;
  String? currency;
  DateTime? startDate;
  DateTime? endDate;
  dynamic schedule;
  String? description;
  String? location;
  UiKitTag? eventType;
  String? price;
  String? website;
  String? phone;
  UiKitTag? niche;
  String? reviewStatus;
  List<UiKitTag> tags;
  List<UiKitTag> baseTags;
  double? rating;
  bool archived;
  List<String> weekdays;
  List<UiDescriptionItemModel>? descriptionItems;
  TextEditingController houseNumberController;
  TextEditingController apartmentNumberController;
  PlaceWeatherType? weatherType;
  List<FeedbackUiModel>? reviews;
  List<VideoReactionUiModel>? reactions;
  List<String>? upsalesItems;
  String? bookingUrl;
  BookingUiModel? bookingUiModel;

  UiEventModel({
    required this.id,
    this.title,
    this.favorite,
    this.owner,
    this.eventType,
    this.media = const [],
    this.description,
    this.location,
    this.verticalPreview,
    this.tags = const [],
    this.baseTags = const [],
    this.rating,
    this.price,
    this.phone,
    this.reviewStatus,
    this.contentType,
    this.website,
    this.scheduleString,
    this.weekdays = const [],
    this.isRecurrent = false,
    this.archived = false,
    this.startDate,
    this.endDate,
    this.niche,
    this.currency,
    this.schedule,
    this.weatherType,
    this.reviews,
    this.reactions,
    this.upsalesItems,
    bool? isAdvertisement,
    this.bookingUrl,
    this.bookingUiModel,
  })  : descriptionItems = [
          if (scheduleString != null)
            UiDescriptionItemModel(
              title: S.current.DontMissIt,
              description: scheduleString,
            ),
          if (location != null && location.isNotEmpty)
            UiDescriptionItemModel(
              title: S.current.Place,
              description: location,
            ),
          if (phone != null && phone.isNotEmpty)
            UiDescriptionItemModel(
              title: S.current.Phone,
              description: phone,
            ),
          if (website != null && website.isNotEmpty)
            UiDescriptionItemModel(title: S.current.Website, description: title ?? '', descriptionUrl: website),
        ],
        houseNumberController = TextEditingController(),
        apartmentNumberController = TextEditingController(),
        super(isAdvertisement: isAdvertisement ?? false) {
    if (baseTags.isEmpty) {
      baseTags = List.empty(growable: true);
    }
    if (tags.isEmpty) {
      tags = List.empty(growable: true);
    }
  }

  UiEventModel.advertisement({
    this.id = -1,
    this.title,
    this.favorite,
    this.owner,
    this.startDate,
    this.reviewStatus,
    this.contentType,
    this.scheduleString,
    this.media = const [],
    this.description,
    this.location,
    this.niche,
    this.tags = const [],
    this.baseTags = const [],
    this.rating,
    this.weekdays = const [],
    this.isRecurrent = false,
    this.archived = false,
    this.descriptionItems = const [],
  })  : houseNumberController = TextEditingController(),
        apartmentNumberController = TextEditingController(),
        super(isAdvertisement: true);

  String? validateCreation() {
    if (title == null || title!.isEmpty) {
      return S.current.XIsRequired(S.current.Title);
    } else if (description == null || description!.isEmpty) {
      return S.current.XIsRequired(S.current.Description);
    } else if (media.isEmpty) {
      return S.current.XIsRequired(S.current.Photos);
    } else if (phone == null || phone!.isEmpty) {
      return S.current.XIsRequired(S.current.Phone);
    } else if (website == null || website!.isEmpty) {
      return S.current.XIsRequired(S.current.Website);
    } else if (eventType == null || eventType!.title.isEmpty) {
      return S.current.XIsRequired(S.current.EventType);
    } else if (scheduleString == null || scheduleString!.isEmpty) {
      return S.current.XIsRequired(S.current.Dates);
    } else if (upsalesValidator(upsalesItems?.join(',')) != null) {
      return S.current.XIsRequired(S.current.Upsales);
    }

    return null;
  }

  UiEventModel.empty()
      : id = -1,
        title = null,
        owner = null,
        media = const [],
        favorite = false,
        isRecurrent = false,
        scheduleString = null,
        description = null,
        location = null,
        eventType = null,
        reviewStatus = null,
        price = null,
        schedule = null,
        website = null,
        phone = null,
        niche = null,
        tags = const [],
        baseTags = const [],
        rating = null,
        archived = false,
        weekdays = const [],
        descriptionItems = const [],
        houseNumberController = TextEditingController(),
        apartmentNumberController = TextEditingController(),
        upsalesItems = const [],
        bookingUrl = null,
        bookingUiModel = null,
        super(isAdvertisement: false) {
    if (baseTags.isEmpty) {
      baseTags = List.empty(growable: true);
    }
    if (tags.isEmpty) {
      tags = List.empty(growable: true);
    }
  }

  // copy with method

  UiEventModel copyWith({
    String? title,
    UiOwnerModel? owner,
    List<BaseUiKitMedia>? media,
    BaseUiKitMedia? verticalPreview,
    bool? favorite,
    bool? isRecurrent,
    String? scheduleString,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    String? location,
    UiKitTag? eventType,
    String? price,
    String? website,
    UiKitTag? niche,
    String? phone,
    List<UiKitTag>? tags,
    List<UiKitTag>? baseTags,
    double? rating,
    bool? archived,
    List<String>? weekdays,
    String? currency,
    String? reviewStatus,
    PlaceWeatherType? weatherType,
    List<String>? upsalesItems,
    dynamic schedule,
    List<FeedbackUiModel>? reviews,
    List<VideoReactionUiModel>? reactions,
    String? bookingUrl,
    BookingUiModel? bookingUiModel,
  }) =>
      UiEventModel(
        id: id,
        title: title ?? this.title,
        owner: owner ?? this.owner,
        media: media ?? this.media,
        verticalPreview: verticalPreview ?? this.verticalPreview,
        favorite: favorite ?? this.favorite,
        isRecurrent: isRecurrent ?? this.isRecurrent,
        scheduleString: scheduleString ?? this.scheduleString,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        description: description ?? this.description,
        location: location ?? this.location,
        eventType: eventType ?? this.eventType,
        price: price ?? this.price,
        website: website ?? this.website,
        phone: phone ?? this.phone,
        tags: tags ?? this.tags,
        niche: niche ?? this.niche,
        baseTags: baseTags ?? this.baseTags,
        rating: rating ?? this.rating,
        archived: archived ?? this.archived,
        weekdays: weekdays ?? this.weekdays,
        currency: currency ?? this.currency,
        schedule: schedule ?? this.schedule,
        reviewStatus: reviewStatus ?? this.reviewStatus,
        weatherType: weatherType ?? this.weatherType,
        reviews: reviews ?? this.reviews,
        reactions: reactions ?? this.reactions,
        upsalesItems: upsalesItems ?? this.upsalesItems,
        bookingUrl: bookingUrl ?? this.bookingUrl,
        bookingUiModel: bookingUiModel ?? this.bookingUiModel,
      );

  bool selectableDayPredicate(DateTime day) {
    if (startDate == null) return true;
    if (endDate == null || startDate?.day == endDate?.day) {
      return startDate?.day == day.day;
    }
    return day.isAfter(startDate!) && day.isBefore(endDate!);
  }

  Map<int, int>? get feedbacksHelpfulCounts =>
      <int, int>{}..addEntries(reviews?.map((e) => MapEntry<int, int>(e.id, e.helpfulCount ?? 0)) ?? []);
}
