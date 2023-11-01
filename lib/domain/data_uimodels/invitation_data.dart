import 'package:shuffle_components_kit/domain/data_uimodels/hangout_recommendation.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class InvitationData {
  final HangoutRecommendation? user;
  final int placeId;
  final String placeName;
  final String placePhotoUrl;
  final List<UiKitTag> placeTags;

  InvitationData({
    this.user,
    required this.placeId,
    required this.placePhotoUrl,
    required this.placeName,
    required this.placeTags,
  });
}
