import 'package:shuffle_uikit/ui_models/places/base_ui_kit_media.dart';

class ActivityUiModel {
  final int id;
  final String? imageUrl;
  final String? title;
  final double? rating;
  final List<UiKitTag>? tags;
  final int? activity;
  final int? placeId;
  final int? eventId;

  ActivityUiModel({
    required this.id,
    this.imageUrl,
    this.title,
    this.rating,
    this.tags,
    this.activity,
    this.placeId,
    this.eventId,
  });
}
