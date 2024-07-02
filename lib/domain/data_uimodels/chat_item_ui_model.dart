import 'package:shuffle_uikit/shuffle_uikit.dart';

class ChatItemUiModel {
  final int id;
  final String chatTitle;
  final String? subtitle;
  final String? avatarUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int? unreadMessageCount;
  final UserTileType userType;
  final UiKitTag? tag;
  final bool isGroupChat;
  final bool userIsOwner;
  final int? membersCount;
  final DateTime creationDate;
  final DateTime deletionDate;

  String get lastMessageTimeFormatted {
    return formatDifference(lastMessageTime);
  }

  ChatItemUiModel({
    required this.id,
    required this.chatTitle,
    required this.userIsOwner,
    required this.isGroupChat,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.creationDate,
    required this.deletionDate,
    this.membersCount,
    this.unreadMessageCount,
    this.tag,
    this.subtitle,
    this.userType = UserTileType.ordinary,
    this.avatarUrl,
  });
}
