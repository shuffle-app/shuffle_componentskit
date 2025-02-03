import 'package:shuffle_uikit/shuffle_uikit.dart';

class ChatMessageUiModel {
  final DateTime timeSent;
  final int messageId;
  final int senderId;
  final String? message;
  final String? additionalText;
  final String? gradientableText;
  final String? infoMessageTitle;
  final String? chatName;
  final bool senderIsMe;
  final String? senderName;
  final String? senderAvatar;
  final String? senderNickname;
  final UserTileType? senderProfileType;
  final bool isRead;
  final MessageType messageType;
  final ChatMessageInvitationData? invitationData;
  final ChatMessageUiModel? replyMessageModel;
  final int? connectId;
  final bool isLastMessageToDate;

  bool get isInvitation => messageType == MessageType.invitation && invitationData != null;

  const ChatMessageUiModel({
    required this.timeSent,
    required this.messageId,
    required this.senderId,
    required this.senderIsMe,
    required this.messageType,
    required this.isRead,
    required this.isLastMessageToDate,
    this.additionalText,
    this.chatName,
    this.connectId,
    this.gradientableText,
    this.senderName,
    this.message,
    this.infoMessageTitle,
    this.invitationData,
    this.senderAvatar,
    this.senderProfileType,
    this.replyMessageModel,
    this.senderNickname,
  });

  factory ChatMessageUiModel.replyMessage({
    required int id,
    required int senderId,
    required String message,
    required String senderAvatar,
    required String senderName,
    required String senderNickname,
    required UserTileType senderProfileType,
    required bool isLastMessageToDate,
  }) =>
      ChatMessageUiModel(
        timeSent: DateTime.now(),
        messageId: id,
        senderId: senderId,
        senderIsMe: false,
        message: message,
        messageType: MessageType.message,
        isRead: true,
        senderAvatar: senderAvatar,
        senderProfileType: senderProfileType,
        senderName: senderName,
        senderNickname: senderNickname,
        isLastMessageToDate: isLastMessageToDate,
      );

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
    ChatMessageUiModel? replyMessageModel,
    String? gradientableText,
    String? senderNickname,
    int? connectId,
    String? additionalText,
    bool? isLastMessageToDate,
  }) {
    return ChatMessageUiModel(
      senderId: senderId,
      messageId: messageId,
      connectId: connectId ?? this.connectId,
      additionalText: additionalText ?? this.additionalText,
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
      replyMessageModel: replyMessageModel ?? this.replyMessageModel,
      gradientableText: gradientableText ?? this.gradientableText,
      senderNickname: senderNickname ?? this.senderNickname,
      isLastMessageToDate: isLastMessageToDate ?? this.isLastMessageToDate,
    );
  }
}

class ChatMessageInvitationData {
  final int connectId;
  final int contentId;
  final int receiverId;
  final int senderId;
  final String contentName;
  final String contentImagePath;
  final Type contentType;
  final List<InviteMessageUsersData> invitedPeopleAvatarPaths;
  final List<UiKitTag> tags;
  final String senderUserName;
  final String receiverUserName;
  final UserTileType senderUserType;
  final UserTileType receiverUserType;
  final bool hasAcceptedInvite;

  const ChatMessageInvitationData({
    required this.receiverId,
    required this.senderId,
    required this.senderUserName,
    required this.receiverUserName,
    required this.contentId,
    required this.contentName,
    required this.contentImagePath,
    required this.invitedPeopleAvatarPaths,
    required this.tags,
    required this.senderUserType,
    required this.contentType,
    required this.receiverUserType,
    required this.hasAcceptedInvite,
    required this.connectId,
  });

  ChatMessageInvitationData copyWith({
    int? contentId,
    String? contentName,
    String? contentImagePath,
    Type? contentType,
    List<InviteMessageUsersData>? invitedPeopleAvatarPaths,
    List<UiKitTag>? tags,
    String? senderUserName,
    String? receiverUserName,
    UserTileType? senderUserType,
    UserTileType? receiverUserType,
    int? receiverId,
    int? senderId,
    bool? hasAcceptedInvite,
    int? connectId,
  }) {
    return ChatMessageInvitationData(
      connectId: connectId ?? this.connectId,
      hasAcceptedInvite: hasAcceptedInvite ?? this.hasAcceptedInvite,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      contentId: contentId ?? this.contentId,
      contentName: contentName ?? this.contentName,
      contentImagePath: contentImagePath ?? this.contentImagePath,
      contentType: contentType ?? this.contentType,
      invitedPeopleAvatarPaths: invitedPeopleAvatarPaths ?? this.invitedPeopleAvatarPaths,
      tags: tags ?? this.tags,
      senderUserName: senderUserName ?? this.senderUserName,
      senderUserType: senderUserType ?? this.senderUserType,
      receiverUserName: receiverUserName ?? this.receiverUserName,
      receiverUserType: receiverUserType ?? this.receiverUserType,
    );
  }
}

enum MessageType { message, invitation, info, joinRequest }
