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
  final bool? helpfulForUser;
  final int id;
  final int? placeId;
  final int? eventId;

  FeedbackUiModel({
    required this.feedbackAuthorName,
    required this.feedbackText,
    required this.id,
    this.helpfulForUser,
    this.empty = false,
    this.feedbackAuthorPhoto,
    this.feedbackDateTime,
    this.feedbackRating,
    this.feedbackAuthorType,
    this.helpfulCount,
    this.placeId,
    this.eventId,
  });

  factory FeedbackUiModel.empty() =>
      FeedbackUiModel(
        id: 0,
        empty: true,
        feedbackAuthorName: '',
        feedbackText: '',
        helpfulForUser: false,
      );

  FeedbackUiModel copyWith({
    String? feedbackAuthorName,
    String? feedbackAuthorPhoto,
    DateTime? feedbackDateTime,
    int? feedbackRating,
    UserTileType? feedbackAuthorType,
    int? helpfulCount,
    bool? helpfulForUser,
    int? placeId,
    int? eventId
  }) {
    return FeedbackUiModel(
        feedbackAuthorName: feedbackAuthorName ?? this.feedbackAuthorName,
        feedbackAuthorPhoto: feedbackAuthorPhoto ?? this.feedbackAuthorPhoto,
        feedbackDateTime: feedbackDateTime ?? this.feedbackDateTime,
        feedbackRating: feedbackRating ?? this.feedbackRating,
        feedbackAuthorType: feedbackAuthorType ?? this.feedbackAuthorType,
        helpfulCount: helpfulCount ?? this.helpfulCount,
        helpfulForUser: helpfulForUser ?? this.helpfulForUser,
        feedbackText: feedbackText,
        empty: empty,
        id: id,
        placeId: placeId ?? this.placeId,
        eventId: eventId ?? this.eventId
    );
  }
}
