import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'shuffle_model.g.dart';

@JsonSerializable()
class ComponentShuffleModel extends BaseModel {
  @JsonKey(name: 'show_favorite')
  final bool? showFavorite;

  ComponentShuffleModel({
    this.showFavorite,
    required super.pageBuilderType,
    super.positionModel,
    required super.version,
  }) : super();

  factory ComponentShuffleModel.fromJson(Map<String, dynamic> json) =>
      _$ComponentShuffleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentShuffleModelToJson(this);
}
