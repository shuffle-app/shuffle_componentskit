import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'position_model.g.dart';

@JsonSerializable()
class PositionModel {
  @JsonKey(name: 'version',defaultValue:'0')
  final String version;

  @JsonKey(
      name: 'title_alignment',
      fromJson: _stringToAlignment,
      toJson: _alignmentToString)
  final Alignment? titleAlignment;

  @JsonKey(
      name: 'body_alignment',
      fromJson: _stringToAlignment,
      toJson: _alignmentToString)
  final Alignment? bodyAlignment;

  @JsonKey(name: 'vertical_margin')
  final double? verticalMargin;

  @JsonKey(name: 'horizontal_margin')
  final double? horizontalMargin;

  PositionModel({
    this.verticalMargin,
    this.horizontalMargin,
    required this.version,
    this.titleAlignment,
    this.bodyAlignment,
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
    case "topLeft":
      return Alignment.topLeft;
    case "topCenter":
      return Alignment.topCenter;
    case "topRight":
      return Alignment.topRight;
    case "centerRight":
      return Alignment.centerRight;
    case "bottomLeft":
      return Alignment.bottomLeft;
    case "bottomCenter":
      return Alignment.bottomCenter;
    case "bottomRight":
      return Alignment.bottomRight;
    default:
      return null;
  }
}

String? _alignmentToString(Alignment? alignment) => alignment?.toString();
