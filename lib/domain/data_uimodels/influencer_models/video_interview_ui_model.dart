import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/foundation/graphics_foundation.dart';

class VideoInterviewUiModel {
  final String videoUrl;
  final String? thumbnailUrl;
  final String title;
  final UiUniversalModel? content;
  final String icon = GraphicsFoundation.instance.svg.playOutline.path;

  VideoInterviewUiModel({
    required this.videoUrl,
    this.thumbnailUrl,
    required this.title,
    required this.content,
  });
}
