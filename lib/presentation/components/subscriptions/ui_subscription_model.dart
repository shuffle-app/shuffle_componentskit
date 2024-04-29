import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiSubscriptionModel {
  final String userName;
  final String userAvatarUrl;
  final String nickname;
  final List<SubscriptionOfferModel> offers;
  final List<String> subscriptionFeatures;
  final UserTileType userType;
  final Widget? additionalInfo;

  UiSubscriptionModel({
    required this.userName,
    required this.subscriptionFeatures,
    required this.userAvatarUrl,
    required this.nickname,
    required this.offers,
    required this.userType,
    this.additionalInfo,
  });
}
