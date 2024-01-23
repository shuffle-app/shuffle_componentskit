import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiDonationUserModel {
  final int position;
  final String sum;
  final String username;
  final String name;
  final String? points;
  final UserTileType userType;
  final String? avatarUrl;

  UiDonationUserModel({
    this.points,
    this.avatarUrl,
    required this.sum,
    required this.name,
    required this.userType,
    required this.position,
    required this.username,
  });
}
