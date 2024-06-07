class FeedbackResponseUiModel {
  final DateTime timeSent;
  final String? message;
  final bool senderIsMe;
  final String senderName;
  final String? senderImagePath;
  final int? helpfulCount;

  FeedbackResponseUiModel({
    required this.timeSent,
    this.message,
    required this.senderIsMe,
    required this.senderName,
    this.senderImagePath,
    this.helpfulCount,
  });
}
