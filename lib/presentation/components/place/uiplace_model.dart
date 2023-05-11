import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiPlaceModel {
  final String id;
  final List<BaseUiKitMedia> media;
  final String description;
  final List<UiKitTag> tags;
  final List<UiKitTag>? baseTags;
  final double? rating;
  final String? title;
  final String? logo;
  final List<UiDescriptionItemModel>? descriptionItems;

  UiPlaceModel({
    required this.id,
    this.title,
    required this.media,
    this.logo,
    required this.description,
    this.rating,
    required this.tags,
    this.baseTags,
    this.descriptionItems,
  });
}
