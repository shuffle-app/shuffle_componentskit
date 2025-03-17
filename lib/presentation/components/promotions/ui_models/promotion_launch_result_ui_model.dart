class PromotionLaunchResultUiModel {
  final String title;
  final String? popOverText;
  final int toDayCount;
  final int yesterdayCount;

  PromotionLaunchResultUiModel({
    required this.title,
    this.popOverText,
    this.toDayCount = 0,
    this.yesterdayCount = 0,
  });
}
