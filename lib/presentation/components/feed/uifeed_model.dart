import '../../../shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiFeedModel {
  final UiEventModel? recommendedEvent;
  final bool showHowItWorks;
  final List<UiMoodModel>? moods;
  final List<UiPlaceModel>? places;
  final List<UiKitTag>? filterChips;
  final List<UiKitTag>? activeFilterChips;

  UiFeedModel(
      {this.filterChips,
      this.activeFilterChips,
      this.recommendedEvent,
      this.showHowItWorks = false,
      this.moods,
      this.places});
}
