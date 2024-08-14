import 'bookings_place_or_even_ui_model.dart';

class BookingsEventUiModel {
  final int id;
  final String? title;
  final String? description;
  final List<BookingsPlaceOrEventUiModel>? events;
  BookingsEventUiModel({
    required this.id,
    this.title,
    this.description,
    this.events,
  });

  BookingsEventUiModel copyWith({
    int? id,
    String? title,
    String? description,
    List<BookingsPlaceOrEventUiModel>? events,
  }) {
    return BookingsEventUiModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      events: events ?? this.events,
    );
  }
}
