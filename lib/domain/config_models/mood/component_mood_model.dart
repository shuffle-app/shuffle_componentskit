import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_mood_model.g.dart';

@JsonSerializable()
class ComponentMoodModel extends UiBaseModel {

  @JsonKey(name: 'content')
  final ContentBaseModel content;

  @JsonKey(name: 'show_stats')
  final bool? showStats;

  @JsonKey(name: 'show_places')
  final bool? showPlaces;

  ComponentMoodModel(
      {this.showPlaces,
        this.showStats,
        required super.pageBuilderType,
        required this.content,
        super.positionModel,
        required super.version,}):super();

  factory ComponentMoodModel.fromJson(Map<String, dynamic> json) =>
      _$ComponentMoodModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentMoodModelToJson(this);
}
