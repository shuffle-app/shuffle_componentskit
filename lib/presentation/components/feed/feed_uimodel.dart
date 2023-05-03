import '../../../shuffle_components_kit.dart';

class UiFeedModel {
  final UiEventModel? recommendedEvent;
  final List<UiMoodModel>? moods;
  final List<UiPlaceModel>? places;

  UiFeedModel({this.recommendedEvent, this.moods, this.places});
}
