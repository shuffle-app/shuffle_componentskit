import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'company_login_model.g.dart';

@JsonSerializable()
class CompanyLoginModel extends UiBaseModel {
  CompanyLoginModel({
    required super.version,
    required super.pageBuilderType,
  });

  factory CompanyLoginModel.fromJson(Map<String, dynamic> json) => _$CompanyLoginModelFromJson(json);
}
