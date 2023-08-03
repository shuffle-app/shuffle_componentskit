class HangoutRecommendation {
  final String? userAvatar;

  final String? userNickname;

  final String? userName;

  final int? userPointsBalance;

  final int? commonInterests;

  HangoutRecommendation({
    this.userAvatar,
    this.userNickname,
    this.userName,
    this.userPointsBalance,
    this.commonInterests,
  });

  HangoutRecommendation copyWith({
    String? userAvatar,
    String? userNickname,
    String? userName,
    int? userPointsBalance,
    int? commonInterests,
  }) {
    return HangoutRecommendation(
      userAvatar: userAvatar ?? this.userAvatar,
      userNickname: userNickname ?? this.userNickname,
      userName: userName ?? this.userName,
      userPointsBalance: userPointsBalance ?? this.userPointsBalance,
      commonInterests: commonInterests ?? this.commonInterests,
    );
  }
}
