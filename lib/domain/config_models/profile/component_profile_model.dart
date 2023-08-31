import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_profile_model.g.dart';

@JsonSerializable()
class ComponentProfileModel extends UiBaseModel {
  @JsonKey(name: 'show_balace')
  final bool? showBalance;

  @JsonKey(name: 'show_find_people')
  final bool? showFindPeople;

  @JsonKey(name: 'show_messages')
  final bool? showMessages;

  @JsonKey(name: 'show_reviews')
  final bool? showReviews;

  @JsonKey(name: 'show_reactions')
  final bool? showReactions;

  @JsonKey(name: 'content',)
  final ContentBaseModel content;

  ComponentProfileModel({
    this.showFindPeople,
    this.showMessages,
    required this.content,
    this.showReviews,
    this.showReactions,
    this.showBalance,
    required super.pageBuilderType,
    super.positionModel,
    required super.version,
  }) : super();

  factory ComponentProfileModel.fromJson(Map<String, dynamic> json) => _$ComponentProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentProfileModelToJson(this);
}
