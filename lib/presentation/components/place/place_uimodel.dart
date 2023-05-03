import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiPlaceModel {
  final String id;
  final List<UiKitMedia> media;
  final String description;
  final List<UiKitTag> tags;
  final double? rating;
  final String? title;
  final String? logo;

  UiPlaceModel({
    required this.id,
    this.title,
    required this.media,
    this.logo,
    required this.description,
    this.rating,
    required this.tags,
  });
}