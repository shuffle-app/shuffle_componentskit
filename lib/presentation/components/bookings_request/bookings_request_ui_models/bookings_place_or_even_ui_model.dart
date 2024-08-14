import 'user_item_ui_model.dart';

class BookingsPlaceOrEventUiModel {
  final int id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final List<UserItemUiModel>? usersList;
  BookingsPlaceOrEventUiModel({
    required this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.usersList,
  });

  BookingsPlaceOrEventUiModel copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
    List<UserItemUiModel>? usersList,
  }) {
    return BookingsPlaceOrEventUiModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      usersList: usersList ?? this.usersList,
    );
  }
}
