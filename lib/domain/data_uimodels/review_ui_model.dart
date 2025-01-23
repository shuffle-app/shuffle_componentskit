import 'package:shuffle_uikit/shuffle_uikit.dart';

class ReviewUiModel {
  final int id;
  final int? rating;
  final String reviewDescription;
  final DateTime reviewTime;
  final bool? isPersonalRespect;
  final bool? isAddToPersonalTop;
  final String? personalTopTitle;
  final List<BaseUiKitMedia> media;

  ReviewUiModel({
    required this.id,
    this.rating,
    required this.reviewDescription,
    required this.reviewTime,
    this.isPersonalRespect,
    this.isAddToPersonalTop,
    this.personalTopTitle,
    this.media = const [],
  });

  @override
  String toString() {
    return '''
    id: $id,
    rating: $rating,
    reviewDescription: $reviewDescription,
    reviewTime: $reviewTime,
    isPersonalRespect: $isPersonalRespect,
    isAddToPersonalTop: $isAddToPersonalTop,
    personalTopTitle: $personalTopTitle
    ''';
  }
}
