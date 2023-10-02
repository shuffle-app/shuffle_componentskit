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
    required this.description,
    this.rating,
    required this.tags,
    this.baseTags = const [],
    this.weekdays = const [],
  }) : descriptionItems = [
          UiDescriptionItemModel(title: 'Website', description: website ?? ''),
          UiDescriptionItemModel(title: 'Phone', description: phone ?? ''),
          UiDescriptionItemModel(title: 'Location', description: location ?? ''),
          UiDescriptionItemModel(
            title: 'Work hours',
            description: formatDate(null, null, openFrom, openTo, weekdays) ?? '',
          ),
        ];

  String? validateCreation() {
    if (title == null || title!.isEmpty) {
      return 'Title is required';
    } else if (description.isEmpty) {
      return 'Description is required';
    } else if (media.isEmpty) {
      return 'Photos are required';
    } else if (logo == null || logo!.isEmpty) {
      return 'Logo is required';
    } else if (website == null || website!.isEmpty) {
      return 'Website is required';
    } else if (phone == null || phone!.isEmpty) {
      return 'Phone is required';
    } else if (location == null || location!.isEmpty) {
      return 'Location is required';
    }
    return null;
  }
}
