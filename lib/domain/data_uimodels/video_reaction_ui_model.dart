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
  final int authorId;
  final int id;
  final UserTileType authorType;
  final String parentContentType;
  final int parentContentId;

  VideoReactionUiModel({
    required this.id,
    required this.authorId,
    required this.parentContentType,
    required this.parentContentId,
    this.placeName,
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
    this.authorType = UserTileType.ordinary,
  });

  bool get empty => id == -1;

  bool get isReactionForEvent => parentContentType == 'event';

  bool get isReactionForPlace => parentContentType == 'place';

  factory VideoReactionUiModel.empty() =>
      VideoReactionUiModel(id: -1, authorId: -1, parentContentType: '', parentContentId: -1);

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
    String? placeName,
  }) {
    return VideoReactionUiModel(
      id: id,
      authorId: authorId,
      parentContentType: parentContentType,
      parentContentId: parentContentId,
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
    );
  }
}
