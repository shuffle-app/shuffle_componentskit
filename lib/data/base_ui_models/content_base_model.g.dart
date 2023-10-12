// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentBaseModel _$ContentBaseModelFromJson(Map<String, dynamic> json) =>
    ContentBaseModel(
      title: (json['title'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$ContentItemTypeEnumMap, k),
            ContentBaseModel.fromJson(e as Map<String, dynamic>)),
      ),
      subtitle: (json['subtitle'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$ContentItemTypeEnumMap, k),
            ContentBaseModel.fromJson(e as Map<String, dynamic>)),
      ),
      body: (json['body'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$ContentItemTypeEnumMap, k),
            ContentBaseModel.fromJson(e as Map<String, dynamic>)),
      ),
      properties: (json['properties'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, PropertiesBaseModel.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ContentBaseModelToJson(ContentBaseModel instance) =>
    <String, dynamic>{
      'title': instance.title
          ?.map((k, e) => MapEntry(_$ContentItemTypeEnumMap[k]!, e)),
      'subtitle': instance.subtitle
          ?.map((k, e) => MapEntry(_$ContentItemTypeEnumMap[k]!, e)),
      'body': instance.body
          ?.map((k, e) => MapEntry(_$ContentItemTypeEnumMap[k]!, e)),
      'properties': instance.properties,
    };

const _$ContentItemTypeEnumMap = {
  ContentItemType.card: 'card',
  ContentItemType.horizontalList: 'horizontal_list',
  ContentItemType.verticalList: 'vertical_list',
  ContentItemType.input: 'input',
  ContentItemType.separator: 'separator',
  ContentItemType.text: 'text',
  ContentItemType.textGradientable: 'text_gradientable',
  ContentItemType.image: 'image',
  ContentItemType.video: 'video',
  ContentItemType.bubbles: 'bubbles',
  ContentItemType.button: 'button',
  ContentItemType.singleSelect: 'single_select',
  ContentItemType.singleDropdown: 'single_dropdown',
  ContentItemType.multiSelect: 'multi_select',
  ContentItemType.toggles: 'toggles',
  ContentItemType.progressBars: 'progress_bars',
  ContentItemType.onboardingCard: 'onboarding_card',
  ContentItemType.pageOpener: 'page_opener',
  ContentItemType.tabBar: 'tab_bar',
  ContentItemType.countrySelector: 'country_selector',
  ContentItemType.redirect: 'redirects',
  ContentItemType.additionalMultiSelect: 'additional_multi_select',
  ContentItemType.hintDialog: 'hint_dialog',
  ContentItemType.advertisement: 'advertisement',
  ContentItemType.popover: 'popover',
};
