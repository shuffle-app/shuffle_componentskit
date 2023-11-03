import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiPlaceModel {
  int id;
  List<BaseUiKitMedia> media;
  List<String> weekdays;
  String description;
  List<UiKitTag> tags;
  List<UiKitTag> baseTags;
  double? rating;
  String? title;
  String? source;
  String? placeType;
  String? status;
  String? logo;
  List<UiDescriptionItemModel>? descriptionItems;
  TimeOfDay? openFrom;
  TimeOfDay? openTo;
  String? location;
  String? website;
  String? phone;

  UiPlaceModel({
    required this.id,
    this.title,
    this.openFrom,
    this.openTo,
    this.location,
    this.media = const [],
    this.logo,
    this.phone,
    this.website,
    this.source,
    required this.description,
    this.rating,
    this.status,
    this.placeType,
    required this.tags,
    this.baseTags = const [],
    this.weekdays = const [],
  }) : descriptionItems = [
          UiDescriptionItemModel(title: S.current.Website, description: title ?? '', descriptionUrl: website ?? ''),
          UiDescriptionItemModel(title: S.current.Phone, description: phone ?? ''),
          UiDescriptionItemModel(title: S.current.Location, description: location ?? ''),
          if (formatDate(null, null, openFrom, openTo, weekdays) != null)
            UiDescriptionItemModel(
              title: S.current.WorkHours,
              description: formatDate(null, null, openFrom, openTo, weekdays)!,
            ),
        ];

  String? validateCreation() {
    if (title == null || title!.isEmpty) {
      return S.current.XIsRequired(S.current.Title);
    } else if (description.isEmpty) {
      return S.current.XIsRequired(S.current.Description);
    } else if (media.isEmpty) {
      return S.current.XIsRequired(S.current.Photos);
    } else if (logo == null || logo!.isEmpty) {
      return S.current.XIsRequired(S.current.Logo);
    } else if (website == null || website!.isEmpty) {
      return S.current.XIsRequired(S.current.Website);
    } else if (phone == null || phone!.isEmpty) {
      return S.current.XIsRequired(S.current.Phone);
    } else if (location == null || location!.isEmpty) {
      return S.current.XIsRequired(S.current.Location);
    }

    return null;
  }
}
