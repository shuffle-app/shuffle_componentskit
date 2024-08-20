import 'package:shuffle_uikit/shuffle_uikit.dart';

class VoiceMessageUiModel {
  final String fileUrl;
  final Duration duration;
  final String icon = GraphicsFoundation.instance.svg.voice.path;

  VoiceMessageUiModel({
    required this.fileUrl,
    required this.duration,
  });
}
