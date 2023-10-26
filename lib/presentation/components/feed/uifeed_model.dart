import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiFeedModel {
  final UiEventModel? recommendedEvent;
  final bool showHowItWorksTitle;
  final bool showHowItWorksBody;
  final bool isHealthKitEnabled;
  final List<UiMoodModel>? moods;
  // final List<UiUniversalModel>? mixedItems;
  final List<UiKitTag>? filterChips;
  final List<UiKitTag>? activeFilterChips;

  UiFeedModel({
    this.filterChips,
    this.activeFilterChips,
    this.showHowItWorksBody = false,
    this.isHealthKitEnabled = true,
    this.recommendedEvent,
    this.showHowItWorksTitle = false,
    this.moods,
    // this.mixedItems
  });
}

class UiUniversalModel extends Advertisable {
  final int id;
  final String type;
  final String? source;
  final List<BaseUiKitMedia> media;
  final String description;
  final List<UiKitTag> tags;
  final List<UiKitTag>? baseTags;
  final List<String>? weekdays;
  final String? title;
  final String? website;
  final String? location;

  UiUniversalModel({
    required this.id,
    required this.type,
    required this.media,
    required this.description,
    required this.tags,
    this.baseTags,
    this.website,
    this.weekdays,
    this.location,
    this.source,
    this.title,
  }) : super(isAdvertisement: false);

  UiUniversalModel.advertisement({
    this.id = -1,
    this.type = 'advertisement',
    this.media = const [],
    this.description = '',
    this.tags = const [],
    this.baseTags,
    this.website,
    this.weekdays,
    this.location,
    this.source,
    this.title,
  }) : super(isAdvertisement: true);
}
