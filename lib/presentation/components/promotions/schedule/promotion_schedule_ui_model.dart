import 'package:shuffle_uikit/shuffle_uikit.dart';

class PromotionScheduleUiModel {
  final int? id;
  final ShowTimeType showTimeType;
  final ScheduleSetting scheduleSetting;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<MapEntry<String, TimeRange>>? hourlySchedule;

  const PromotionScheduleUiModel({
    required this.showTimeType,
    required this.scheduleSetting,
    this.startDate,
    this.endDate,
    this.hourlySchedule,
    this.id,
  });

  PromotionScheduleUiModel copyWith({
    ShowTimeType? showTimeType,
    ScheduleSetting? scheduleSetting,
    DateTime? startDate,
    DateTime? endDate,
    List<MapEntry<String, TimeRange>>? hourlySchedule,
    int? id,
  }) =>
      PromotionScheduleUiModel(
        showTimeType: showTimeType ?? this.showTimeType,
        scheduleSetting: scheduleSetting ?? this.scheduleSetting,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        hourlySchedule: hourlySchedule ?? this.hourlySchedule,
        id: id?? this.id,
      );
}

enum ShowTimeType { continuously, setStartEndDates }

extension LocalizationShowTimeType on ShowTimeType {
  String get showTimeTypeDescription {
    switch (this) {
      case ShowTimeType.continuously:
        return S.current.ContinuouslyPromoSchedule;
      case ShowTimeType.setStartEndDates:
        return S.current.SetStartEndDatesPromoSchedule;
    }
  }
}

enum ScheduleSetting { everyday, hourlySet }

extension LocalizationScheduleSetting on ScheduleSetting {
  String get scheduleSettingDescription {
    switch (this) {
      case ScheduleSetting.everyday:
        return S.current.EverydayPromoSchedule;
      case ScheduleSetting.hourlySet:
        return S.current.HourlyPromoSchedule;
    }
  }
}
