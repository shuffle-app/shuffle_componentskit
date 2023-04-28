import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiKitFeed {
  final UiKitEvent? recommendedEvent;
  final List<UiKitMood>? moods;
  final List<UiKitPlace>? places;

  UiKitFeed({this.recommendedEvent, this.moods, this.places});
}
