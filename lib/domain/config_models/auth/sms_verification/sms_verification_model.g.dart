// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmsVerificationModel _$SmsVerificationModelFromJson(
        Map<String, dynamic> json) =>
    SmsVerificationModel(
      version: json['version'] as String? ?? '0',
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
      codeDigitsCount: json['code_digits_count'] as int? ?? 4,
    );

Map<String, dynamic> _$SmsVerificationModelToJson(
        SmsVerificationModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
      'code_digits_count': instance.codeDigitsCount,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
  PageBuilderType.dialog: 'dialog',
};
