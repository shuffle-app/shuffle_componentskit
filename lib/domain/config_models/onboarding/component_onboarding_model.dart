import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_onboarding_model.g.dart';

@JsonSerializable()
class ComponentOnboardingModel extends UiBaseModel {

  @JsonKey(name: 'content')
  final ContentBaseModel content;

  ComponentOnboardingModel( {
    required super.version,
    required this.content,
    required super.pageBuilderType,
    super.positionModel,
  });

  factory ComponentOnboardingModel.fromJson(Map<String, dynamic> json) => _$ComponentOnboardingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentOnboardingModelToJson(this);
}
