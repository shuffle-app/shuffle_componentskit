import 'package:shuffle_components_kit/presentation/components/notification_offer_reminder_components/users_of_offer.dart';

class UniversalNotOfferRemUiModel {
  final int id;
  final String? title;
  final int? pointPrice;
  final String? iconPath;
  final String? imagePath;
  final List<DateTime?>? selectedDates;
  final bool notifyTheAudience;
  final bool isLaunched;
  final DateTime? isLaunchedDate;
  final bool isOffer;
  final List<UsersOfOffer>? userOfOffer;

  UniversalNotOfferRemUiModel({
    required this.id,
    this.title,
    this.pointPrice,
    this.iconPath,
    String? imagePath,
    this.selectedDates,
    this.notifyTheAudience = false,
    this.isLaunched = false,
    this.isLaunchedDate,
    this.isOffer = false,
    this.userOfOffer,
  }) : imagePath = iconPath != null ? null : imagePath;

  UniversalNotOfferRemUiModel copyWith({
    int? id,
    String? title,
    int? pointPrice,
    String? iconPath,
    String? imagePath,
    List<DateTime?>? selectedDates,
    bool? notifyTheAudience,
    bool? isLaunched,
    DateTime? isLaunchedDate,
    bool? isOffer,
    List<UsersOfOffer>? userOfOffer,
  }) {
    return UniversalNotOfferRemUiModel(
      id: id ?? this.id,
      title: title ?? this.title,
      pointPrice: pointPrice ?? this.pointPrice,
      iconPath: iconPath ?? (imagePath != null ? null : this.iconPath),
      imagePath: imagePath ?? (iconPath != null ? null : this.imagePath),
      selectedDates: selectedDates ?? this.selectedDates,
      notifyTheAudience: notifyTheAudience ?? this.notifyTheAudience,
      isLaunched: isLaunched ?? this.isLaunched,
      isLaunchedDate: isLaunchedDate ?? this.isLaunchedDate,
      isOffer: isOffer ?? this.isOffer,
      userOfOffer: userOfOffer ?? this.userOfOffer,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UniversalNotOfferRemUiModel &&
        other.id == id &&
        other.title == title &&
        other.pointPrice == pointPrice &&
        other.iconPath == iconPath &&
        other.selectedDates == selectedDates &&
        other.notifyTheAudience == notifyTheAudience &&
        other.isLaunched == isLaunched &&
        other.isLaunchedDate == isLaunchedDate &&
        other.isOffer == isOffer;
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
        isLaunchedDate.hashCode ^
        isOffer.hashCode;
  }

  @override
  String toString() {
    return 'OfferUiModel(id: $id, title: $title, pointPrice: $pointPrice, iconPath: $iconPath, selectedDates: $selectedDates, notifyTheAudience: $notifyTheAudience, isLaunched: $isLaunched, isLaunchedDate: $isLaunchedDate)';
  }
}
