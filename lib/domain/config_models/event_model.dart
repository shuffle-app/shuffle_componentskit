import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/data/data.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  @JsonKey(name: 'version')
  final String version;

  @JsonKey(name: 'builder_type')
  final PageBuilderType pageBuilderType;

  @JsonKey(name: 'position_model')
  final PositionModel? positionModel;

  EventModel(
      {required this.version,
      required this.pageBuilderType,
      this.positionModel});

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
