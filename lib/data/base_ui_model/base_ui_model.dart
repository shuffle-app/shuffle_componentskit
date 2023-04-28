import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

abstract class BaseModel {
  @JsonKey(name: 'version',defaultValue:'0')
  final String version;

  @JsonKey(name: 'builder_type')
  final PageBuilderType pageBuilderType;

  @JsonKey(name: 'position_model')
  final PositionModel? positionModel;

  BaseModel(
      {required this.version,
      required this.pageBuilderType,
      this.positionModel});
}
