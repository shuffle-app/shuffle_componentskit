import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/data/data.dart';

part 'booking_element_model.g.dart';

@JsonSerializable()
class BookingElementModel {
  @JsonKey(name: 'version',defaultValue:'0')
  final String version;

  @JsonKey(name: 'position_model')
  final PositionModel? positionModel;

  @JsonKey(name: 'show_route')
  final bool? showRoute;

  @JsonKey(name: 'show_magnify')
  final bool? showMagnify;

  BookingElementModel(
      {this.showRoute,
      this.showMagnify,
      required this.version,
      this.positionModel});

  factory BookingElementModel.fromJson(Map<String, dynamic> json) =>
      _$BookingElementModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingElementModelToJson(this);
}
