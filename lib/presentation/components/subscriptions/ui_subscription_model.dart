import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiSubscriptionModel {
  final String userName;
  final String userAvatarUrl;
  final String nickname;
  final List<SubscriptionOfferModel> offers;
  final UserTileType userType;

  UiSubscriptionModel({
    required this.userName,
    required this.userAvatarUrl,
    required this.nickname,
    required this.offers,
    required this.userType,
  });
}
