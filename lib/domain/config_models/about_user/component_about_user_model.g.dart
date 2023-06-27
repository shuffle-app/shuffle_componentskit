// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_about_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComponentAboutUserModel _$ComponentAboutUserModelFromJson(
        Map<String, dynamic> json) =>
    ComponentAboutUserModel(
      version: json['version'] as String? ?? '0',
      content:
          ContentBaseModel.fromJson(json['content'] as Map<String, dynamic>),
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
      positionModel: json['position_model'] == null
          ? null
          : PositionModel.fromJson(
              json['position_model'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ComponentAboutUserModelToJson(
        ComponentAboutUserModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
      'position_model': instance.positionModel,
      'content': instance.content,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
  PageBuilderType.dialog: 'dialog',
  PageBuilderType.generalDialog: 'general_dialog',
};
