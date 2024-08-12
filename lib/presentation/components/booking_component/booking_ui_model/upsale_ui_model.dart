import 'package:shuffle_uikit/shuffle_uikit.dart';

class UpsaleUiModel {
  int id;
  BaseUiKitMedia? photo;
  String? description;
  String? limit;
  String? actualLimit;
  String? price;
  String? currency;

  UpsaleUiModel({
    required this.id,
    this.photo,
    this.description,
    this.limit,
    this.actualLimit,
    this.price,
    this.currency,
  });

  UpsaleUiModel copyWith({
    int? id,
    BaseUiKitMedia? photo,
    String? description,
    String? limit,
    String? actualLimit,
    String? price,
    String? currency,
  }) {
    return UpsaleUiModel(
      id: id ?? this.id,
      photo: photo ?? this.photo,
      description: description ?? this.description,
      limit: limit ?? this.limit,
      actualLimit: actualLimit ?? this.actualLimit,
      price: price ?? this.price,
      currency: currency ?? this.currency,
    );
  }
}
