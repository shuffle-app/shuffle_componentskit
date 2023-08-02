import 'package:json_annotation/json_annotation.dart';

part 'hangout_recommendation.g.dart';

@JsonSerializable()
class HangoutRecommendation {
  @JsonKey(name: 'user_avatar')
  final String? userAvatar;

  @JsonKey(name: 'user_nickname')
  final String? userNickname;

  @JsonKey(name: 'user_name')
  final String? userName;

  @JsonKey(name: 'user_points_balance')
  final int? userPointsBalance;

  @JsonKey(name: 'common_interests')
  final int? commonInterests;

  HangoutRecommendation({
    this.userAvatar,
    this.userNickname,
    this.userName,
    this.userPointsBalance,
    this.commonInterests,
  });

  factory HangoutRecommendation.fromJson(Map<String, dynamic> json) => _$HangoutRecommendationFromJson(json);

  Map<String, dynamic> toJson() => _$HangoutRecommendationToJson(this);

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
