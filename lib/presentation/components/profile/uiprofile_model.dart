import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiProfileModel {
  final VoidCallback? onShare;
  final VoidCallback? onPointsDetails;
  final String? nickname;
  final String? name;
  final String? email;
  final String? phone;
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
  final VoidCallback? onCustomDonate;
  final VoidCallback? onViewAllAchievements;
  final List<UiKitAchievementsModel> achievements;
  final UserTileType userTileType;
  final String? specialization;
  final List<String>? socialLinks;
  final int? points;
  final bool? beInSearch;

  ProfileCard get cardWidget {
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
      onCustomDonate: onCustomDonate,
      badge: userTileType == UserTileType.pro
          ? const ProMemberPlate()
          : userTileType == UserTileType.premium
              ? const PremiumMemberPlate()
              : userTileType == UserTileType.influencer
                  ? const InfluencerMemberPlate()
                  : null,
      onViewAllAchievements: onViewAllAchievements,
      achievements: achievements.where((element) => element.posterUrl != null || element.objectUrl != null).toList(),
      profileStats: [
        UiKitStats(
          title: S.current.Balance,
          value: '0',
          actionButton: SmallOrdinaryButton(
            text: S.current.Details.toUpperCase(),
            group: _statsConstGroup,
          ),
        ),
        UiKitStats(
          title: S.current.Points,
          value: points?.toString() ?? '0',
          actionButton: SmallOrdinaryButton(
            text: S.current.Details.toUpperCase(),
            group: _statsConstGroup,
            onPressed: onPointsDetails,
          ),
        ),
      ],
    );
  }

  UiProfileModel({
    this.onShare,
    this.onPointsDetails,
    this.onDonate,
    this.onCustomDonate,
    this.mindsetId,
    this.showSupportShuffle = false,
    this.onFollow,
    this.matchingInterests,
    this.nickname,
    this.userCredo,
    this.name,
    this.beInSearch,
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
    this.email,
    this.points,
    this.phone,
  });

  /// write [copyWith] method

  UiProfileModel copyWith(
          {String? nickname,
          String? name,
          String? description,
          String? avatarUrl,
          String? userCredo,
          int? followers,
          int? mindsetId,
          VoidCallback? onFollow,
          VoidCallback? onPointsDetails,
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
          String? email,
          String? phone,
          int? points,
          VoidCallback? onCustomDonate,
          bool? beInSearch}) =>
      UiProfileModel(
          onShare: onShare ?? this.onShare,
          onPointsDetails: onPointsDetails ?? this.onPointsDetails,
          nickname: nickname ?? this.nickname,
          name: name ?? this.name,
          description: description ?? this.description,
          avatarUrl: avatarUrl ?? this.avatarUrl,
          userCredo: userCredo ?? this.userCredo,
          followers: followers ?? this.followers,
          onFollow: onFollow ?? this.onFollow,
          showSupportShuffle: showSupportShuffle ?? this.showSupportShuffle,
          onDonate: onDonate ?? this.onDonate,
          onCustomDonate: onCustomDonate ?? this.onCustomDonate,
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
          email: email ?? this.email,
          phone: phone ?? this.phone,
          beInSearch: beInSearch ?? this.beInSearch,
          favoriteTagsIds: favoriteTagsIds ?? this.favoriteTagsIds,
          points: points ?? this.points);
}

final AutoSizeGroup _statsConstGroup = AutoSizeGroup();
