import 'package:shuffle_components_kit/domain/data_uimodels/content_short_ui_model.dart';

class UiModelDiscounts {
  final String buttonTitle;
  final String barcode;
  final ContentShortUiModel contentShortUiModel;
  final int offerId;

  UiModelDiscounts({
    required this.buttonTitle,
    required this.barcode,
    required this.contentShortUiModel,
    required this.offerId,
  });
}
