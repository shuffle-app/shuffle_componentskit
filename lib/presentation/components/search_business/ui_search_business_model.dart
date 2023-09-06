import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiSearchBusinessModel {
  final List<UiPlaceModel> places;
  final List<UiKitTag>? filterChips;
  final List<UiKitTag>? activeFilterChips;
  final String heroSearchTag;
  final bool showHowItWorks;

  UiSearchBusinessModel({
    required this.heroSearchTag,
    required this.places,
    this.filterChips,
    this.showHowItWorks = false,
    this.activeFilterChips,
  });
}
