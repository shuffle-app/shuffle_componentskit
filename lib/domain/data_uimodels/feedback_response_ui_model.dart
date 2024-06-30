import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedbackResponseUiModel {
  final DateTime timeSent;
  final String? message;
  final bool senderIsMe;
  final String senderName;
  final String? senderImagePath;
  final int? helpfulCount;
  final int id;
  final UserTileType userTileType;

  FeedbackResponseUiModel( {
    required this.id,
    required this.timeSent,
    this.message,
    required this.senderIsMe,
    required this.senderName,
    this.senderImagePath,
    this.helpfulCount,
    required this.userTileType,
  });
}
