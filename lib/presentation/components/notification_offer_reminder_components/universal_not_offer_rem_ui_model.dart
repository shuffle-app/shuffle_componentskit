import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/localization/l10n.dart';

class UniversalNotOfferRemUiModel {
  final int id;
  final String? title;
  final int? pointPrice;
  final String? iconPath;
  final int? iconId;
  final List<DateTime?>? selectedDates;
  final bool notifyTheAudience;
  final bool isLaunched;
  final DateTime? isLaunchedDate;
  final bool isOffer;
  final List<UsersOfOffer>? userOfOffer;
  final TicketIssueStatus? status;
  final String? imagePath;
  final bool isPromo;
  final String? type;

  const UniversalNotOfferRemUiModel({
    required this.id,
    this.title,
    this.pointPrice,
    this.iconPath,
    this.selectedDates,
    this.notifyTheAudience = false,
    this.isLaunched = false,
    this.isLaunchedDate,
    this.isOffer = false,
    this.userOfOffer,
    this.iconId,
    this.status,
    this.imagePath,
    this.isPromo = false,
    this.type,
  });

  UniversalNotOfferRemUiModel copyWith({
    int? id,
    String? title,
    int? pointPrice,
    String? iconPath,
    List<DateTime?>? selectedDates,
    bool? notifyTheAudience,
    bool? isLaunched,
    DateTime? isLaunchedDate,
    bool? isOffer,
    List<UsersOfOffer>? userOfOffer,
    int? iconId,
    TicketIssueStatus? status,
    String? imagePath,
    bool? isPromo,
    String? type,
  }) {
    return UniversalNotOfferRemUiModel(
      id: id ?? this.id,
      title: title ?? this.title,
      pointPrice: pointPrice ?? this.pointPrice,
      iconPath: iconPath ?? this.iconPath,
      selectedDates: selectedDates ?? this.selectedDates,
      notifyTheAudience: notifyTheAudience ?? this.notifyTheAudience,
      isLaunched: isLaunched ?? this.isLaunched,
      isLaunchedDate: isLaunchedDate ?? this.isLaunchedDate,
      isOffer: isOffer ?? this.isOffer,
      userOfOffer: userOfOffer ?? this.userOfOffer,
      iconId: iconId ?? this.iconId,
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      isPromo: isPromo ?? this.isPromo,
      type: type ?? this.type,
    );
  }

  String? validateCreation() {
    if (iconPath == null || iconPath!.isEmpty) {
      return S.current.XIsRequired(S.current.Icon);
    }

    return null;
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
        other.isOffer == isOffer &&
        other.iconId == iconId &&
        other.imagePath == imagePath &&
        other.isPromo == isPromo &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode +
        title.hashCode +
        pointPrice.hashCode +
        iconPath.hashCode +
        selectedDates.hashCode +
        notifyTheAudience.hashCode +
        isLaunched.hashCode +
        isLaunchedDate.hashCode +
        isOffer.hashCode +
        iconId.hashCode +
        imagePath.hashCode +
        isPromo.hashCode +
        type.hashCode;
  }

  @override
  String toString() {
    return 'OfferUiModel(id: $id, title: $title, pointPrice: $pointPrice, iconId: $iconId, selectedDates: $selectedDates, notifyTheAudience: $notifyTheAudience, isLaunched: $isLaunched, isLaunchedDate: $isLaunchedDate, imagePath : $imagePath, isPromo: $isPromo, status: $status)';
  }
}
