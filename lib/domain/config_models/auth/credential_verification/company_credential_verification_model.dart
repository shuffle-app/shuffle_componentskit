import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'company_credential_verification_model.g.dart';

@JsonSerializable()
class CompanyCredentialVerificationModel extends UiBaseModel {
  CompanyCredentialVerificationModel({
    required super.version,
    required super.pageBuilderType,
  });

  factory CompanyCredentialVerificationModel.fromJson(Map<String, dynamic> json) => _$CompanyCredentialVerificationModelFromJson(json);
}
