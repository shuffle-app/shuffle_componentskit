import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_uikit/ui_models/places/base_ui_kit_media.dart';

class SubsUiModel {
  int id;
  BaseUiKitMedia? photo;
  String? title;
  String? description;
  String? bookingLimit;
  String? actualbookingLimit;

  SubsUiModel({
    required this.id,
    this.photo,
    this.title,
    this.description,
    this.bookingLimit,
    this.actualbookingLimit,
  });

  SubsUiModel copyWith({
    int? id,
    BaseUiKitMedia? photo,
    String? title,
    String? description,
    String? bookingLimit,
    String? actualbookingLimit,
  }) {
    return SubsUiModel(
      id: id ?? this.id,
      photo: photo ?? this.photo,
      title: title ?? this.title,
      description: description ?? this.description,
      bookingLimit: bookingLimit ?? this.bookingLimit,
      actualbookingLimit: actualbookingLimit ?? this.actualbookingLimit,
    );
  }
}
