class VideoReactionUiModel {
  final String? videoUrl;
  final String? previewImageUrl;
  final String? answeredCompanyName;
  final String? answeredCompanyLogo;
  final DateTime? companyAnswerDateTime;
  final DateTime? videoReactionDateTime;
  final int? answeredCompanyId;

  VideoReactionUiModel({
    this.videoUrl,
    this.previewImageUrl,
    this.answeredCompanyName,
    this.answeredCompanyLogo,
    this.companyAnswerDateTime,
    this.videoReactionDateTime,
    this.answeredCompanyId,
  });
}
