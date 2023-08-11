import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiPlaceModel {
  int id;
  List<BaseUiKitMedia> media;
  List<String> weekdays;
  String description;
  List<UiKitTag> tags;
  List<UiKitTag>? baseTags;
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
     this.media = const [],
    this.logo,
    required this.description,
    this.rating,
    required this.tags,
    this.baseTags,
    this.weekdays = const [],
    this.descriptionItems,
  });
}
