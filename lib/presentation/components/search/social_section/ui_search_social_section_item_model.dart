import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../../shuffle_components_kit.dart';

class SearchSocialSectionItemUiModel {
  final String headerTitle;
  final String description;
  final List<BaseUiKitMedia> sliderMedia;
  final List<UiKitTag> baseTags;
  final List<UiKitTag> uniqueTags;
  final List<UiDescriptionItemModel>? descriptionItems;
  final String? headerAvatarLink;
  final double? rating;

  SearchSocialSectionItemUiModel({
    required this.headerTitle,
    required this.description,
    required this.sliderMedia,
    required this.baseTags,
    required this.uniqueTags,
    this.descriptionItems,
    this.headerAvatarLink,
    this.rating,
  });
}
