import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_spinner_model.g.dart';

@JsonSerializable()
class ComponentSpinnerModel extends UiBaseModel {
  @JsonKey(name: 'show_favorite')
  final bool? showFavorite;

  ComponentSpinnerModel({
    this.showFavorite,
    required super.pageBuilderType,
    super.positionModel,
    required super.version,
  }) : super();

  factory ComponentSpinnerModel.fromJson(Map<String, dynamic> json) =>
      _$ComponentSpinnerModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentSpinnerModelToJson(this);
}
