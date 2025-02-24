import 'package:shuffle_uikit/localization/l10n.dart';

class RefresherUiModel {
  final int id;
  final bool oneWeekSelected;
  final bool oneDaySelected;
  final bool oneHourSelected;
  final String? weekText;
  final String? dayText;
  final String? hourText;
  final String? contentTitle;
  final String? contentImage;
  final bool isLaunched;
  final DateTime? isLaunchedDate;

  RefresherUiModel({
    required this.id,
    this.oneWeekSelected = false,
    this.oneDaySelected = false,
    this.oneHourSelected = false,
    this.weekText,
    this.dayText,
    this.hourText,
    this.contentTitle,
    this.contentImage,
    this.isLaunched = false,
    this.isLaunchedDate,
  });

  String? validateCreation() {
    if (oneWeekSelected && (weekText == null || weekText!.trim().isEmpty)) {
      return S.current.XIsRequired(S.current.TextForTheWeek);
    } else if (oneDaySelected && (dayText == null || dayText!.trim().isEmpty)) {
      return S.current.XIsRequired(S.current.TextForTheDay);
    } else if (oneHourSelected && (hourText == null || hourText!.trim().isEmpty)) {
      return S.current.XIsRequired(S.current.TextInAnHour);
    } else if (!oneWeekSelected && !oneDaySelected && !oneHourSelected) {
      return S.current.RefresherCannotBeEmpty;
    }

    return null;
  }

  RefresherUiModel copyWith({
    int? id,
    bool? oneWeekSelected,
    bool? oneDaySelected,
    bool? oneHourSelected,
    String? weekText,
    String? dayText,
    String? hourText,
    String? contentTitle,
    String? contentImage,
    bool? isLaunched,
    DateTime? isLaunchedDate,
  }) {
    return RefresherUiModel(
      id: id ?? this.id,
      oneWeekSelected: oneWeekSelected ?? this.oneWeekSelected,
      oneDaySelected: oneDaySelected ?? this.oneDaySelected,
      oneHourSelected: oneHourSelected ?? this.oneHourSelected,
      weekText: weekText ?? this.weekText,
      dayText: dayText ?? this.dayText,
      hourText: hourText ?? this.hourText,
      contentTitle: contentTitle ?? this.contentTitle,
      contentImage: contentImage ?? this.contentImage,
      isLaunched: isLaunched ?? this.isLaunched,
      isLaunchedDate: isLaunchedDate ?? this.isLaunchedDate,
    );
  }

  @override
  String toString() {
    return 'RefresherUiModel('
        'id: $id, '
        'oneWeekSelected: $oneWeekSelected, '
        'oneDaySelected: $oneDaySelected, '
        'oneHourSelected: $oneHourSelected, '
        'weekText: $weekText, '
        'dayText: $dayText, '
        'hourText: $hourText, '
        'contentTitle: $contentTitle, '
        'contentImage: $contentImage, '
        'isLaunched: $isLaunched, '
        'isLaunchedDate: $isLaunchedDate'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RefresherUiModel &&
        other.id == id &&
        other.oneWeekSelected == oneWeekSelected &&
        other.oneDaySelected == oneDaySelected &&
        other.oneHourSelected == oneHourSelected &&
        other.weekText == weekText &&
        other.dayText == dayText &&
        other.hourText == hourText &&
        other.contentTitle == contentTitle &&
        other.contentImage == contentImage &&
        other.isLaunched == isLaunched &&
        other.isLaunchedDate == isLaunchedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        oneWeekSelected.hashCode ^
        oneDaySelected.hashCode ^
        oneHourSelected.hashCode ^
        weekText.hashCode ^
        dayText.hashCode ^
        hourText.hashCode ^
        contentTitle.hashCode ^
        contentImage.hashCode ^
        isLaunched.hashCode ^
        isLaunchedDate.hashCode;
  }
}
