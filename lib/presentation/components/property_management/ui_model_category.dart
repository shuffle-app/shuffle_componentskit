import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../components.dart';

class UiModelCategory extends UiKitTag {
  @override
  final int id;

  final List<UiModelProperty> categoryProperties;

  List<UiModelProperty> get uniqueProperties => categoryProperties.where((e) => e.unique).toList();

  List<UiModelProperty> get baseProperties => categoryProperties.where((e) => !e.unique).toList();

  UiModelCategory(
      {required super.title,
      required this.id,
      required this.categoryProperties,
      required super.icon,
      super.iconColor,
      super.textColor,
      super.unique});

  @override
  UiModelCategory copyWith({
    String? title,
    int? id,
    List<UiModelProperty>? categoryProperties,
    dynamic icon,
    Color? iconColor,
    Color? textColor,
    bool? unique,
  }) =>
      UiModelCategory(
        title: title ?? this.title,
        id: id ?? this.id,
        categoryProperties: categoryProperties ?? this.categoryProperties,
        icon: icon ?? this.icon,
        iconColor: iconColor ?? this.iconColor,
        textColor: textColor ?? this.textColor,
        unique: unique ?? this.unique,
      );

  @override
  bool operator ==(Object other) {
    return other is UiModelCategory &&
        id == other.id &&
        categoryProperties.map((e) => e.id).every(other.categoryProperties.map((e) => e.id).contains);
  }

  @override
  int get hashCode => (categoryProperties.map((e) => e.id).fold(0, (a, b) => a + b!) + id).hashCode;
}
