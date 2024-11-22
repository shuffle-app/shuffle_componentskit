import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiProfileModel {
  final int? id;
  final VoidCallback? onShare;
  final VoidCallback? onPointsDetails;
  final VoidCallback? onBalanceDetails;
  final VoidCallback? onCalendarTap;
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
  final bool following;
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
  final ValueChanged<String?>? onSocialLinksPressed;
  final int? points;
  final int? balance;
  final bool? beInSearch;
  final int? updatesCount;
  final DateTime? userCreatedAt;

  ProfileCard cardWidget(ProfileStats? stats) {
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
      proStats: stats,
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
      profileWidgets: [
        ProfileContentWidget(
          title: S.current.ToPlan,
          group: _statsConstGroup,
          onCalendarTap: onCalendarTap,
          showCalendar: true,
        ),
        ProfileContentWidget(
          title: S.current.HallOfFame,
          group: _statsConstGroup,
          showHallOfFrame: true,
          achievements: achievements,
          onViewAllAchievements: onViewAllAchievements,
        ),
      ],
    );
  }

  ProfileCard get cardWidgetPublic {
    if (userTileType == UserTileType.pro) {
      return ProfileCard(
        profileCardBody: ProPublicProfileCardBody(
          registrationDate: userCreatedAt ?? DateTime.now(),
          onSocialLinksPressed: onSocialLinksPressed,
          socialLinks: socialLinks,
          name: name,
          nickname: nickname,
          avatarUrl: avatarUrl,
          interests: allInterests,
          matchingInterests: matchingInterests,
          onShare: onShare,
          onFollow: onFollow,
          phone: phone,
          email: email,
          following: following,
          followers: followers ?? 0,
        ),
        badge: const ProMemberPlate(),
      );
    } else {
      return const ProfileCard();
    }
  }

  UiProfileModel({
    this.id,
    this.onShare,
    this.onPointsDetails,
    this.onBalanceDetails,
    this.onCalendarTap,
    this.onDonate,
    this.onCustomDonate,
    this.mindsetId,
    this.showSupportShuffle = false,
    this.following = false,
    this.onFollow,
    this.matchingInterests,
    this.userCreatedAt,
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
    this.balance,
    this.phone,
    this.updatesCount,
    this.onSocialLinksPressed,
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
    VoidCallback? onPointsDetails,
    VoidCallback? onBalanceDetails,
    VoidCallback? onCalendarTap,
    bool? following,
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
    int? balance,
    VoidCallback? onCustomDonate,
    bool? beInSearch,
    int? id,
    DateTime? userCreatedAt,
    ValueChanged<String?>? onSocialLinksPressed,
  }) =>
      UiProfileModel(
        id: id ?? this.id,
        onShare: onShare ?? this.onShare,
        onPointsDetails: onPointsDetails ?? this.onPointsDetails,
        onBalanceDetails: onBalanceDetails ?? this.onBalanceDetails,
        onCalendarTap: onCalendarTap ?? this.onCalendarTap,
        nickname: nickname ?? this.nickname,
        name: name ?? this.name,
        description: description ?? this.description,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        userCredo: userCredo ?? this.userCredo,
        following: following ?? this.following,
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
        points: points ?? this.points,
        balance: balance ?? this.balance,
        userCreatedAt: userCreatedAt ?? this.userCreatedAt,
        onSocialLinksPressed: onSocialLinksPressed ?? this.onSocialLinksPressed,
      );

  UiOwnerModel asOwnerModel([VoidCallback? onTap]) =>
      UiOwnerModel(id: id!, username: nickname, logo: avatarUrl, name: name!, type: userTileType, onTap: onTap);
}

final AutoSizeGroup _statsConstGroup = AutoSizeGroup();
