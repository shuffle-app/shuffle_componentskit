import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiSearchModel {
  final List<UiKitTag>? filterChips;
  final List<String>? activeFilterChips;
  final String heroSearchTag;
  final bool showHowItWorks;

  UiSearchModel({
    required this.heroSearchTag,
    this.filterChips,
    this.showHowItWorks = false,
    this.activeFilterChips,
  });
}

class ImageCard {
  final String title;
  final String backgroundImage;
  final Color backgroundColor;
  final VoidCallback? callback;

  ImageCard(
      {required this.title,
      this.callback,
      required this.backgroundImage,
      required this.backgroundColor});
}
