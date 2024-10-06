import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class VideoInterviewUiModel {
  final String videoUrl;
  final String? thumbnailUrl;
  final String title;
  final UiUniversalModel? content;
  final IconData icon = ShuffleUiKitIcons.playoutline;

  VideoInterviewUiModel({
    required this.videoUrl,
    this.thumbnailUrl,
    required this.title,
    required this.content,
  });
}
