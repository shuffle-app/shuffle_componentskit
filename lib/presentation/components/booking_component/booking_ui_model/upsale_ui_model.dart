import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:image_picker/image_picker.dart';

class UpsaleUiModel {
  int id;
  BaseUiKitMedia? photo;
  String? description;
  String? limit;
  String? actualLimit;
  String? price;
  String? currency;
  XFile? photoFile;

  UpsaleUiModel({
    required this.id,
    this.photo,
    this.description,
    this.limit,
    this.actualLimit,
    this.price,
    this.currency,
    this.photoFile,
  });

  String? validateCreation({bool checkDate = false}) {
    if (photoFile == null) {
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
    BaseUiKitMedia? photo,
    String? description,
    String? limit,
    String? actualLimit,
    String? price,
    String? currency,
    XFile? photoFile,
  }) {
    return UpsaleUiModel(
      id: id ?? this.id,
      photo: photo ?? this.photo,
      description: description ?? this.description,
      limit: limit ?? this.limit,
      actualLimit: actualLimit ?? this.actualLimit,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      photoFile: photoFile ?? this.photoFile,
    );
  }
}
