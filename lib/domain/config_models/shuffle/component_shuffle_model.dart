import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_shuffle_model.g.dart';

@JsonSerializable()
class ComponentShuffleModel extends UiBaseModel {
  @JsonKey(name: 'show_favorite')
  final bool? showFavorite;

  @JsonKey(name: 'content',)
  final ContentBaseModel content;

  ComponentShuffleModel({
    this.showFavorite,
    this.content = const ContentBaseModel(),
    required super.pageBuilderType,
    super.positionModel,
    required super.version,
  }) : super();

  factory ComponentShuffleModel.fromJson(Map<String, dynamic> json) =>
      _$ComponentShuffleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentShuffleModelToJson(this);
}
