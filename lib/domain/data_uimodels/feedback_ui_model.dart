import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedbackUiModel {
  final String feedbackAuthorName;
  final String? feedbackAuthorPhoto;
  final DateTime? feedbackDateTime;
  final String feedbackText;
  final double? feedbackRating;
  final UserTileType? feedbackAuthorType;

  FeedbackUiModel({
    required this.feedbackAuthorName,
    required this.feedbackText,
    this.feedbackAuthorPhoto,
    this.feedbackDateTime,
    this.feedbackRating,
    this.feedbackAuthorType,
  });
}
