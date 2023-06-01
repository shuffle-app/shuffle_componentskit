import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/data/base_ui_model/uibase_model.dart';

part 'component_edit_profile_model.g.dart';

@JsonSerializable()
class ComponentEditProfileModel extends UiBaseModel {
  @JsonKey(name: 'user_profile_type')
  final String? userProfileType;

  ComponentEditProfileModel({
    this.userProfileType,
    required super.version,
    required super.pageBuilderType,
    super.positionModel,
  });

  factory ComponentEditProfileModel.fromJson(Map<String, dynamic> json) => _$ComponentEditProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentEditProfileModelToJson(this);
}
