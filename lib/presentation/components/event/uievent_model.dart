import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiEventModel {
  final int id;
  final String? title;
  final UiOwnerModel? owner;
  final List<BaseUiKitMedia>? media;
  final bool? favorite;
  final DateTime? date;
  final String? description;
  final List<UiKitTag>? tags;
  final List<UiKitTag>? baseTags;
  final double? rating;
  final List<UiDescriptionItemModel>? descriptionItems;

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
      this.descriptionItems});
}
