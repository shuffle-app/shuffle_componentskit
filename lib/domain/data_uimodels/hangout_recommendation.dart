import 'package:shuffle_uikit/shuffle_uikit.dart';
class HangoutRecommendation {
  final int userId;

  final String? userAvatar;

  final String? userNickname;

  final String? userName;

  final int? userPointsBalance;

  final int? commonInterests;

  final UserTileType userTileType;

  HangoutRecommendation({
    required this.userId,
    this.userAvatar,
    this.userNickname,
    this.userName,
    this.userPointsBalance,
    this.commonInterests,
    this.userTileType = UserTileType.ordinary,
  });

  HangoutRecommendation copyWith({
    String? userAvatar,
    String? userNickname,
    String? userName,
    int? userPointsBalance,
    int? commonInterests,
    int? userId,
  }) {
    return HangoutRecommendation(
      userId: userId ?? this.userId,
      userAvatar: userAvatar ?? this.userAvatar,
      userNickname: userNickname ?? this.userNickname,
      userName: userName ?? this.userName,
      userPointsBalance: userPointsBalance ?? this.userPointsBalance,
      commonInterests: commonInterests ?? this.commonInterests,
    );
  }
}
