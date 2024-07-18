import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../shuffle_components_kit.dart';

class ChatItemUiModel {
  final int id;
  final int? contentId;
  final Type? contentType;
  final String chatTitle;
  final String? subtitle;
  final String? avatarUrl;
  final String? contentTitle;
  final String? contentAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String? lastMessageSenderName;
  final int? unreadMessageCount;
  final UserTileType userType;
  final UiKitTag? tag;
  final bool isGroupChat;
  final List<ChatMemberModel>? members;
  final ChatMemberModel? owner;
  final List<UiKitTag>? contentTags;
  final bool userIsOwner;
  final bool hasAcceptedInvite;
  final DateTime creationDate;
  final DateTime deletionDate;
  final bool disabled;

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
    this.lastMessageSenderName,
    this.disabled = false,
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
    this.contentTitle,
    this.contentAvatar,
    this.hasAcceptedInvite = false,
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
    String? contentTitle,
    String? contentAvatar,
    List<UiKitTag>? contentTags,
    bool? hasAcceptedInvite,
    bool? disabled,
    String? lastMessageSenderName,
  }) {
    return ChatItemUiModel(
      id: id,
      owner: owner,
      lastMessageSenderName: lastMessageSenderName ?? this.lastMessageSenderName,
      hasAcceptedInvite: hasAcceptedInvite ?? this.hasAcceptedInvite,
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
      contentTags: contentTags ?? this.contentTags,
      contentTitle: contentTitle ?? this.contentTitle,
      contentAvatar: contentAvatar ?? this.contentAvatar,
      tag: tag ?? this.tag,
      isGroupChat: isGroupChat ?? this.isGroupChat,
      userIsOwner: userIsOwner ?? this.userIsOwner,
      creationDate: creationDate ?? this.creationDate,
      deletionDate: deletionDate ?? this.deletionDate,
      disabled: disabled ?? this.disabled,
    );
  }
}
