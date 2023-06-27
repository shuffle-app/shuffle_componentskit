import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_uikit/foundation/gradient_foundation.dart';

part 'properties_base_model.g.dart';

@JsonSerializable()
class PropertiesBaseModel {
  @JsonKey(name: 'sortNumber')
  final num? sortNumber;

  @JsonKey(name: 'duration', fromJson: _intToDuration)
  final Duration? duration;

  @JsonKey(name: 'imageLink')
  final String? imageLink;

  @JsonKey(name: 'value')
  final String? value;

  @JsonKey(
      name: 'gradient', fromJson: _stringToGradient, toJson: _gradientToJson)
  final LinearGradient? gradient;

  PropertiesBaseModel({
    this.duration = const Duration(milliseconds: 250),
    this.imageLink,
    this.gradient,
    this.value,
    this.sortNumber = 0,
  });

  factory PropertiesBaseModel.fromJson(Map<String, dynamic> json) =>
      _$PropertiesBaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertiesBaseModelToJson(this);
}

_intToDuration(val) => Duration(milliseconds: val);

_stringToGradient(val) {
  switch (val) {
    case 'attentionCard':
      return GradientFoundation.attentionCard;
    case 'greyGradient':
      return GradientFoundation.greyGradient;
    case 'badgeIcon':
      return GradientFoundation.badgeIcon;
    case 'buttonGradientLinear':
      return GradientFoundation.buttonGradientLinear;
    case 'defaultRadialGradient':
      return GradientFoundation.defaultRadialGradient;
    // case 'buttonGradient':
    //   return GradientFoundation.buttonGradient;
    case 'weatherOffState':
      return GradientFoundation.weatherOffState;
    case 'solidSurfaceLinearGradient':
      return GradientFoundation.solidSurfaceLinearGradient;
    case 'blackLinearGradient':
      return GradientFoundation.blackLinearGradient;
    case 'yellowLinearGradient':
      return GradientFoundation.yellowLinearGradient;
    default:
      return null;
  }
}

_gradientToJson(Gradient? g) => g?.toString();
