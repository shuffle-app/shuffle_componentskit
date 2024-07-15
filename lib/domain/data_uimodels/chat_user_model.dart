import 'package:shuffle_uikit/shuffle_uikit.dart';

class ChatMemberModel {
  final int id;
  final String name;
  final String? avatarUrl;
  final String username;
  final String? speciality;
  final bool? inviteAccepted;
  final UserTileType userType;

  ChatMemberModel({
    required this.id,
    required this.name,
    required this.username,
    required this.userType,
    this.avatarUrl,
    this.speciality,
    this.inviteAccepted,
  });

  factory ChatMemberModel.empty() => ChatMemberModel(
        id: -1,
        name: '',
        username: '',
        userType: UserTileType.ordinary,
      );

  bool get empty => id == -1;
}
