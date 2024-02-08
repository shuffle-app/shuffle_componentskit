import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiProfileModel {
  final String? nickname;
  final String? name;
  final String? description;
  final String? avatarUrl;
  final String? userCredo;
  final int? followers;
  final VoidCallback? onFollow;
  final bool showSupportShuffle;
  final ValueChanged<int>? onDonate;
  final List<String>? interests;
  final List<String>? favorites;
  final List<String>? matchingInterests;
  final VoidCallback? onViewAllAchievements;
  final List<UiKitAchievementsModel> achievements;
  final UserTileType userTileType;

  ProfileCard get cardWidget {
    AutoSizeGroup group = AutoSizeGroup();

    return ProfileCard(
      nickname: nickname,
      name: name,
      description: description,
      avatarUrl: avatarUrl,
      followers: followers,
      interests: interests,
      userTileType: userTileType,
      onFollow: onFollow,
      matchingInterests: matchingInterests,
      profileType: ProfileCardType.personal,
      showSupportShuffle: showSupportShuffle,
      onDonate: onDonate,
      onViewAllAchievements: onViewAllAchievements,
      achievements: achievements.where((element) => element.asset != null).toList(),
      profileStats: [
        UiKitStats(
          title: S.current.Balance,
          value: '0\$',
          actionButton: SmallOrdinaryButton(
            text: S.current.Details.toUpperCase(),
            group: group,
          ),
        ),
        UiKitStats(
          title: S.current.Points,
          value: '0',
          actionButton: SmallOrdinaryButton(
            text: S.current.Spent.toUpperCase(),
            group: group,
          ),
        ),
      ],
    );
  }

  UiProfileModel({
    this.onDonate,
    this.showSupportShuffle = false,
    this.onFollow,
    this.matchingInterests,
    this.nickname,
    this.userCredo,
    this.name,
    this.description,
    this.favorites,
    this.avatarUrl,
    this.interests,
    this.userTileType = UserTileType.ordinary,
    this.followers,
    this.achievements = const [],
    this.onViewAllAchievements,
  });

  /// write [copyWith] method

  UiProfileModel copyWith({
    String? nickname,
    String? name,
    String? description,
    String? avatarUrl,
    String? userCredo,
    int? followers,
    VoidCallback? onFollow,
    bool? showSupportShuffle,
    ValueChanged<int>? onDonate,
    List<String>? interests,
    List<String>? favorites,
    List<String>? matchingInterests,
    VoidCallback? onViewAllAchievements,
    List<UiKitAchievementsModel>? achievements,
    UserTileType? userTileType,
  }) =>
      UiProfileModel(
        nickname: nickname ?? this.nickname,
        name: name ?? this.name,
        description: description ?? this.description,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        userCredo: userCredo ?? this.userCredo,
        followers: followers ?? this.followers,
        onFollow: onFollow ?? this.onFollow,
        showSupportShuffle: showSupportShuffle ?? this.showSupportShuffle,
        onDonate: onDonate ?? this.onDonate,
        interests: interests ?? this.interests,
        favorites: favorites ?? this.favorites,
        matchingInterests: matchingInterests ?? this.matchingInterests,
        onViewAllAchievements: onViewAllAchievements ?? this.onViewAllAchievements,
        achievements: achievements ?? this.achievements,
        userTileType: userTileType ?? this.userTileType,
      );
}
