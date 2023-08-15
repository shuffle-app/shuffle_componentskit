import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiEventModel {
  final int id;
  String? title;
  UiOwnerModel? owner;
  List<BaseUiKitMedia>? media;
  bool? favorite;
  bool isRecurrent;
  DateTime? date;
  TimeOfDay? time;
  String? description;
  String? location;
  List<UiKitTag>? tags;
  List<UiKitTag>? baseTags;
  double? rating;
  bool archived;
  List<String>? weekdays;
  List<UiDescriptionItemModel>? descriptionItems;

  UiEventModel({
    required this.id,
    this.title,
    this.favorite,
    this.owner,
    this.date,
    this.media,
    this.description,
    this.location,
    this.tags,
    this.baseTags,
    this.rating,
    this.time,
    this.weekdays,
    this.isRecurrent = false,
    this.archived = false,
  }) : descriptionItems = [
    if (date != null)
      UiDescriptionItemModel(
          title: 'Don’t miss it',
          description: DateFormat('dd/MM').format(date)),
    if (location != null)
      UiDescriptionItemModel(
        title: "Place",
        description: location,
      ),
  ];
}
