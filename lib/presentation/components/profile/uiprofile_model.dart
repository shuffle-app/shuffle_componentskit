import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiProfileModel {
  final VoidCallback? onShare;
  final String? nickname;
  final String? name;
  final String? description;
  final String? avatarUrl;
  final String? userCredo;
  final int? mindsetId;
  final int? followers;
  final VoidCallback? onFollow;
  final bool showSupportShuffle;
  final ValueChanged<int>? onDonate;
  final List<String>? allInterests;
  final List<String>? favoriteTags;
  final List<int>? favoriteTagsIds;
  final List<String>? tags;
  final List<int>? tagsIds;
  final List<String>? matchingInterests;
  final VoidCallback? onViewAllAchievements;
  final List<UiKitAchievementsModel> achievements;
  final UserTileType userTileType;
  final String? specialization;
  final List<String>? socialLinks;

  ProfileCard get cardWidget {
    AutoSizeGroup group = AutoSizeGroup();

    return ProfileCard(
      onShare: onShare,
      nickname: nickname,
      name: name,
      socialLinks: socialLinks,
      speciality: specialization,
      description: description,
      avatarUrl: avatarUrl,
      followers: followers,
      interests: allInterests,
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
    this.onShare,
    this.onDonate,
    this.mindsetId,
    this.showSupportShuffle = false,
    this.onFollow,
    this.matchingInterests,
    this.nickname,
    this.userCredo,
    this.name,
    this.description,
    this.favoriteTags,
    this.avatarUrl,
    this.allInterests,
    this.userTileType = UserTileType.ordinary,
    this.followers,
    this.achievements = const [],
    this.onViewAllAchievements,
    this.socialLinks,
    this.specialization,
    this.tags,
    this.tagsIds,
    this.favoriteTagsIds,
  });

  /// write [copyWith] method

  UiProfileModel copyWith({
    String? nickname,
    String? name,
    String? description,
    String? avatarUrl,
    String? userCredo,
    int? followers,
    int? mindsetId,
    VoidCallback? onFollow,
    bool? showSupportShuffle,
    ValueChanged<int>? onDonate,
    List<String>? allInterests,
    List<String>? favoriteTags,
    List<String>? matchingInterests,
    VoidCallback? onViewAllAchievements,
    List<UiKitAchievementsModel>? achievements,
    UserTileType? userTileType,
    VoidCallback? onShare,
    String? specialization,
    List<String>? socialLinks,
    List<String>? tags,
    List<int>? tagsIds,
    List<int>? favoriteTagsIds,
  }) =>
      UiProfileModel(
          onShare: onShare ?? this.onShare,
          nickname: nickname ?? this.nickname,
          name: name ?? this.name,
          description: description ?? this.description,
          avatarUrl: avatarUrl ?? this.avatarUrl,
          userCredo: userCredo ?? this.userCredo,
          followers: followers ?? this.followers,
          onFollow: onFollow ?? this.onFollow,
          showSupportShuffle: showSupportShuffle ?? this.showSupportShuffle,
          onDonate: onDonate ?? this.onDonate,
          allInterests: allInterests ?? this.allInterests,
          favoriteTags: favoriteTags ?? this.favoriteTags,
          matchingInterests: matchingInterests ?? this.matchingInterests,
          onViewAllAchievements: onViewAllAchievements ?? this.onViewAllAchievements,
          achievements: achievements ?? this.achievements,
          userTileType: userTileType ?? this.userTileType,
          specialization: specialization ?? this.specialization,
          socialLinks: socialLinks ?? this.socialLinks,
          tags: tags ?? this.tags,
          mindsetId: mindsetId ?? this.mindsetId,
          tagsIds: tagsIds ?? this.tagsIds,
          favoriteTagsIds: favoriteTagsIds ?? this.favoriteTagsIds);
}
