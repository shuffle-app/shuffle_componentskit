import 'package:shuffle_uikit/ui_kit/molecules/tiles/user/base_user_tile.dart';

class VideoReactionUiModel {
  final String? videoUrl;
  final String? previewImageUrl;
  final String? authorAvatarUrl;
  final String? authorName;
  final String? answeredCompanyName;
  final String? answeredCompanyLogo;
  final DateTime? companyAnswerDateTime;
  final DateTime? videoReactionDateTime;
  final DateTime? eventDate;
  final int? answeredCompanyId;
  final String? placeName;
  final String? eventName;
  final int? placeId;
  final int authorId;
  final int id;
  final UserTileType authorType;
  final String parentContentType;
  final int parentContentId;
  final DateTime? createdAt;
  int? nextReactionId;
  int? previousReactionId;
  bool isViewed;

  VideoReactionUiModel({
    required this.id,
    required this.authorId,
    required this.parentContentType,
    required this.parentContentId,
    required this.authorType,
    this.placeName,
    this.eventName,
    this.placeId,
    this.videoUrl,
    this.previewImageUrl,
    this.authorName,
    this.authorAvatarUrl,
    this.answeredCompanyName,
    this.answeredCompanyLogo,
    this.companyAnswerDateTime,
    this.videoReactionDateTime,
    this.answeredCompanyId,
    this.eventDate,
    this.nextReactionId,
    this.previousReactionId,
    this.createdAt,
    this.isViewed = false,
  });

  bool get empty => id == -1;

  bool get isReactionForEvent => parentContentType == 'event';

  bool get isReactionForPlace => parentContentType == 'place';

  factory VideoReactionUiModel.empty() => VideoReactionUiModel(
      id: -1, authorId: -1, parentContentType: '', parentContentId: -1, authorType: UserTileType.ordinary);

  VideoReactionUiModel copyWith({
    String? videoUrl,
    String? previewImageUrl,
    String? authorAvatarUrl,
    String? authorName,
    String? answeredCompanyName,
    String? answeredCompanyLogo,
    DateTime? companyAnswerDateTime,
    DateTime? videoReactionDateTime,
    DateTime? eventDate,
    int? answeredCompanyId,
    int? placeId,
    String? placeName,
    int? nextReactionId,
    int? previousReactionId,
    bool? isViewed,
    UserTileType? authorType,
    DateTime? createdAt,
  }) {
    return VideoReactionUiModel(
      id: id,
      authorId: authorId,
      parentContentType: parentContentType,
      parentContentId: parentContentId,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
      videoUrl: videoUrl ?? this.videoUrl,
      previewImageUrl: previewImageUrl ?? this.previewImageUrl,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      authorName: authorName ?? this.authorName,
      answeredCompanyName: answeredCompanyName ?? this.answeredCompanyName,
      answeredCompanyLogo: answeredCompanyLogo ?? this.answeredCompanyLogo,
      companyAnswerDateTime: companyAnswerDateTime ?? this.companyAnswerDateTime,
      videoReactionDateTime: videoReactionDateTime ?? this.videoReactionDateTime,
      eventDate: eventDate ?? this.eventDate,
      answeredCompanyId: answeredCompanyId ?? this.answeredCompanyId,
      nextReactionId: nextReactionId ?? this.nextReactionId,
      previousReactionId: previousReactionId ?? this.previousReactionId,
      isViewed: isViewed ?? this.isViewed,
      authorType: authorType ?? this.authorType,
      createdAt: createdAt?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VideoReactionUiModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
