import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_event_model.g.dart';

@JsonSerializable()
class ComponentEventModel extends UiBaseModel {

  @JsonKey(name: 'booking_element_model')
  final BookingElementModel? bookingElementModel;

  @JsonKey(name: 'show_reviews')
  final bool? showReviews;

  @JsonKey(name: 'show_reactions')
  final bool? showReactions;

  ComponentEventModel({
    required super.pageBuilderType,
    super.positionModel,
    required super.version,
    this.showReviews,
    this.bookingElementModel,
    this.showReactions,
  }) : super();

  factory ComponentEventModel.fromJson(Map<String, dynamic> json) =>
      _$ComponentEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentEventModelToJson(this);
}
