import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'feed_model.g.dart';

@JsonSerializable()
class FeedModel extends BaseModel {

  @JsonKey(name: 'show_daily_recomendation')
  final bool? showDailyRecomendation;

  @JsonKey(name: 'show_stories')
  final bool? showStories;

  @JsonKey(name: 'show_feelings')
  final bool? showFeelings;

  @JsonKey(name: 'show_places')
  final bool? showPlaces;

  FeedModel(
      {this.showPlaces,
        this.showFeelings,
        this.showDailyRecomendation,
        this.showStories,
        required super.pageBuilderType,
        super.positionModel,
        required super.version,}):super();

  factory FeedModel.fromJson(Map<String, dynamic> json) =>
      _$FeedModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeedModelToJson(this);
}
