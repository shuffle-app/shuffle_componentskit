import 'package:flutter/widgets.dart';

class VideoPreviewUiModel {
  final String? id;
  final String? title;
  final Duration? _duration;
  final Widget? previewImage;

  VideoPreviewUiModel({
    this.id,
    this.title,
    Duration? duration,
    this.previewImage,
  }) : _duration = duration;

  String get duration {
    if (_duration == null) {
      return '';
    }
    final minutes = _duration!.inMinutes;
    final seconds = _duration!.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
