import '../../../shuffle_components_kit.dart';

class UiMoodModel {
  final int id;
  final String title;
  final String logo;
  final List<UiDescriptionItemModel>? descriptionItems;

  UiMoodModel(
      {required this.id,
      required this.title,
      required this.logo,
      this.descriptionItems});

  UiMoodModel copyWith({
    int? id,
    String? title,
    String? logo,
    List<UiDescriptionItemModel>? descriptionItems,
    List<UiPlaceModel>? places,
  }) =>
      UiMoodModel(
        id: id ?? this.id,
        title: title ?? this.title,
        logo: logo ?? this.logo,
        descriptionItems: descriptionItems ?? this.descriptionItems,
      );
}
