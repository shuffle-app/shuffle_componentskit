import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedbackUiModel {
  final String feedbackAuthorName;
  final String? feedbackAuthorPhoto;
  final DateTime? feedbackDateTime;
  final String feedbackText;
  final double? feedbackRating;
  final UserTileType? feedbackAuthorType;
  final bool empty;

  FeedbackUiModel({
    required this.feedbackAuthorName,
    required this.feedbackText,
    this.empty = false,
    this.feedbackAuthorPhoto,
    this.feedbackDateTime,
    this.feedbackRating,
    this.feedbackAuthorType,
  });

  factory FeedbackUiModel.empty() => FeedbackUiModel(empty: true, feedbackAuthorName: '', feedbackText: '');
}
