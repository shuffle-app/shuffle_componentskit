import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_feed_model.g.dart';

@JsonSerializable()
class ComponentFeedModel extends UiBaseModel {

  @JsonKey(name: 'show_daily_recomendation')
  final bool? showDailyRecomendation;

  @JsonKey(name: 'show_stories')
  final bool? showStories;

  @JsonKey(name: 'show_feelings')
  final bool? showFeelings;

  @JsonKey(name: 'show_places')
  final bool? showPlaces;

  @JsonKey(name: 'content',)
  final ContentBaseModel content;

  ComponentFeedModel(
      {this.showPlaces,
        this.showFeelings,
        this.showDailyRecomendation,
        this.showStories,
        required this.content,
        required super.pageBuilderType,
        super.positionModel,
        required super.version,}):super();

  factory ComponentFeedModel.fromJson(Map<String, dynamic> json) =>
      _$ComponentFeedModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentFeedModelToJson(this);
}
