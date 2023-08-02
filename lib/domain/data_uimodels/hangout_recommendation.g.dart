// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hangout_recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HangoutRecommendation _$HangoutRecommendationFromJson(
        Map<String, dynamic> json) =>
    HangoutRecommendation(
      userAvatar: json['user_avatar'] as String?,
      userNickname: json['user_nickname'] as String?,
      userName: json['user_name'] as String?,
      userPointsBalance: json['user_points_balance'] as int?,
      commonInterests: json['common_interests'] as int?,
    );

Map<String, dynamic> _$HangoutRecommendationToJson(
        HangoutRecommendation instance) =>
    <String, dynamic>{
      'user_avatar': instance.userAvatar,
      'user_nickname': instance.userNickname,
      'user_name': instance.userName,
      'user_points_balance': instance.userPointsBalance,
      'common_interests': instance.commonInterests,
    };
