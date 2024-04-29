import '../../../shuffle_components_kit.dart';

class UiMoodGameContentModel {
  final UiUniversalModel? todayGameContent;
  final List<UiUniversalModel>? tomorrowGameContent;
  final List<UiUniversalModel>? dayAfterTomorrowGameContent;
  final bool isVerifiedToRecieveReward;
  final String? activatedLevel;
  List<UiUniversalModel> passedCheckins;

  UiMoodGameContentModel(
      {this.todayGameContent,
      this.tomorrowGameContent,
      this.activatedLevel,
      this.dayAfterTomorrowGameContent,
      this.passedCheckins = const [],
      this.isVerifiedToRecieveReward = false});

  UiMoodGameContentModel copyWith(
      {UiUniversalModel? todayGameContent,
      List<UiUniversalModel>? tomorrowGameContent,
      List<UiUniversalModel>? dayAfterTomorrowGameContent,
      bool? isVerifiedToRecieveReward,
      List<UiUniversalModel>? passedCheckins,
      String? activatedLevel}) {
    return UiMoodGameContentModel(
        todayGameContent: todayGameContent ?? this.todayGameContent,
        tomorrowGameContent: tomorrowGameContent ?? this.tomorrowGameContent,
        dayAfterTomorrowGameContent: dayAfterTomorrowGameContent ?? this.dayAfterTomorrowGameContent,
        isVerifiedToRecieveReward: isVerifiedToRecieveReward ?? this.isVerifiedToRecieveReward,
        passedCheckins: passedCheckins ?? this.passedCheckins,
        activatedLevel: activatedLevel ?? this.activatedLevel);
  }

  int get totalStepsLength {
    int counter = 0;
    if (todayGameContent != null) {
      counter++;
    }
    if (tomorrowGameContent != null) {
      counter += tomorrowGameContent!.length;
    }
    if (dayAfterTomorrowGameContent != null) {
      counter += dayAfterTomorrowGameContent!.length;
    }
    return counter;
  }

  bool hasContent(int id, String type) {
    if (todayGameContent?.id == id && todayGameContent?.type == type) {
      return true;
    } else if (tomorrowGameContent?.any((element) => element.id == id && element.type == type) ?? false) {
      return true;
    } else if (dayAfterTomorrowGameContent?.any((element) => element.id == id && element.type == type) ?? false) {
      return true;
    }
    return false;
  }
}
