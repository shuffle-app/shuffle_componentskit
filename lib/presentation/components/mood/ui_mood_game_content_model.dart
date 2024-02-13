import '../../../shuffle_components_kit.dart';

class UiMoodGameContentModel {
  final UiUniversalModel? todayGameContent;
  final List<UiUniversalModel>? tomorrowGameContent;
  final List<UiUniversalModel>? dayAfterTomorrowGameContent;

  const UiMoodGameContentModel({
    this.todayGameContent,
    this.tomorrowGameContent,
    this.dayAfterTomorrowGameContent,
  });

  UiMoodGameContentModel copyWith({
    UiUniversalModel? todayGameContent,
    List<UiUniversalModel>? tomorrowGameContent,
    List<UiUniversalModel>? dayAfterTomorrowGameContent,
  }) {
    return UiMoodGameContentModel(
      todayGameContent: todayGameContent ?? this.todayGameContent,
      tomorrowGameContent: tomorrowGameContent ?? this.tomorrowGameContent,
      dayAfterTomorrowGameContent: dayAfterTomorrowGameContent ?? this.dayAfterTomorrowGameContent,
    );
  }
}
