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
  // DateTime? date;
  // DateTime? dateTo;
  // TimeOfDay? time;
  // TimeOfDay? timeTo;
  String? description;
  String? location;
  String? eventType;
  String? price;
  String? website;
  String? phone;
  List<UiKitTag> tags;
  List<UiKitTag> baseTags;
  double? rating;
  bool archived;
  List<String> weekdays;
  List<UiDescriptionItemModel>? descriptionItems;

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
    this.website,
    this.scheduleString,
    this.weekdays = const [],
    this.isRecurrent = false,
    this.archived = false,
    bool? isAdvertisement,
  })  : descriptionItems = [
          if (scheduleString != null)
          // if (formatDate(date, dateTo, time, timeTo, weekdays) != null)
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
            UiDescriptionItemModel(
              title: S.current.Website,
              description: title ?? '',
              descriptionUrl: website
            ),
        ],
        super(isAdvertisement: isAdvertisement ?? false);

  UiEventModel.advertisement({
    this.id = -1,
    this.title,
    this.favorite,
    this.owner,
    this.scheduleString,
    this.media = const [],
    this.description,
    this.location,
    this.tags = const [],
    this.baseTags = const [],
    this.rating,
    this.weekdays = const [],
    this.isRecurrent = false,
    this.archived = false,
    this.descriptionItems = const [],
  }) : super(isAdvertisement: true);

  String? validateCreation() {
    if (title == null || title!.isEmpty) {
      return S.current.XIsRequired(S.current.Title);
    } else if (description == null || description!.isEmpty) {
      return S.current.XIsRequired(S.current.Description);
    } else if (media.isEmpty) {
      return S.current.XIsRequired(S.current.Photos);
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
        price = null,
        website = null,
        phone = null,
        tags = const [],
        baseTags = const [],
        rating = null,
        archived = false,
        weekdays = const [],
        descriptionItems = const [],
        super(isAdvertisement: false);
}
