class ReviewUiModel {
  final int? rating;
  final String reviewDescription;
  final DateTime reviewTime;
  final bool? isPersonalRespect;
  final bool? isAddToPersonalTop;
  final String? personalTopTitle;


  ReviewUiModel({
    this.rating,
    required this.reviewDescription,
    required this.reviewTime,
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
    isPersonalRespect: $isPersonalRespect,
    isAddToPersonalTop: $isAddToPersonalTop,
    personalTopTitle: $personalTopTitle
    ''';
  }
}
