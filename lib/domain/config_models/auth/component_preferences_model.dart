import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_preferences_model.g.dart';

@JsonSerializable()
class ComponentPreferencesModel extends UiBaseModel {
  @JsonKey(name: 'content')
  final ContentBaseModel content;

  @JsonKey(name: 'show_search_bubbles')
  final bool? showBubbleSearch;

  ComponentPreferencesModel({
    required this.content,
    this.showBubbleSearch,
    required super.version,
    required super.pageBuilderType,
    super.positionModel,
  });

  factory ComponentPreferencesModel.fromJson(Map<String, dynamic> json) => _$ComponentPreferencesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentPreferencesModelToJson(this);
}
