import 'package:shuffle_uikit/shuffle_uikit.dart';

class UpsaleUiModel {
  BaseUiKitMedia? photo;
  String? description;
  String? limit;
  String? actualLimit;
  String? price;
  String? currency;

  UpsaleUiModel({
    this.photo,
    this.description,
    this.limit,
    this.actualLimit,
    this.price,
    this.currency,
  });

  UpsaleUiModel copyWith({
    BaseUiKitMedia? photo,
    String? description,
    String? limit,
    String? actualLimit,
    String? price,
    String? currency,
  }) {
    return UpsaleUiModel(
      photo: photo ?? this.photo,
      description: description ?? this.description,
      limit: limit ?? this.limit,
      actualLimit: actualLimit ?? this.actualLimit,
      price: price ?? this.price,
      currency: currency ?? this.currency,
    );
  }
}
