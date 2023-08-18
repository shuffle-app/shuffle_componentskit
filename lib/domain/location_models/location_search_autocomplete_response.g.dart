// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_search_autocomplete_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationSearchAutocompleteResponse _$LocationSearchAutocompleteResponseFromJson(
        Map<String, dynamic> json) =>
    LocationSearchAutocompleteResponse(
      (json['predictions'] as List<dynamic>?)
          ?.map(
              (e) => AutocompletePrediction.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['status'] as String?,
    );

Map<String, dynamic> _$LocationSearchAutocompleteResponseToJson(
        LocationSearchAutocompleteResponse instance) =>
    <String, dynamic>{
      'predictions': instance.predictions,
      'status': instance.status,
    };

AutocompletePrediction _$AutocompletePredictionFromJson(
        Map<String, dynamic> json) =>
    AutocompletePrediction(
      json['description'] as String?,
      (json['matched_substrings'] as List<dynamic>?)
          ?.map((e) =>
              AutoCompleteMatchedSubstrings.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['place_id'] as String?,
      json['reference'] as String?,
      json['structured_formatting'] == null
          ? null
          : AutocompleteStructuredFormatting.fromJson(
              json['structured_formatting'] as Map<String, dynamic>),
      (json['terms'] as List<dynamic>?)
          ?.map((e) => AutoCompleteTerm.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['types'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AutocompletePredictionToJson(
        AutocompletePrediction instance) =>
    <String, dynamic>{
      'description': instance.description,
      'matched_substrings': instance.matchedSubstrings,
      'place_id': instance.placeId,
      'reference': instance.reference,
      'structured_formatting': instance.structuredFormatting,
      'terms': instance.terms,
      'types': instance.types,
    };

AutoCompleteTerm _$AutoCompleteTermFromJson(Map<String, dynamic> json) =>
    AutoCompleteTerm(
      json['offset'] as int?,
      json['value'] as String?,
    );

Map<String, dynamic> _$AutoCompleteTermToJson(AutoCompleteTerm instance) =>
    <String, dynamic>{
      'offset': instance.offset,
      'value': instance.value,
    };

AutocompleteStructuredFormatting _$AutocompleteStructuredFormattingFromJson(
        Map<String, dynamic> json) =>
    AutocompleteStructuredFormatting(
      json['main_text'] as String?,
      (json['main_text_matched_substrings'] as List<dynamic>?)
          ?.map((e) =>
              AutoCompleteMatchedSubstrings.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['secondary_text'] as String?,
    );

Map<String, dynamic> _$AutocompleteStructuredFormattingToJson(
        AutocompleteStructuredFormatting instance) =>
    <String, dynamic>{
      'main_text': instance.mainText,
      'main_text_matched_substrings': instance.mainTextMatchedSubstrings,
      'secondary_text': instance.secondaryText,
    };

AutoCompleteMatchedSubstrings _$AutoCompleteMatchedSubstringsFromJson(
        Map<String, dynamic> json) =>
    AutoCompleteMatchedSubstrings(
      json['length'] as int?,
      json['offset'] as int?,
    );

Map<String, dynamic> _$AutoCompleteMatchedSubstringsToJson(
        AutoCompleteMatchedSubstrings instance) =>
    <String, dynamic>{
      'length': instance.length,
      'offset': instance.offset,
    };
