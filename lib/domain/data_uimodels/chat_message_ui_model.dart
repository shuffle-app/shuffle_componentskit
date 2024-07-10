import 'package:shuffle_uikit/shuffle_uikit.dart';

class ChatMessageUiModel {
  final DateTime timeSent;
  final int messageId;
  final int senderId;
  final String? message;
  final String? infoMessageTitle;
  final bool senderIsMe;
  final String? senderName;
  final String? senderAvatar;
  final UserTileType? senderProfileType;
  final bool isRead;
  final MessageType messageType;
  final int? replyMessageId;
  final String? replyMessageText;
  final ChatMessageInvitationData? invitationData;

  bool get isInvitation => messageType == MessageType.invitation && invitationData != null;

  ChatMessageUiModel({
    required this.timeSent,
    required this.messageId,
    required this.senderId,
    required this.senderIsMe,
    required this.messageType,
    required this.isRead,
    this.replyMessageId,
    this.senderName,
    this.message,
    this.infoMessageTitle,
    this.invitationData,
    this.senderAvatar,
    this.senderProfileType,
    this.replyMessageText,
  });

  ChatMessageUiModel copyWith({
    DateTime? timeSent,
    String? message,
    String? infoMessageTitle,
    bool? senderIsMe,
    bool? isRead,
    MessageType? messageType,
    ChatMessageInvitationData? invitationData,
    String? senderName,
    String? senderAvatar,
    UserTileType? senderProfileType,
    int? replyMessageId,
    String? replyMessageText,
  }) {
    return ChatMessageUiModel(
      senderId: senderId,
      messageId: messageId,
      timeSent: timeSent ?? this.timeSent,
      senderName: senderName ?? this.senderName,
      message: message ?? this.message,
      infoMessageTitle: infoMessageTitle ?? this.infoMessageTitle,
      senderIsMe: senderIsMe ?? this.senderIsMe,
      isRead: isRead ?? this.isRead,
      messageType: messageType ?? this.messageType,
      invitationData: invitationData ?? this.invitationData,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      senderProfileType: senderProfileType ?? this.senderProfileType,
      replyMessageId: replyMessageId ?? this.replyMessageId,
      replyMessageText: replyMessageText ?? this.replyMessageText,
    );
  }
}

class ChatMessageInvitationData {
  final int placeId;
  final String placeName;
  final String placeImagePath;
  final List<InviteMessageUsersData> invitedPeopleAvatarPaths;
  final List<UiKitTag> tags;
  final String username;
  final UserTileType userType;

  ChatMessageInvitationData({
    required this.username,
    required this.placeId,
    required this.placeName,
    required this.placeImagePath,
    required this.invitedPeopleAvatarPaths,
    required this.tags,
    required this.userType,
  });
}

enum MessageType { message, invitation, info }
