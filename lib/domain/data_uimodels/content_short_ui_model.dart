import 'package:shuffle_uikit/shuffle_uikit.dart';

class ContentShortUiModel {
  final String? title;
  final String? imageUrl;
  final String? contentTitle;
  final List<UiKitTag>? tags;
  final DateTime? periodFrom;
  final DateTime? periodTo;

  ContentShortUiModel({
    this.title,
    this.imageUrl,
    this.contentTitle,
    this.periodFrom,
    this.periodTo,
    this.tags,
  });
}
