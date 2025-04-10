import 'package:flutter/foundation.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedbackUiModel {
  final String feedbackAuthorName;
  final String? feedbackAuthorPhoto;
  final DateTime? feedbackDateTime;
  final String feedbackText;
  final int? feedbackRating;
  final UserTileType? feedbackAuthorType;
  final bool empty;
  int? helpfulCount;
  final bool? helpfulForUser;
  final int id;
  final int? feedbackAuthorId;
  final int? placeId;
  final int? eventId;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final bool canEdit;
  final List<BaseUiKitMedia> media;
  final bool showTranslateButton;
  final AsyncValueGetter<String?>? onTranslateText;
  final ValueNotifier<bool>? isTranslateLoading;

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
    this.feedbackAuthorId,
    this.placeId,
    this.eventId,
    this.media = const [],
    this.onTap,
    this.onEdit,
    this.canEdit = false,
    this.showTranslateButton = false,
    this.onTranslateText,
    this.isTranslateLoading,
  });

  factory FeedbackUiModel.empty() => FeedbackUiModel(
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
    int? feedbackAuthorId,
    int? placeId,
    int? eventId,
    List<BaseUiKitMedia>? media,
    VoidCallback? onTap,
    VoidCallback? onEdit,
    bool? canEdit,
    bool? showTranslateButton,
    Future<String?> Function()? onTranslateText,
    ValueNotifier<bool>? isTranslateLoading,
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
      feedbackAuthorId: feedbackAuthorId ?? this.feedbackAuthorId,
      media: media ?? this.media,
      placeId: placeId ?? this.placeId,
      eventId: eventId ?? this.eventId,
      onTap: onTap ?? this.onTap,
      showTranslateButton: showTranslateButton ?? this.showTranslateButton,
      onTranslateText: onTranslateText ?? this.onTranslateText,
      onEdit: onEdit ?? this.onEdit,
      canEdit: canEdit ?? this.canEdit,
      isTranslateLoading: isTranslateLoading ?? this.isTranslateLoading,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FeedbackUiModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
