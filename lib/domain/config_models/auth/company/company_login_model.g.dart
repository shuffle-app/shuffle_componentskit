// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyLoginModel _$CompanyLoginModelFromJson(Map<String, dynamic> json) =>
    CompanyLoginModel(
      version: json['version'] as String? ?? '0',
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
    );

Map<String, dynamic> _$CompanyLoginModelToJson(CompanyLoginModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
  PageBuilderType.dialog: 'dialog',
};
