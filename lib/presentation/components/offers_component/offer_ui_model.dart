class OfferUiModel {
  final int id;
  final String? title;
  final int? pointPrice;
  final String? iconPath;
  final List<DateTime?>? selectedDates;
  final bool notifyTheAudience;
  final bool isLaunched;
  final DateTime? isLaunchedDate;

  OfferUiModel({
    required this.id,
    this.title,
    this.pointPrice,
    this.iconPath,
    this.selectedDates,
    this.notifyTheAudience = false,
    this.isLaunched = false,
    this.isLaunchedDate,
  });

  OfferUiModel copyWith({
    int? id,
    String? title,
    int? pointPrice,
    String? iconPath,
    List<DateTime?>? selectedDates,
    bool? notifyTheAudience,
    bool? isLaunched,
    DateTime? isLaunchedDate,
  }) {
    return OfferUiModel(
      id: id ?? this.id,
      title: title ?? this.title,
      pointPrice: pointPrice ?? this.pointPrice,
      iconPath: iconPath ?? this.iconPath,
      selectedDates: selectedDates ?? this.selectedDates,
      notifyTheAudience: notifyTheAudience ?? this.notifyTheAudience,
      isLaunched: isLaunched ?? this.isLaunched,
      isLaunchedDate: isLaunchedDate ?? this.isLaunchedDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OfferUiModel &&
        other.id == id &&
        other.title == title &&
        other.pointPrice == pointPrice &&
        other.iconPath == iconPath &&
        other.selectedDates == selectedDates &&
        other.notifyTheAudience == notifyTheAudience &&
        other.isLaunched == isLaunched &&
        other.isLaunchedDate == isLaunchedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        pointPrice.hashCode ^
        iconPath.hashCode ^
        selectedDates.hashCode ^
        notifyTheAudience.hashCode ^
        isLaunched.hashCode ^
        isLaunchedDate.hashCode;
  }

  @override
  String toString() {
    return 'OfferUiModel(id: $id, title: $title, pointPrice: $pointPrice, iconPath: $iconPath, selectedDates: $selectedDates, notifyTheAudience: $notifyTheAudience, isLaunched: $isLaunched, isLaunchedDate: $isLaunchedDate)';
  }
}
