import 'package:shuffle_uikit/shuffle_uikit.dart';

class ChatMemberModel {
  final int id;
  final String name;
  final String? avatarUrl;
  final String username;
  final String? speciality;
  final bool? inviteAccepted;
  final UserTileType userType;
  final bool canBeKicked;
  final int? chatConnectId;

  ChatMemberModel({
    required this.id,
    required this.name,
    required this.username,
    required this.userType,
    required this.canBeKicked,
    this.avatarUrl,
    this.speciality,
    this.inviteAccepted,
    this.chatConnectId,
  });

  factory ChatMemberModel.empty() => ChatMemberModel(
        id: -1,
        name: '',
        username: '',
        userType: UserTileType.ordinary,
        canBeKicked: false,
      );

  bool get empty => id == -1;

  ChatMemberModel copyWith({
    int? id,
    String? name,
    String? username,
    UserTileType? userType,
    String? avatarUrl,
    String? speciality,
    bool? inviteAccepted,
    bool? canBeKicked,
    int? chatConnectId,
  }) {
    return ChatMemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      userType: userType ?? this.userType,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      speciality: speciality ?? this.speciality,
      inviteAccepted: inviteAccepted ?? this.inviteAccepted,
      canBeKicked: canBeKicked ?? this.canBeKicked,
      chatConnectId: chatConnectId ?? this.chatConnectId,
    );
  }
}
