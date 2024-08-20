import 'package:shuffle_components_kit/domain/data_uimodels/video_reaction_ui_model.dart';
import 'package:shuffle_uikit/foundation/graphics_foundation.dart';

class InfluencerContestUiModel {
  final String title;
  final String description;
  final VideoReactionUiModel? video;
  final String icon = GraphicsFoundation.instance.png.rating.path;

  InfluencerContestUiModel({
    required this.title,
    required this.description,
    this.video,
  });
}
