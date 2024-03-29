import 'package:shuffle_uikit/shuffle_uikit.dart';

class ChatMessageUiModel {
  final DateTime timeSent;
  final String? message;
  final bool senderIsMe;
  final MessageType messageType;
  final ChatMessageInvitationData? invitationData;

  bool get isInvitation => messageType == MessageType.invitation && invitationData != null;

  ChatMessageUiModel({
    required this.timeSent,
    this.message,
    required this.senderIsMe,
    required this.messageType,
    this.invitationData,
  });
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

enum MessageType { message, invitation }
