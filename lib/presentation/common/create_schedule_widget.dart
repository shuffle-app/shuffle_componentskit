import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CreateScheduleWidget extends StatefulWidget {
  final List<UiScheduleModel> availableTemplates;
  final ValueChanged<UiScheduleModel>? onTemplateCreated;
  final ValueChanged<UiScheduleModel>? onScheduleCreated;

  const CreateScheduleWidget({super.key, this.availableTemplates = const [], this.onTemplateCreated, this.onScheduleCreated});

  @override
  State<CreateScheduleWidget> createState() => _CreateScheduleWidgetState();
}

class _CreateScheduleWidgetState extends State<CreateScheduleWidget> {

  ScheduleType selectedInputType = ScheduleType.weekly;

  UiScheduleModel? scheduleModel;
  UiScheduleModel? selectedTemplate;

  final listKey = GlobalKey<AnimatedListState>();

  void onAddButtonPressed() {
    // listKey.currentState!.a
  }

  void onMinusButtonPressed() {

  }

  @override
  Widget build(BuildContext context) {
    return BlurredAppBarPage(
      autoImplyLeading: true,
      animatedListKey: listKey,
      childrenCount: 4,
      childrenPadding: EdgeInsets.symmetric(
          horizontal: SpacingFoundation.horizontalSpacing12, vertical: SpacingFoundation.verticalSpacing4),
      childrenBuilder: (context, index) {
        if (index == 0) {
          return UiKitBaseDropdown<ScheduleType>(
            items: ScheduleType.values,
            value: selectedInputType,
            onChanged: (ScheduleType? scheduleType) {
              if(scheduleType!= null) {
                setState(() {
                  selectedInputType = scheduleType;
                });
              }
            },
          );
        } else if (index == 1) {
          if(widget.availableTemplates.isNotEmpty) {
            return UiKitBaseDropdown<UiScheduleModel>(
              items: widget.availableTemplates,
              value: selectedTemplate,
              onChanged: (UiScheduleModel? selectedTemplate) {
                if(selectedTemplate!= null) {
                  setState(() {
                    this.selectedTemplate = selectedTemplate;
                  });
                }
              },
            );
          }
        }
      },
    );
  }
}

enum ScheduleType {
  weekly,
  dayTime,
  dayRangeTime
}

abstract class UiScheduleModel {
  DateTime getDateFromKey(String key) {
    return DateFormat('yyyy-MM-dd').parse(key);
  }

  String convertDateToKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  DateTimeRange getDateRangeFromKey(String key) {
    return DateTimeRange(
      start: getDateFromKey(key
          .split('/')
          .first),
      end: getDateFromKey(key
          .split('/')
          .last),
    );
  }

  String convertDateRangeToKey(DateTimeRange range) {
    return '${convertDateToKey(range.start)}/${convertDateToKey(range.end)}';
  }
}

class UiScheduleTimeModel extends UiScheduleModel {
  final Map<String, List<TimeOfDay>> weeklySchedule;

  UiScheduleTimeModel({required this.weeklySchedule});
}

class UiScheduleDatesModel extends UiScheduleModel {
  final Map<String, List<TimeOfDay>> dailySchedule;

  UiScheduleDatesModel({required this.dailySchedule});
}

class UiScheduleDatesRangeModel extends UiScheduleModel {
  final Map<String, List<TimeOfDay>> dailySchedule;

  UiScheduleDatesRangeModel({required this.dailySchedule});
}
