import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_settings_model.g.dart';

@JsonSerializable()
class ComponentSettingsModel extends UiBaseModel {

  @JsonKey(name: 'content')
  final ContentBaseModel? content;

  ComponentSettingsModel( {
    required super.version,
     this.content,
    required super.pageBuilderType,
    super.positionModel,
  });

  factory ComponentSettingsModel.fromJson(Map<String, dynamic> json) => _$ComponentSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentSettingsModelToJson(this);
}
