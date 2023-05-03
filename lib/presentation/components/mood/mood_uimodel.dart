import '../../../shuffle_components_kit.dart';

class UiMoodModel {
  final String id;
  final String title;
  final String logo;
  final List<UiDescriptionItemModel>? descriptionItems;
  final List<UiPlaceModel>? places;

  UiMoodModel({required this.id, required this.title, required this.logo, this.descriptionItems, this.places});
}
