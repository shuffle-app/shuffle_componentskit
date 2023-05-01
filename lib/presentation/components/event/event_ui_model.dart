import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiKitEvent {
  final String id;
  final String? title;
  final OwnerModel? owner;
  final List<UiKitMedia>? media;
  final String? description;
  final List<UiKitTag>? tags;
  final double? rating;
  final List<DescriptionItem>? descriptionItems;

  UiKitEvent({required this.id,
      this.title,
      this.owner,
      this.media,
      this.description,
      this.tags,
      this.rating,
      this.descriptionItems});
}
