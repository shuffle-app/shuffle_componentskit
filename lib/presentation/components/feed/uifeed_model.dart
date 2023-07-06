import '../../../shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiFeedModel {
  final UiEventModel? recommendedEvent;
  final bool showHowItWorks;
  final List<UiMoodModel>? moods;
  final List<UiUniversalModel>? mixedItems;
  final List<UiKitTag>? filterChips;
  final List<UiKitTag>? activeFilterChips;

  UiFeedModel(
      {this.filterChips,
      this.activeFilterChips,
      this.recommendedEvent,
      this.showHowItWorks = false,
      this.moods,
      this.mixedItems});
}

class UiUniversalModel {
  final int id;
  final Type type;
  final List<BaseUiKitMedia> media;
  final String description;
  final List<UiKitTag> tags;
  final List<UiKitTag>? baseTags;
  final String? title;

  UiUniversalModel(
      {required this.id,
      required this.type,
      required this.media,
      required this.description,
      required this.tags,
      this.baseTags,
      this.title});
}
