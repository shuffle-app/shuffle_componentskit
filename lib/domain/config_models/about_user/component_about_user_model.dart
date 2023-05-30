import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_about_user_model.g.dart';

@JsonSerializable()
class ComponentAboutUserModel extends UiBaseModel {
  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'nickName')
  final String? nickName;

  @JsonKey(name: 'religions')
  final List<String?>? selectedReligions;

  @JsonKey(name: 'personType')
  final String? selectedPersonType;

  @JsonKey(name: 'gender')
  final String? selectedGender;

  @JsonKey(name: 'age')
  final int? age;

  ComponentAboutUserModel({
    this.name,
    this.age,
    this.nickName,
    this.selectedReligions,
    this.selectedPersonType,
    this.selectedGender,
    required super.version,
    required super.pageBuilderType,
    super.positionModel,
  });

  factory ComponentAboutUserModel.fromJson(Map<String, dynamic> json) => _$ComponentAboutUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentAboutUserModelToJson(this);
}
