class UiPointsModel {
  final String? title;
  final int getPoints;
  final double actualSum;
  final double sum;
  final String? imagePath;
  final bool showStar;

  UiPointsModel({
    this.title,
    this.getPoints = 0,
    this.actualSum = 0,
    this.sum = 1,
    this.imagePath,
    this.showStar = false,
  });
}
