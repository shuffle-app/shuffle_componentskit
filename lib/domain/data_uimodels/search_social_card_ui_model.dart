import 'package:flutter/widgets.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SearchSocialCardUiModel {
  final BaseUiKitButtonIconData? imageData;
  final BorderRadius? leadingImageBorderRadius;
  final String title;
  final String subtitle;
  final String distance;
  final double progress;

  SearchSocialCardUiModel({
    this.imageData,
    this.leadingImageBorderRadius,
    required this.title,
    required this.subtitle,
    required this.distance,
    required this.progress,
  });
}
