import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_edit_profile_model.g.dart';

@JsonSerializable()
class ComponentEditProfileModel extends UiBaseModel {
  @JsonKey(name: 'user_profile_type')
  final String? userProfileType;

  @JsonKey(name: 'content')
  final ContentBaseModel content;

  ComponentEditProfileModel({
    this.userProfileType,
    required super.version,
    this.content = const ContentBaseModel(),
    required super.pageBuilderType,
    super.positionModel,
  });

  factory ComponentEditProfileModel.fromJson(Map<String, dynamic> json) => _$ComponentEditProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentEditProfileModelToJson(this);
}
