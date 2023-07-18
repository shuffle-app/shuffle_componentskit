// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_type_selection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTypeSelectionModel _$UserTypeSelectionModelFromJson(
        Map<String, dynamic> json) =>
    UserTypeSelectionModel(
      version: json['version'] as String? ?? '0',
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
    );

Map<String, dynamic> _$UserTypeSelectionModelToJson(
        UserTypeSelectionModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
  PageBuilderType.dialog: 'dialog',
};
