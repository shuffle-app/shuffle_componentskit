import 'package:json_annotation/json_annotation.dart';

part 'location_search_autocomplete_response.g.dart';

@JsonSerializable()
class LocationSearchAutocompleteResponse {
  @JsonKey(name: 'predictions')
  final List<AutocompletePrediction>? predictions;

  @JsonKey(name: 'status')
  final String? status;

  LocationSearchAutocompleteResponse(this.predictions, this.status);

  factory LocationSearchAutocompleteResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationSearchAutocompleteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LocationSearchAutocompleteResponseToJson(this);
}

@JsonSerializable()
class AutocompletePrediction {
  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'matched_substrings')
  final List<AutoCompleteMatchedSubstrings>? matchedSubstrings;

  @JsonKey(name: 'place_id')
  final String? placeId;

  @JsonKey(name: 'reference')
  final String? reference;

  @JsonKey(name: 'structured_formatting')
  final AutocompleteStructuredFormatting? structuredFormatting;

  @JsonKey(name: 'terms')
  final List<AutoCompleteTerm>? terms;

  @JsonKey(name: 'types')
  final List<String>? types;

  AutocompletePrediction(this.description, this.matchedSubstrings, this.placeId, this.reference,
      this.structuredFormatting, this.terms, this.types);

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) =>
      _$AutocompletePredictionFromJson(json);

  Map<String, dynamic> toJson() => _$AutocompletePredictionToJson(this);
}

@JsonSerializable()
class AutoCompleteTerm {
  @JsonKey(name: 'offset')
  final int? offset;

  @JsonKey(name: 'value')
  final String? value;

  AutoCompleteTerm(this.offset, this.value);

  factory AutoCompleteTerm.fromJson(Map<String, dynamic> json) => _$AutoCompleteTermFromJson(json);

  Map<String, dynamic> toJson() => _$AutoCompleteTermToJson(this);
}

@JsonSerializable()
class AutocompleteStructuredFormatting {
  @JsonKey(name: 'main_text')
  final String? mainText;

  @JsonKey(name: 'main_text_matched_substrings')
  final List<AutoCompleteMatchedSubstrings>? mainTextMatchedSubstrings;

  @JsonKey(name: 'secondary_text')
  final String? secondaryText;

  AutocompleteStructuredFormatting(
      this.mainText, this.mainTextMatchedSubstrings, this.secondaryText);

  factory AutocompleteStructuredFormatting.fromJson(Map<String, dynamic> json) =>
      _$AutocompleteStructuredFormattingFromJson(json);

  Map<String, dynamic> toJson() => _$AutocompleteStructuredFormattingToJson(this);
}

@JsonSerializable()
class AutoCompleteMatchedSubstrings {
  @JsonKey(name: 'length')
  final int? length;

  @JsonKey(name: 'offset')
  final int? offset;

  AutoCompleteMatchedSubstrings(this.length, this.offset);

  factory AutoCompleteMatchedSubstrings.fromJson(Map<String, dynamic> json) =>
      _$AutoCompleteMatchedSubstringsFromJson(json);

  Map<String, dynamic> toJson() => _$AutoCompleteMatchedSubstringsToJson(this);
}
