import 'package:shuffle_components_kit/presentation/components/event/uievent_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UniqueStatisticsModel {
  final ProgressBarModel ratingBarProgress;
  final ProgressBarModel interestBarProgress;
  final AgeSegmentModel mostActiveAgeSegment;
  final UiKitPieChartData viewSourcesData;
  final List<String>? topEventTitles;
  final DateTime? topEventsDate;
  final int? ratingInCategory;
  final int? ratingAmongAllContent;
  final String? theMostActiveAttendanceDay;
  final UiEventModel? topEvent;

  UniqueStatisticsModel({
    required this.ratingBarProgress,
    required this.interestBarProgress,
    required this.mostActiveAgeSegment,
    required this.viewSourcesData,
    this.topEventTitles,
    this.topEventsDate,
    this.ratingInCategory,
    this.ratingAmongAllContent,
    this.theMostActiveAttendanceDay,
    this.topEvent,
  });

  factory UniqueStatisticsModel.empty() => UniqueStatisticsModel(
        ratingBarProgress: ProgressBarModel.empty(),
        interestBarProgress: ProgressBarModel.empty(),
        mostActiveAgeSegment: AgeSegmentModel.empty(),
        viewSourcesData: UiKitPieChartData.empty(),
        topEventTitles: [],
        topEventsDate: DateTime.now(),
      );
}

class AgeSegmentModel {
  final String gender;
  final String name;
  final List<String> interests;

  AgeSegmentModel({
    required this.gender,
    required this.name,
    required this.interests,
  });

  factory AgeSegmentModel.empty() => AgeSegmentModel(
        gender: '',
        name: '',
        interests: [],
      );
}

class ProgressBarModel {
  final double value;
  final double maxValue;
  final String title;

  ProgressBarModel({
    required this.value,
    required this.maxValue,
    required this.title,
  });

  factory ProgressBarModel.empty() => ProgressBarModel(
        value: 0,
        maxValue: 0,
        title: '',
      );
}
