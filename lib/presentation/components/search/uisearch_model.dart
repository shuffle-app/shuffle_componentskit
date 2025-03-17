import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiSearchModel {
  final List<UiUniversalModel> content;
  final List<UiKitTag>? filterChips;
  final List<String>? activeFilterChips;
  final String heroSearchTag;
  final bool showHowItWorks;

  const UiSearchModel({
    required this.heroSearchTag,
    required this.content,
    this.filterChips,
    this.showHowItWorks = false,
    this.activeFilterChips,
  });

  UiSearchModel copyWith({
    List<UiUniversalModel>? content,
    List<UiKitTag>? filterChips,
    List<String>? activeFilterChips,
    bool? showHowItWorks,
    String? heroSearchTag,
  }) =>
      UiSearchModel(
        heroSearchTag: heroSearchTag ?? this.heroSearchTag,
        content: content ?? this.content,
        filterChips: filterChips ?? this.filterChips,
        showHowItWorks: showHowItWorks ?? this.showHowItWorks,
        activeFilterChips: activeFilterChips ?? this.activeFilterChips,
      );
}

class ImageCard {
  final String title;
  final String backgroundImage;
  final Color backgroundColor;
  final VoidCallback? callback;

  ImageCard({required this.title, this.callback, required this.backgroundImage, required this.backgroundColor});
}
