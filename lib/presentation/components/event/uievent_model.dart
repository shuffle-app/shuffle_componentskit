import 'package:flutter/material.dart';
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
  List<UiKitTag>? tags;
  List<UiKitTag>? baseTags;
  double? rating;
  bool archived;
  List<UiDescriptionItemModel>? descriptionItems;

  UiEventModel({required this.id,
      this.title,
      this.favorite,
      this.owner,
      this.date,
      this.media,
      this.description,
      this.tags,
      this.baseTags,
      this.rating,
      this.time,
      this.isRecurrent = false,
    this.archived = false,
      this.descriptionItems});
}
