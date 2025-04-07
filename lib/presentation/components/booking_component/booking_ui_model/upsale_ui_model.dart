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
    } else if (description == null || (description?.isEmpty ?? true)) {
      return S.current.XIsRequired(S.current.Description);
    } else if (limit != null && limit!.isEmpty) {
      return S.current.XIsRequired(S.current.BookingLimit);
    } else if (limit != null && limit!.isNotEmpty) {
      final cleanedLimit = limit!.replaceAll(RegExp(r'[^\d]'), '').trim();
      final newValue = int.tryParse(cleanedLimit.replaceAll(' ', '').trim());
      if ((newValue ?? 0) <= 0) {
        return S.current.XIsRequired(S.current.BookingLimit);
      }
      return null;
    } else if (limit == null) {
      return S.current.XIsRequired(S.current.BookingLimit);
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photoPath': photoPath,
      'description': description,
      'limit': limit,
      'actualLimit': actualLimit,
      'price': price,
      'currency': currency,
    };
  }

  static UpsaleUiModel fromMap(Map<String, dynamic> map) {
    return UpsaleUiModel(
      id: map['id'],
      photoPath: map['photoPath'],
      description: map['description'],
      limit: map['limit'],
      actualLimit: map['actualLimit'],
      price: map['price'],
      currency: map['currency'],
    );
  }
}
