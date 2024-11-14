import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiOwnerModel {
  final int id;
  final String name;
  final String? username;
  final String? logo;
  final UserTileType type;
  final VoidCallback? onTap;

  const UiOwnerModel({
    this.username,
    required this.id,
    required this.name,
    this.logo,
    this.onTap,
    required this.type,
  });

  Widget buildUserTile(BuildContext context) => context.userTile(
        data: BaseUiKitUserTileData(
          name: name,
          username: username,
          avatarUrl: logo,
          type: type,
          onTap: onTap,
        ),
      );

  Widget buildMenuItem({
    ValueChanged<int>? onMessageTap,
    ValueChanged<int>? onFollowTap,
    ValueChanged<int>? onUnFollowTap,
    ValueChanged<int>? onBlockTap,
  }) =>
      UiKitPopUpMenuTile(
        title: name,
        titleIcon: UiKitUserBadge(
          userType: type,
        ),
        subtitle: username != null ? '@$username' : null,
        leading: UiKitUserAvatar40x40(
          type: type,
          imageUrl: logo ?? '',
          userName: username ?? '',
        ),
        menuOptions: [
          if (onBlockTap != null)
            UiKitPopUpMenuButtonOption(
              title: 'Block user',
              value: 'Block user',
              onTap: () => onBlockTap(id),
            ),
          if (onUnFollowTap != null)
            UiKitPopUpMenuButtonOption(
              title: S.current.Unfollow,
              value: 'Unfollow',
              onTap: () => onUnFollowTap(id),
            ),
          if (onFollowTap != null)
            UiKitPopUpMenuButtonOption(
              title: S.current.Follow,
              value: 'Follow',
              onTap: () => onFollowTap(id),
            ),
          if (onMessageTap != null)
            UiKitPopUpMenuButtonOption(
              title: S.current.Message,
              value: 'message',
              onTap: () => onMessageTap(id),
            ),
        ],
      );
}
