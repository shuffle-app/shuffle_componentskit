import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiOwnerModel {
  final String name;
  final String? username;
  final String? logo;
  final UserTileType type;
  final VoidCallback? onTap;

  UiOwnerModel({
    this.username,
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
    VoidCallback? onMessageTap,
    VoidCallback? onFollowTap,
    VoidCallback? onUnFollowTap,
    VoidCallback? onBlockTap,
  }) =>
       UiKitPopUpMenuTile(
                title: name,
                titleIcon: UiKitUserBadge(userType: type,),
                subtitle: username!=null ? '@$username' : null,
                leading:UiKitUserAvatar40x40(
                  type: type,
                  imageUrl: logo ?? '',
                  userName: username ?? '',
                ),
                menuOptions: [
                  if (onBlockTap != null)
                    UiKitPopUpMenuButtonOption(
                      title: 'Block user',
                      value: 'Block user',
                      onTap: onBlockTap,
                    ),
                  if (onUnFollowTap != null)
                    UiKitPopUpMenuButtonOption(
                      title: 'Unfollow',
                      value: 'Unfollow',
                      onTap: onUnFollowTap,
                    ),
                  if (onFollowTap != null)
                    UiKitPopUpMenuButtonOption(
                      title: 'Follow',
                      value: 'Follow',
                      onTap: onFollowTap,
                    ),
                  if (onMessageTap != null)
                    UiKitPopUpMenuButtonOption(
                      title: 'Message',
                      value: 'message',
                      onTap: onMessageTap,
                    ),
                ],
              );
}
