// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_credential_verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalCredentialVerificationModel
    _$PersonalCredentialVerificationModelFromJson(Map<String, dynamic> json) =>
        PersonalCredentialVerificationModel(
          version: json['version'] as String? ?? '0',
          pageBuilderType:
              $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
        );

Map<String, dynamic> _$PersonalCredentialVerificationModelToJson(
        PersonalCredentialVerificationModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
  PageBuilderType.dialog: 'dialog',
};
