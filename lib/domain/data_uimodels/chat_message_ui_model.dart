class ChatMessageUiModel {
  final DateTime timeSent;
  final String message;
  final bool senderIsMe;
  final MessageType messageType;

  ChatMessageUiModel({
    required this.timeSent,
    required this.message,
    required this.senderIsMe,
    required this.messageType,
  });
}

enum MessageType { message, invitation }
