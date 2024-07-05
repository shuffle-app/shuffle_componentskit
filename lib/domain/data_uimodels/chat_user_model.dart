class ChatMemberModel {
  final int id;
  final String name;
  final String? avatarUrl;
  final String username;
  final String? speciality;
  final bool? inviteAccepted;

  ChatMemberModel({
    required this.id,
    required this.name,
    required this.username,
    this.avatarUrl,
    this.speciality,
    this.inviteAccepted,
  });

  factory ChatMemberModel.empty() => ChatMemberModel(id: -1, name: '', username: '');

  bool get empty => id == -1;
}
