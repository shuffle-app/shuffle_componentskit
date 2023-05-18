import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiOwnerModel {
  final String name;
  final String? username;
  final String? logo;
  final String id;
  final UserTileType type;
  final VoidCallback? onTap;

  UiOwnerModel({
    this.username,
    required this.name,
    this.logo,
    this.onTap,
    required this.id,
    required this.type,
  });

  Widget buildUserTile(BuildContext context) => context.userTile(
        name: name,
        username: username,
        avatarUrl: logo,
        type: type,
        onTap: onTap ?? () {},
      );
}
