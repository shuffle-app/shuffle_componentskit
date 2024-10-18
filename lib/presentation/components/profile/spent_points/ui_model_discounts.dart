import 'package:shuffle_components_kit/domain/data_uimodels/content_short_ui_model.dart';

class UiModelDiscounts {
  final String buttonTitle;
  final String barcode;
  final ContentShortUiModel? contentShortUiModel;

  UiModelDiscounts({
    required this.buttonTitle,
    required this.barcode,
    this.contentShortUiModel,
  });

  UiModelDiscounts copyWith({
    String? buttonTitle,
    String? barcode,
    ContentShortUiModel? contentShortUiModel,
  }) {
    return UiModelDiscounts(
      buttonTitle: buttonTitle ?? this.buttonTitle,
      barcode: barcode ?? this.barcode,
      contentShortUiModel: contentShortUiModel ?? this.contentShortUiModel,
    );
  }
}
