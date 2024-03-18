class VideoReactionUiModel {
  final String? videoUrl;
  final String? previewImageUrl;
  final String? authorAvatarUrl;
  final String? authorName;
  final String? placeName;
  final String? answeredCompanyName;
  final String? answeredCompanyLogo;
  final DateTime? companyAnswerDateTime;
  final DateTime? videoReactionDateTime;
  final DateTime? eventDate;
  final int? answeredCompanyId;
  final String? eventName;

  VideoReactionUiModel({
    this.videoUrl,
    this.previewImageUrl,
    this.placeName,
    this.authorName,
    this.authorAvatarUrl,
    this.answeredCompanyName,
    this.answeredCompanyLogo,
    this.companyAnswerDateTime,
    this.videoReactionDateTime,
    this.answeredCompanyId,
    this.eventDate,
    this.eventName,
  });
}
