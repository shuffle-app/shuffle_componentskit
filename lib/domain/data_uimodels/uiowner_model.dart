import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiOwnerModel {
  final String name;
  final Future<String>? username;
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
      FutureBuilder(
          future: username,
          builder: (context, snapshot) => UiKitPopUpMenuTile(
                title: name,
                titleIcon: const ImageWidget(
                  iconData: ShuffleUiKitIcons.memeberGradientStar,
                ),
                subtitle: snapshot.hasData ? snapshot.data : null,
                leading: context.userAvatar(size: UserAvatarSize.x40x40, type: type, userName: name, imageUrl: logo),
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
              ));
}
