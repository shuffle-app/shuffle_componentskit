import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_uikit/ui_models/places/base_ui_kit_media.dart';
import 'package:image_picker/image_picker.dart';

class SubsUiModel {
  int id;
  BaseUiKitMedia? photo;
  String? title;
  String? description;
  String? bookingLimit;
  String? actualbookingLimit;
  XFile? photoFile;

  SubsUiModel({
    required this.id,
    this.photo,
    this.title,
    this.description,
    this.bookingLimit,
    this.actualbookingLimit,
    this.photoFile,
  });

  String? validateCreation({bool checkDate = false}) {
    if (photoFile == null) {
      return S.current.XIsRequired(S.current.Photo);
    } else if (title == null) {
      return S.current.XIsRequired(S.current.Title);
    } else if (title != null && (title!.isEmpty || title!.length < 3)) {
      return S.current.XIsRequired(S.current.Title);
    } else if (description == null) {
      return S.current.XIsRequired(S.current.Description);
    } else if (description != null && (description!.isEmpty || description!.trim().isEmpty)) {
      return S.current.XIsRequired(S.current.Description);
    } else if (bookingLimit != null && bookingLimit!.isEmpty) {
      return S.current.XIsRequired(S.current.BookingLimit);
    } else if (bookingLimit != null && bookingLimit!.isNotEmpty) {
      final newValue = int.parse(bookingLimit!.replaceAll(' ', ''));
      if (newValue <= 0) {
        return S.current.XIsRequired(S.current.BookingLimit);
      }
      return null;
    } else if (bookingLimit == null) {
      return S.current.XIsRequired(S.current.BookingLimit);
    }
    return null;
  }

  SubsUiModel copyWith({
    int? id,
    BaseUiKitMedia? photo,
    String? title,
    String? description,
    String? bookingLimit,
    String? actualbookingLimit,
    XFile? photoFile,
  }) {
    return SubsUiModel(
      id: id ?? this.id,
      photo: photo ?? this.photo,
      title: title ?? this.title,
      description: description ?? this.description,
      bookingLimit: bookingLimit ?? this.bookingLimit,
      actualbookingLimit: actualbookingLimit ?? this.actualbookingLimit,
      photoFile: photoFile ?? this.photoFile,
    );
  }
}
