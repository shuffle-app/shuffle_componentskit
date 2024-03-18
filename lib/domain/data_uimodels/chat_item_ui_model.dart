import 'package:shuffle_uikit/shuffle_uikit.dart';

class ChatItemUiModel {
  final int id;
  final String username;
  final String nickname;
  final String? avatarUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int? unreadMessageCount;
  final UserTileType userType;

  String get lastMessageTimeFormatted {
    return formatDifference(lastMessageTime);
  }

  ChatItemUiModel({
    required this.id,
    required this.username,
    required this.nickname,
    required this.userType,
    this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadMessageCount,
  });
}
