import 'package:shuffle_uikit/shuffle_uikit.dart';

class ChatMessageUiModel {
  final DateTime timeSent;
  final int messageId;
  final String? message;
  final String? infoMessageTitle;
  final bool senderIsMe;
  final String? senderName;
  final bool isRead;
  final MessageType messageType;
  final ChatMessageInvitationData? invitationData;

  bool get isInvitation => messageType == MessageType.invitation && invitationData != null;

  ChatMessageUiModel({
    required this.timeSent,
    required this.messageId,
    required this.senderIsMe,
    required this.messageType,
    required this.isRead,
    this.senderName,
    this.message,
    this.infoMessageTitle,
    this.invitationData,
  });

  ChatMessageUiModel copyWith({
    DateTime? timeSent,
    int? messageId,
    String? message,
    String? infoMessageTitle,
    bool? senderIsMe,
    bool? isRead,
    MessageType? messageType,
    ChatMessageInvitationData? invitationData,
    String? senderName,
  }) {
    return ChatMessageUiModel(
      timeSent: timeSent ?? this.timeSent,
      senderName: senderName ?? this.senderName,
      messageId: messageId ?? this.messageId,
      message: message ?? this.message,
      infoMessageTitle: infoMessageTitle ?? this.infoMessageTitle,
      senderIsMe: senderIsMe ?? this.senderIsMe,
      isRead: isRead ?? this.isRead,
      messageType: messageType ?? this.messageType,
      invitationData: invitationData ?? this.invitationData,
    );
  }
}

class ChatMessageInvitationData {
  final int placeId;
  final String placeName;
  final String placeImagePath;
  final List<String?> invitedPeopleAvatarPaths;
  final List<UiKitTag> tags;
  final String username;

  ChatMessageInvitationData({
    required this.username,
    required this.placeId,
    required this.placeName,
    required this.placeImagePath,
    required this.invitedPeopleAvatarPaths,
    required this.tags,
  });
}

enum MessageType { message, invitation, info }
