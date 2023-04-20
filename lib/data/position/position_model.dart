import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'position_model.g.dart';

@JsonSerializable()
class PositionModel {
  @JsonKey(name: 'version')
  final String version;

  @JsonKey(
      name: 'alignment',
      fromJson: _stringToAlignment,
      toJson: _alignmentToString)
  final Alignment? alignment;

  PositionModel({
    required this.version,
    this.alignment,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) =>
      _$PositionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PositionModelToJson(this);
}

Alignment? _stringToAlignment(String? string) {
  switch (string) {
    case "center":
      return Alignment.center;
    case "centerLeft":
      return Alignment.centerLeft;
    default:
      return null;
  }
}

String? _alignmentToString(Alignment? alignment) => alignment?.toString();
