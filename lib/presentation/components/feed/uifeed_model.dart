import '../../../shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiFeedModel {
  final UiEventModel? recommendedEvent;
  final bool showHowItWorksTitle;
  final bool showHowItWorksBody;
  final List<UiMoodModel>? moods;
  // final List<UiUniversalModel>? mixedItems;
  final List<UiKitTag>? filterChips;
  final List<UiKitTag>? activeFilterChips;

  UiFeedModel(
      {this.filterChips,
      this.activeFilterChips,
      this.showHowItWorksBody = false,
      this.recommendedEvent,
      this.showHowItWorksTitle = false,
      this.moods,
      // this.mixedItems
      });
}

class UiUniversalModel {
  final int id;
  final String type;
  final String? source;
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
      this.source,
      this.title});
}
