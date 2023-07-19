import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'user_type_selection_model.g.dart';

@JsonSerializable()
class UserTypeSelectionModel extends UiBaseModel {
  UserTypeSelectionModel({
    required super.version,
    required super.pageBuilderType,
  });

  factory UserTypeSelectionModel.fromJson(Map<String, dynamic> json) => _$UserTypeSelectionModelFromJson(json);
}
