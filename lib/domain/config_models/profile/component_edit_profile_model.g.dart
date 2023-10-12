// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_edit_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComponentEditProfileModel _$ComponentEditProfileModelFromJson(
        Map<String, dynamic> json) =>
    ComponentEditProfileModel(
      userProfileType: json['user_profile_type'] as String?,
      version: json['version'] as String? ?? '0',
      content: json['content'] == null
          ? const ContentBaseModel()
          : ContentBaseModel.fromJson(json['content'] as Map<String, dynamic>),
      pageBuilderType:
          $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
      positionModel: json['position_model'] == null
          ? null
          : PositionModel.fromJson(
              json['position_model'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ComponentEditProfileModelToJson(
        ComponentEditProfileModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
      'position_model': instance.positionModel,
      'user_profile_type': instance.userProfileType,
      'content': instance.content,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
  PageBuilderType.dialog: 'dialog',
};
