import 'package:shuffle_uikit/shuffle_uikit.dart';

class ReviewUiModel {
  final int rating;
  final String reviewDescription;
  final DateTime reviewTime;
  final UserTileType userType;
  final bool? isPersonalRespect;
  final bool? isAddToPersonalTop;
  final String? personalTopTitle;


  ReviewUiModel({
    required this.rating,
    required this.reviewDescription,
    required this.reviewTime,
    required this.userType,
    this.isPersonalRespect,
    this.isAddToPersonalTop,
    this.personalTopTitle,
  });


  @override
  String toString() {

    return '''
    rating: $rating,
    reviewDescription: $reviewDescription,
    reviewTime: $reviewTime,
    userType: $userType,
    isPersonalRespect: $isPersonalRespect,
    isAddToPersonalTop: $isAddToPersonalTop,
    personalTopTitle: $personalTopTitle
    ''';
  }
}
