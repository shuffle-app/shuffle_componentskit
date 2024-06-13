import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedbackUiModel {
  final String feedbackAuthorName;
  final String? feedbackAuthorPhoto;
  final DateTime? feedbackDateTime;
  final String feedbackText;
  final int? feedbackRating;
  final UserTileType? feedbackAuthorType;
  final bool empty;
  final int? helpfulCount;
  final int id;

  FeedbackUiModel({
    required this.feedbackAuthorName,
    required this.feedbackText,
    required this.id,
    this.empty = false,
    this.feedbackAuthorPhoto,
    this.feedbackDateTime,
    this.feedbackRating,
    this.feedbackAuthorType,
    this.helpfulCount,
  });

  factory FeedbackUiModel.empty() => FeedbackUiModel(id: 0, empty: true, feedbackAuthorName: '', feedbackText: '');

  FeedbackUiModel copyWith({
    String? feedbackAuthorName,
    String? feedbackAuthorPhoto,
    DateTime? feedbackDateTime,
    int? feedbackRating,
    UserTileType? feedbackAuthorType,
    int? helpfulCount,
  }) {
    return FeedbackUiModel(
      feedbackAuthorName: feedbackAuthorName ?? this.feedbackAuthorName,
      feedbackAuthorPhoto: feedbackAuthorPhoto ?? this.feedbackAuthorPhoto,
      feedbackDateTime: feedbackDateTime ?? this.feedbackDateTime,
      feedbackRating: feedbackRating ?? this.feedbackRating,
      feedbackAuthorType: feedbackAuthorType ?? this.feedbackAuthorType,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      feedbackText: feedbackText,
      empty: empty,
      id: id,
    );
  }
}
