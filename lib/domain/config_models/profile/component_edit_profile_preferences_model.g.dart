// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_edit_profile_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComponentEditProfilePreferencesModel
    _$ComponentEditProfilePreferencesModelFromJson(Map<String, dynamic> json) =>
        ComponentEditProfilePreferencesModel(
          version: json['version'] as String? ?? '0',
          pageBuilderType:
              $enumDecode(_$PageBuilderTypeEnumMap, json['builder_type']),
          positionModel: json['position_model'] == null
              ? null
              : PositionModel.fromJson(
                  json['position_model'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$ComponentEditProfilePreferencesModelToJson(
        ComponentEditProfilePreferencesModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'builder_type': _$PageBuilderTypeEnumMap[instance.pageBuilderType]!,
      'position_model': instance.positionModel,
    };

const _$PageBuilderTypeEnumMap = {
  PageBuilderType.modalBottomSheet: 'modal_bottom_sheet',
  PageBuilderType.page: 'page',
  PageBuilderType.dialog: 'dialog',
  PageBuilderType.generalDialog: 'general_dialog',
};
