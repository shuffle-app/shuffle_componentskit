import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiFeedBusinessModel {
  final UiEventModel? recommendedEvent;
  final bool showHowItWorksTitle;
  final bool showHowItWorksBody;
  final bool isHealthKitEnabled;
  final List<UiMoodModel>? moods;
  // final List<UiUniversalModel>? mixedItems;
  final List<UiKitTag>? filterChips;
  final List<UiKitTag>? activeFilterChips;

  UiFeedBusinessModel({
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
