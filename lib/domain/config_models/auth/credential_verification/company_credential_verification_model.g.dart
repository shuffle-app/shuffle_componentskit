// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_credential_verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyCredentialVerificationModel _$CompanyCredentialVerificationModelFromJson(
        Map<String, dynamic> json) =>
    CompanyCredentialVerificationModel(
      version: json['version'] as String? ?? '0',
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
    );

Map<String, dynamic> _$CompanyCredentialVerificationModelToJson(
        CompanyCredentialVerificationModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
  PageBuilderType.dialog: 'dialog',
};
