class UiSuggestPlaceModel {
  final String location;
  final String title;
  final String description;
  final DateTime dateTime;

  UiSuggestPlaceModel(
      {required this.location,
      required this.title,
      required this.description,
      required this.dateTime});

  @override
  String toString() {
    return '''----------------------------------------
    location: $location,
    title: $title,
    description: $description,
    dateTime: $dateTime
----------------------------------------''';
  }
}
