import 'package:intl/intl.dart';
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
    final difference = DateTime.now().difference(lastMessageTime).inDays;
    if (difference == 0) {
      final differenceInHours = DateTime.now().difference(lastMessageTime).inHours;

      return '${differenceInHours}h ago';
    } else if (difference == 1) {
      return 'yesterday';
    } else if (difference > 1 && difference < 7) {
      return 'a week ago';
    } else {
      return DateFormat('dd.MM.yyyy').format(lastMessageTime);
    }
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
