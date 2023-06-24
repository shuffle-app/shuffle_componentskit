import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_search_model.g.dart';

@JsonSerializable()
class ComponentSearchModel extends UiBaseModel {
  @JsonKey(name: 'show_free')
  final bool? showFree;

  ComponentSearchModel({
    this.showFree,
    required super.pageBuilderType,
    super.positionModel,
    required super.version,
  }) : super();

  factory ComponentSearchModel.fromJson(Map<String, dynamic> json) =>
      _$ComponentSearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentSearchModelToJson(this);
}
