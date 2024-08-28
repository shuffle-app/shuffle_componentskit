import 'package:shuffle_components_kit/presentation/components/feed/uifeed_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class VoiceMessageUiModel {
  final String fileUrl;
  final Duration duration;
  final String icon = GraphicsFoundation.instance.svg.voice.path;
  final UiUniversalModel? content;

  VoiceMessageUiModel({
    required this.fileUrl,
    required this.duration,
    this.content,
  });
}
