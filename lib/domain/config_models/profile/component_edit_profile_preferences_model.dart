import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_edit_profile_preferences_model.g.dart';

@JsonSerializable()
class ComponentEditProfilePreferencesModel extends UiBaseModel {
  ComponentEditProfilePreferencesModel({
    required super.version,
    required super.pageBuilderType,
    super.positionModel,
  });

  factory ComponentEditProfilePreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$ComponentEditProfilePreferencesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentEditProfilePreferencesModelToJson(this);
}
