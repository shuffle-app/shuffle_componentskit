import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiInvitePersonModel extends UiInviteToFavoritePlacesModel {
  final int id;
  final int poolId;
  final String name;
  final String description;
  final String? avatarLink;
  final UserTileType userTileType;
  final int? rating;
  final bool? handshake;
  bool isSelected;

  UiInvitePersonModel({
    super.date,
    this.isSelected = false,
    required this.name,
    required this.id,
    required this.poolId,
    this.rating,
    this.handshake,
    this.userTileType = UserTileType.ordinary,
    this.avatarLink,
    required this.description,
  });

  @override
  operator ==(Object other) {
    return other is UiInvitePersonModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class UiInviteChatModel extends UiInviteToFavoritePlacesModel {
  final int id;
  final String chatTitle;
  final String adminName;
  final String? avatarUrl;
  final UserTileType? userTileType;
  final int chatMembersCount;

  const UiInviteChatModel({
    required this.id,
    required this.chatTitle,
    required this.adminName,
    this.chatMembersCount = 0,
    this.avatarUrl,
    this.userTileType,
    super.date,
  });
}
