import 'package:shuffle_uikit/shuffle_uikit.dart';

class SubsUiModel {
  int id;
  String? photoPath;
  String? title;
  String? description;
  String? bookingLimit;
  String? actualbookingLimit;

  SubsUiModel({
    required this.id,
    this.photoPath,
    this.title,
    this.description,
    this.bookingLimit,
    this.actualbookingLimit,
  });

  String? validateCreation({bool checkDate = false}) {
    if (photoPath == null || (photoPath?.isEmpty ?? true)) {
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
    String? photoPath,
    String? title,
    String? description,
    String? bookingLimit,
    String? actualbookingLimit,
  }) {
    return SubsUiModel(
      id: id ?? this.id,
      photoPath: photoPath ?? this.photoPath,
      title: title ?? this.title,
      description: description ?? this.description,
      bookingLimit: bookingLimit ?? this.bookingLimit,
      actualbookingLimit: actualbookingLimit ?? this.actualbookingLimit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photoPath': photoPath,
      'title': title,
      'description': description,
      'bookingLimit': bookingLimit,
      'actualbookingLimit': actualbookingLimit,
    };
  }

  static SubsUiModel fromMap(Map<String, dynamic> map) {
    return SubsUiModel(
      id: map['id'] as int,
      photoPath: map['photoPath'] as String?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      bookingLimit: map['bookingLimit'] as String?,
      actualbookingLimit: map['actualbookingLimit'] as String?,
    );
  }
}
