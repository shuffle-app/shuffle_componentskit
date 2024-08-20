import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/property_management/ui_model_related_properties.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiModelProperty extends UiKitTag {
  final List<UiModelRelatedProperty>? relatedProperties;

  UiModelProperty(
      {required super.title,
      required super.id,
      required super.icon,
      super.unique,
      this.relatedProperties,
      super.iconColor,
      super.textColor});

  @override
  UiModelProperty copyWith({
    bool? isSelected,
    List<UiModelRelatedProperty>? relatedProperties,
    String? title,
    int? id,
    dynamic icon,
    bool? unique,
    Color? iconColor,
    Color? textColor,
  }) =>
      UiModelProperty(
        title: title ?? this.title,
        id: id ?? this.id,
        icon: icon ?? this.icon,
        unique: unique ?? this.unique,
        relatedProperties: relatedProperties ?? this.relatedProperties,
        iconColor: iconColor ?? this.iconColor,
        textColor: textColor ?? this.textColor,
      );

  @override
  bool operator ==(Object other) {
    return other is UiModelProperty && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
