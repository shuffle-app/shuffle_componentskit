import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class UserBookingsControlUiModel {
  final int id;
  final UiProfileModel? profile;
  final int tiketsCount;
  final int? productsCount;
  final RequestRefundUiModel? requestRefunUiModel;
  bool isSelected;

  UserBookingsControlUiModel({
    required this.id,
    required this.tiketsCount,
    this.profile,
    this.productsCount,
    this.requestRefunUiModel,
    this.isSelected = false,
  });

  UserBookingsControlUiModel copyWith({
    int? id,
    UiProfileModel? profile,
    int? tiketsCount,
    int? productsCount,
    RequestRefundUiModel? requestRefunUiModel,
    bool? isSelected,
  }) {
    return UserBookingsControlUiModel(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      tiketsCount: tiketsCount ?? this.tiketsCount,
      productsCount: productsCount ?? this.productsCount,
      requestRefunUiModel: requestRefunUiModel ?? this.requestRefunUiModel,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
