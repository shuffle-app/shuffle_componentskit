import 'user_bookings_control_ui_molde.dart';

class BookingsPlaceOrEventUiModel {
  final int id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final List<UserBookingsControlUiModel>? users;
  final List<BookingsPlaceOrEventUiModel>? events;

  BookingsPlaceOrEventUiModel({
    required this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.users,
    this.events,
  });

  BookingsPlaceOrEventUiModel copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
    List<UserBookingsControlUiModel>? users,
  }) {
    return BookingsPlaceOrEventUiModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      users: users ?? this.users,
    );
  }
}
