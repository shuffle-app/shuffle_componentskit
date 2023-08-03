import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'personal_credential_verification_model.g.dart';

@JsonSerializable()
class PersonalCredentialVerificationModel extends UiBaseModel {
  PersonalCredentialVerificationModel({
    required super.version,
    required super.pageBuilderType,
  });

  factory PersonalCredentialVerificationModel.fromJson(Map<String, dynamic> json) =>
      _$PersonalCredentialVerificationModelFromJson(json);
}
