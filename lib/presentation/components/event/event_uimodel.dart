import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiEventModel {
  final String id;
  final String? title;
  final UiOwnerModel? owner;
  final List<BaseUiKitMedia>? media;
  final String? description;
  final List<UiKitTag>? tags;
  final List<UiKitTag>? baseTags;
  final double? rating;
  final List<UiDescriptionItemModel>? descriptionItems;

  UiEventModel({required this.id,
      this.title,
      this.owner,
      this.media,
      this.description,
      this.tags,
      this.baseTags,
      this.rating,
      this.descriptionItems});
}
