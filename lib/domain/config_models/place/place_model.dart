import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'place_model.g.dart';

@JsonSerializable()
class ComponentPlaceModel extends BaseModel {

  @JsonKey(name: 'booking_element_model')
  final BookingElementModel? bookingElementModel;

  @JsonKey(name: 'show_rating')
  final bool? showRating;

  @JsonKey(name: 'show_reviews')
  final bool? showReviews;

  @JsonKey(name: 'show_reactions')
  final bool? showReactions;

  ComponentPlaceModel(
      {this.showRating,
        this.showReviews,
        this.bookingElementModel,
        this.showReactions,
        required super.pageBuilderType,
        super.positionModel,
        required super.version,}):super();

  factory ComponentPlaceModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceModelToJson(this);
}
