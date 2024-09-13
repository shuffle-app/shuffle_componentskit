import 'package:shuffle_uikit/shuffle_uikit.dart';

class UpsaleUiModel {
  int id;
  String? photoPath;
  String? description;
  String? limit;
  String? actualLimit;
  String? price;
  String? currency;

  UpsaleUiModel({
    required this.id,
    this.photoPath,
    this.description,
    this.limit,
    this.actualLimit,
    this.price,
    this.currency,
  });

  String? validateCreation({bool checkDate = false}) {
    if (photoPath == null || (photoPath?.isEmpty ?? true)) {
      return S.current.XIsRequired(S.current.Photo);
    } else if (description == null) {
      return S.current.XIsRequired(S.current.Description);
    } else if (description != null && (description!.isEmpty || description!.trim().isEmpty)) {
      return S.current.XIsRequired(S.current.Description);
    }
    return null;
  }

  UpsaleUiModel copyWith({
    int? id,
    String? photoPath,
    String? description,
    String? limit,
    String? actualLimit,
    String? price,
    String? currency,
  }) {
    return UpsaleUiModel(
      id: id ?? this.id,
      photoPath: photoPath ?? this.photoPath,
      description: description ?? this.description,
      limit: limit ?? this.limit,
      actualLimit: actualLimit ?? this.actualLimit,
      price: price ?? this.price,
      currency: currency ?? this.currency,
    );
  }
}
