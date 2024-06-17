import 'package:shuffle_components_kit/presentation/components/components.dart';

class PointHistoryUniversalModel {
  final UiModelFavoritesMergeComponent? uiModelFavoritesMergeComponent;
  final UiModelViewHistoryAccrual? uiModelViewHistoryAccrual;

  PointHistoryUniversalModel({
    this.uiModelFavoritesMergeComponent,
    this.uiModelViewHistoryAccrual,
  });

  factory PointHistoryUniversalModel.fromFavoritesMergeComponent(
      UiModelFavoritesMergeComponent uiModelFavoritesMergeComponent) {
    return PointHistoryUniversalModel(
        uiModelFavoritesMergeComponent: uiModelFavoritesMergeComponent);
  }
  factory PointHistoryUniversalModel.fromViewHistoryAccrual(
      UiModelViewHistoryAccrual uiModelViewHistoryAccrual) {
    return PointHistoryUniversalModel(
        uiModelViewHistoryAccrual: uiModelViewHistoryAccrual);
  }
}
