import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UiProfileModel {
  final String? nickname;
  final String? name;
  final String? description;
  final String? avatarUrl;
  final String? userCredo;
  final int? followers;
  final VoidCallback? onFollow;
  final List<String>? interests;
  final List<String>? favorites;
  final List<String>? matchingInterests;

  ProfileCard get cardWidget {
    AutoSizeGroup g = AutoSizeGroup();

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
      profileStats: [
        UiKitStats(
          title: 'Balance',
          value: '993 \$', actionButton: SmallOrdinaryButton(text: 'details'.toUpperCase(), group: g,),
        ),
        UiKitStats(
            title: 'Points',
            value: '553', actionButton: SmallOrdinaryButton(text: 'spent'.toUpperCase(), group: g,)
        ),

      ],
    );
  }

  UiProfileModel({
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
}
