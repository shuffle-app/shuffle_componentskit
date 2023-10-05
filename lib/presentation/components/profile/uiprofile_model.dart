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

  ProfileCard get cardWidget {
    AutoSizeGroup group = AutoSizeGroup();

    return ProfileCard(
      nickname: nickname,
      name: name,
      description: description,
      avatarUrl: avatarUrl,
      followers: followers,
      interests: interests,
      onFollow: onFollow,
      matchingInterests: matchingInterests,
      profileType: ProfileCardType.personal,
      showSupportShuffle: showSupportShuffle,
      onDonate: onDonate,
      profileStats: [
        UiKitStats(
          title: 'Balance',
          value: '993 \$',
          actionButton: SmallOrdinaryButton(
            text: 'details'.toUpperCase(),
            group: group,
          ),
        ),
        UiKitStats(
            title: 'Points',
            value: '553',
            actionButton: SmallOrdinaryButton(
              text: 'spent'.toUpperCase(),
              group: group,
            )),
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
    this.followers,
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
      );
}
