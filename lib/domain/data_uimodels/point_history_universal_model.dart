import 'package:shuffle_components_kit/domain/data_uimodels/content_short_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';

class PointHistoryUniversalModel {
  final ContentShortUiModel? contentShortUiModel;
  final UiModelViewHistoryAccrual? uiModelViewHistoryAccrual;

  PointHistoryUniversalModel({
    this.contentShortUiModel,
    this.uiModelViewHistoryAccrual,
  });

  factory PointHistoryUniversalModel.fromFavoritesMergeComponent(
      ContentShortUiModel uiModelFavoritesMergeComponent) {
    return PointHistoryUniversalModel(
        contentShortUiModel: uiModelFavoritesMergeComponent);
  }
  factory PointHistoryUniversalModel.fromViewHistoryAccrual(
      UiModelViewHistoryAccrual uiModelViewHistoryAccrual) {
    return PointHistoryUniversalModel(
        uiModelViewHistoryAccrual: uiModelViewHistoryAccrual);
  }
}
