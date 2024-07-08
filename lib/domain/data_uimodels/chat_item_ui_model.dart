import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../shuffle_components_kit.dart';

class ChatItemUiModel {
  final int id;
  final int? contentId;
  final Type? contentType;
  final String chatTitle;
  final String? subtitle;
  final String? avatarUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int? unreadMessageCount;
  final UserTileType userType;
  final UiKitTag? tag;
  final bool isGroupChat;
  final List<ChatMemberModel>? members;
  final ChatMemberModel? owner;
  final List<UiKitTag>? contentTags;
  final bool userIsOwner;
  final DateTime creationDate;
  final DateTime deletionDate;

  int? get membersCount => members?.length;

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
    this.contentTags,
    this.owner,
    this.contentId,
    this.contentType,
    this.members,
    this.unreadMessageCount,
    this.tag,
    this.subtitle,
    this.userType = UserTileType.ordinary,
    this.avatarUrl,
  });

  ChatItemUiModel copyWith({
    String? chatTitle,
    String? subtitle,
    String? avatarUrl,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadMessageCount,
    UserTileType? userType,
    UiKitTag? tag,
    bool? isGroupChat,
    bool? userIsOwner,
    List<ChatMemberModel>? members,
    DateTime? creationDate,
    DateTime? deletionDate,
    Type? contentType,
    int? contentId,
  }) {
    return ChatItemUiModel(
      id: id,
      owner: owner,
      contentId: contentId ?? this.contentId,
      contentType: contentType ?? this.contentType,
      members: members ?? this.members,
      chatTitle: chatTitle ?? this.chatTitle,
      subtitle: subtitle ?? this.subtitle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      userType: userType ?? this.userType,
      tag: tag ?? this.tag,
      isGroupChat: isGroupChat ?? this.isGroupChat,
      userIsOwner: userIsOwner ?? this.userIsOwner,
      creationDate: creationDate ?? this.creationDate,
      deletionDate: deletionDate ?? this.deletionDate,
    );
  }
}
