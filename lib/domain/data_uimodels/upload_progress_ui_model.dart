class UploadProgressUiModel {
  final int currentValue;
  final int totalValue;
  final String? title;

  UploadProgressUiModel({
    required this.currentValue,
    required this.totalValue,
    this.title,
  });
}
