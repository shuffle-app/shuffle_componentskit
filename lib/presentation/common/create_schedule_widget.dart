import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/services/navigation_service/navigation_key.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CreateScheduleWidget extends StatefulWidget {
  final List<UiScheduleModel> availableTemplates;
  final ValueChanged<UiScheduleModel>? onTemplateCreated;
  final ValueChanged<UiScheduleModel>? onScheduleCreated;

  const CreateScheduleWidget(
      {super.key, this.availableTemplates = const [], this.onTemplateCreated, this.onScheduleCreated});

  @override
  State<CreateScheduleWidget> createState() => _CreateScheduleWidgetState();
}

class _CreateScheduleWidgetState extends State<CreateScheduleWidget> {
  // ScheduleType selectedInputType = ScheduleType.weekly;
  late final initialItemsCount;
  String? selectedScheduleName;

  UiScheduleModel? scheduleModel;

  final listKey = GlobalKey<SliverAnimatedListState>();

  @override
  void initState() {
    initialItemsCount = widget.availableTemplates.isEmpty ? 2 : 3;
    // scheduleModel = UiScheduleTimeModel(weeklySchedule: List.empty(growable: true));
    super.initState();
  }

  void onAddButtonPressed() {
    listKey.currentState!.insertItem(initialItemsCount + scheduleModel!.itemsCount - 1);
  }

  void onMinusButtonPressed() {
    listKey.currentState!.removeItem(initialItemsCount + scheduleModel!.itemsCount - 1 - 1, (context, animation) {
      return ScaleTransition(scale: animation, child: const SizedBox());
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheduleTypes = ['Time Range', 'Date – Time', 'Date Range – Time'];

    return Stack(children: [
      BlurredAppBarPage(
        autoImplyLeading: true,
        title: 'Work schedule',
        centerTitle: true,
        animatedListKey: listKey,
        childrenCount: initialItemsCount,
        childrenPadding: EdgeInsets.symmetric(
            horizontal: SpacingFoundation.horizontalSpacing12, vertical: SpacingFoundation.verticalSpacing4),
        childrenBuilder: (context, index) {
          if (index == 0) {
            return UiKitBaseDropdown<String>(
              items: scheduleTypes,
              value: selectedScheduleName,
              onChanged: (String? type) {
                if (type != null) {
                  setState(() {
                    selectedScheduleName = type;
                    if (type == scheduleTypes[0]) {
                      scheduleModel = UiScheduleTimeModel(weeklySchedule: List.empty(growable: true));
                    } else if (type == scheduleTypes[1]) {
                      scheduleModel = UiScheduleDatesModel(dailySchedule: List.empty(growable: true));
                    } else if (type == scheduleTypes[2]) {
                      scheduleModel = UiScheduleDatesRangeModel(dailySchedule: List.empty(growable: true));
                    }
                  });
                }
              },
            );
          } else if (index == 1) {
            if (widget.availableTemplates.isNotEmpty) {
              return UiKitBaseDropdown<UiScheduleModel>(
                items: widget.availableTemplates,
                value: scheduleModel,
                onChanged: (UiScheduleModel? selectedTemplate) {
                  if (selectedTemplate != null) {
                    setState(() {
                      scheduleModel = selectedTemplate;
                    });
                  }
                },
              );
            }
          }

          return scheduleModel?.childrenBuilder(
                  index: index - (widget.availableTemplates.isEmpty ? 1 : 2),
                  onAdd: onAddButtonPressed,
                  onRemove: onMinusButtonPressed) ??
              const SizedBox.shrink();
        },
      ),
      Positioned(
          bottom: MediaQuery.paddingOf(context).bottom + SpacingFoundation.verticalSpacing8,
          left: SpacingFoundation.horizontalSpacing16,
          right: SpacingFoundation.horizontalSpacing16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              context.gradientButton(
                data: BaseUiKitButtonData(
                  text: S.current.Save,
                  onPressed: scheduleModel != null ? () => widget.onScheduleCreated?.call(scheduleModel!) : null,
                ),
              ),
              if (scheduleModel != null)
                context.outlinedButton(
                  data: BaseUiKitButtonData(
                      text: 'Save template',
                      onPressed: scheduleModel == null ? null : () => widget.onTemplateCreated?.call(scheduleModel!)),
                ),
            ],
          ))
    ]);
  }
}

const _paddingMultiplier = 3.5;

enum ScheduleType { weekly, dayTime, dayRangeTime }

abstract class UiScheduleModel {
  String? templateName;

  DateTimeRange createTimeRange(TimeOfDay start, TimeOfDay end) {
    if (end.isBefore(start)) {
      showUiKitAlertDialog(
          navigatorKey.currentContext!,
          AlertDialogData(
              title: Text('End time could not be before start time',
                  style: navigatorKey.currentContext!.uiKitTheme?.regularTextTheme.body),
              defaultButtonText: S.current.Ok));
      return DateTimeRange(
          start: DateTime(2020, 1, 1, start.hour, start.minute), end: DateTime(2020, 1, 1, start.hour, start.minute));
    }
    return DateTimeRange(
        start: DateTime(2020, 1, 1, start.hour, start.minute), end: DateTime(2020, 1, 1, end.hour, end.minute));
  }

  DateTime? getDateFromKey(String key) {
    if (key.isEmpty) return null;

    return DateFormat('yy-MM-dd').parse(key);
  }

  String convertDateToKey(DateTime date) {
    return DateFormat('yy-MM-dd').format(date);
  }

  DateTimeRange? getDateRangeFromKey(String key) {
    if (key.isEmpty) return null;

    return DateTimeRange(
      start: getDateFromKey(key.split('/').first) ?? DateTime.now(),
      end: getDateFromKey(key.split('/').last) ?? DateTime.now(),
    );
  }

  String convertDateRangeToKey(DateTimeRange range) {
    return '${convertDateToKey(range.start)}/${convertDateToKey(range.end)}';
  }

  Widget childrenBuilder({required int index, VoidCallback? onAdd, VoidCallback? onRemove});

  int get itemsCount;

  @override
  String toString() => '$templateName';
}

class UiScheduleTimeModel extends UiScheduleModel {
  final List<MapEntry<String, List<TimeOfDay>>> weeklySchedule;

  UiScheduleTimeModel({required this.weeklySchedule});

  @override
  Widget childrenBuilder({required int index, VoidCallback? onAdd, VoidCallback? onRemove}) =>
      StatefulBuilder(builder: (context, setState) {
        final MapEntry<String, List<TimeOfDay>> thisObject =
            weeklySchedule.isNotEmpty && weeklySchedule.length > index ? weeklySchedule[index] : const MapEntry('', []);
        log('rebuild is here $thisObject', name: 'UiScheduleTimeModel');
        return _CardListWrapper(
          children: [
            UiKitAddableFormField(
              title: S.current.Time,
              onAdd: () {
                weeklySchedule.add(const MapEntry('', []));
                onAdd?.call();
              },
              isAbleToRemove: index > 0,
              onRemove: index > 0
                  ? () {
                      weeklySchedule.removeAt(index);
                      onRemove?.call();
                    }
                  : null,
              child: AddableFormChildTime<DateTimeRange>(
                  initialValue:
                      thisObject.value.isEmpty ? null : createTimeRange(thisObject.value.first, thisObject.value.last),
                  onChanged: () => showUiKitTimeFromToDialog(
                        navigatorKey.currentContext!,
                        (TimeOfDay? from, TimeOfDay? to) {
                          if (from != null || to != null) {
                            final newValues = [from, to]..removeWhere((element) => element == null);
                            setState(() {
                              if (weeklySchedule.isNotEmpty && weeklySchedule.length < index) {
                                weeklySchedule[index] = MapEntry(thisObject.key, newValues.map((e) => e!).toList());
                              } else {
                                weeklySchedule.add(MapEntry(thisObject.key, newValues.map((e) => e!).toList()));
                              }
                            });
                          }
                        },
                      )),
            ),
            UiKitAddableFormField(
              title: 'Days of week',
              isAbleToAdd: false,
              child: AddableFormChildDateWeek<String>(
                initialValue: thisObject.key,
                onChanged: () async {
                  final result = await showUiKitWeekdaySelector(navigatorKey.currentContext!);
                  if (result != null) {
                    setState(() {
                      if (weeklySchedule.isNotEmpty && weeklySchedule.length < index) {
                        weeklySchedule[index] = MapEntry(result.join(', '), thisObject.value);
                      } else {
                        weeklySchedule.add(MapEntry(result.join(', '), thisObject.value));
                      }
                    });
                  }
                },
              ),
            ),
          ],
        );
      }).paddingOnly(
          bottom: weeklySchedule.length == index ? SpacingFoundation.verticalSpacing40 * _paddingMultiplier : 0);

  @override
  int get itemsCount => weeklySchedule.length;
}

class UiScheduleDatesModel extends UiScheduleModel {
  final List<MapEntry<String, List<TimeOfDay>>> dailySchedule;

  UiScheduleDatesModel({required this.dailySchedule});

  @override
  Widget childrenBuilder({required int index, VoidCallback? onAdd, VoidCallback? onRemove}) =>
      StatefulBuilder(builder: (context, setState) {
        final MapEntry<String, List<TimeOfDay>> thisObject =
            dailySchedule.isNotEmpty && dailySchedule.length > index ? dailySchedule[index] : const MapEntry('', []);
        log('rebuild is here $thisObject', name: 'UiScheduleDatesModel');
        return _CardListWrapper(children: [
          UiKitAddableFormField(
              title: 'Date',
              onAdd: () {
                dailySchedule.add(const MapEntry('', []));
                onAdd?.call();
              },
              isAbleToRemove: index > 0,
              onRemove: index > 0
                  ? () {
                      dailySchedule.removeAt(index);
                      onRemove?.call();
                    }
                  : null,
              child: AddableFormChildDateWeek<DateTime>(
                  initialValue: thisObject.key.isEmpty ? null : getDateFromKey(thisObject.key),
                  onChanged: () async {
                    final result = await showUiKitCalendarDialog(navigatorKey.currentContext!);
                    if (result != null) {
                      setState(() {
                        if (dailySchedule.isNotEmpty && dailySchedule.length < index) {
                          dailySchedule[index] = MapEntry(convertDateToKey(result), thisObject.value);
                        } else {
                          dailySchedule.add(MapEntry(convertDateToKey(result), thisObject.value));
                        }
                      });
                    }
                  })),
          if (thisObject.value.isEmpty)
            UiKitAddableFormField(
                title: S.current.Time,
                onAdd: () {
                  setState(() {
                    if (dailySchedule.isNotEmpty && dailySchedule.length < index) {
                      dailySchedule[index] = MapEntry(thisObject.key, [...thisObject.value, TimeOfDay.now()]);
                    } else {
                      dailySchedule.add(MapEntry(thisObject.key, [...thisObject.value, TimeOfDay.now()]));
                    }
                  });
                },
                child: AddableFormChildTime<DateTime>(
                  onChanged: () async {
                    final result = await showUiKitTimeDialog(navigatorKey.currentContext!);
                    if (result != null) {
                      setState(() {
                        if (dailySchedule.isNotEmpty && dailySchedule.length < index) {
                          dailySchedule[index] = MapEntry(thisObject.key, [result]);
                        } else {
                          dailySchedule.add(MapEntry(thisObject.key, [result]));
                        }
                      });
                    }
                  },
                ))
          else
            for (var (i, time) in thisObject.value.indexed)
              UiKitAddableFormField(
                  title: S.current.Time,
                  onAdd: () {
                    setState(() {
                      if (dailySchedule.isNotEmpty && dailySchedule.length < index) {
                        dailySchedule[index] = MapEntry(thisObject.key, [...thisObject.value, TimeOfDay.now()]);
                      } else {
                        dailySchedule.add(MapEntry(thisObject.key, [...thisObject.value, TimeOfDay.now()]));
                      }
                    });
                  },
                  isAbleToRemove: true,
                  onRemove: () {
                    final originalTimes = thisObject.value;
                    originalTimes.removeAt(i);
                    setState(() {
                      dailySchedule[index] = MapEntry(thisObject.key, originalTimes);
                    });
                  },
                  child: AddableFormChildTime<DateTime>(
                    initialValue: DateTime(2020, 1, 1, time.hour, time.minute),
                    onChanged: () async {
                      final result = await showUiKitTimeDialog(navigatorKey.currentContext!);
                      if (result != null) {
                        final originalTimes = thisObject.value;
                        originalTimes[i] = result;
                        setState(() {
                          dailySchedule[index] = MapEntry(thisObject.key, originalTimes);
                        });
                      }
                    },
                  ))
        ]);
      }).paddingOnly(
          bottom: dailySchedule.length == index ? SpacingFoundation.verticalSpacing40 * _paddingMultiplier : 0);

  @override
  int get itemsCount => dailySchedule.length;
}

class UiScheduleDatesRangeModel extends UiScheduleModel {
  final List<MapEntry<String, List<TimeOfDay>>> dailySchedule;

  UiScheduleDatesRangeModel({required this.dailySchedule});

  @override
  Widget childrenBuilder({required int index, VoidCallback? onAdd, VoidCallback? onRemove}) =>
      StatefulBuilder(builder: (context, setState) {
        final MapEntry<String, List<TimeOfDay>> thisObject =
            dailySchedule.isNotEmpty && dailySchedule.length > index ? dailySchedule[index] : const MapEntry('', []);
        log('rebuild is here $thisObject', name: 'UiScheduleDatesRangeModel');
        return _CardListWrapper(children: [
          UiKitAddableFormField(
              title: 'Date Range',
              onAdd: () {
                dailySchedule.add(const MapEntry('', []));
                onAdd?.call();
              },
              isAbleToRemove: index > 0,
              onRemove: index > 0
                  ? () {
                      dailySchedule.removeAt(index);
                      onRemove?.call();
                    }
                  : null,
              child: AddableFormChildDateWeek<DateTimeRange>(
                  initialValue: getDateRangeFromKey(thisObject.key),
                  onChanged: () async {
                    final result = await showDateRangePickerDialog(navigatorKey.currentContext!);
                    if (result != null) {
                      setState(() {
                        if (dailySchedule.isNotEmpty && dailySchedule.length < index) {
                          dailySchedule[index] = MapEntry(convertDateRangeToKey(result), thisObject.value);
                        } else {
                          dailySchedule.add(MapEntry(convertDateRangeToKey(result), thisObject.value));
                        }
                      });
                    }
                  })),
          if (thisObject.value.isEmpty)
            UiKitAddableFormField(
                title: S.current.Time,
                onAdd: () {
                  setState(() {
                    if (dailySchedule.isNotEmpty && dailySchedule.length < index) {
                      dailySchedule[index] = MapEntry(thisObject.key, [...thisObject.value, TimeOfDay.now()]);
                    } else {
                      dailySchedule.add(MapEntry(thisObject.key, [...thisObject.value, TimeOfDay.now()]));
                    }
                  });
                },
                child: AddableFormChildTime<DateTimeRange>(
                  onChanged: () async {
                    final result = await showUiKitTimeDialog(navigatorKey.currentContext!);
                    if (result != null) {
                      dailySchedule[index] = MapEntry(thisObject.key, [result]);
                      setState(() {});
                    }
                  },
                ))
          else
            for (var (i, time) in thisObject.value.indexed)
              UiKitAddableFormField(
                  title: S.current.Time,
                  onAdd: () {
                    setState(() {
                      if (dailySchedule.isNotEmpty && dailySchedule.length < index) {
                        dailySchedule[index] = MapEntry(thisObject.key, [...thisObject.value, TimeOfDay.now()]);
                      } else {
                        dailySchedule.add(MapEntry(thisObject.key, [...thisObject.value, TimeOfDay.now()]));
                      }
                    });
                  },
                  isAbleToRemove: true,
                  onRemove: () {
                    final originalTimes = thisObject.value;
                    originalTimes.removeAt(i);
                    setState(() {
                      dailySchedule[index] = MapEntry(thisObject.key, originalTimes);
                    });
                  },
                  child: AddableFormChildTime<DateTime>(
                    initialValue: DateTime(2020, 1, 1, time.hour, time.minute),
                    onChanged: () async {
                      final result = await showUiKitTimeDialog(navigatorKey.currentContext!);
                      if (result != null) {
                        final originalTimes = thisObject.value;
                        originalTimes[i] = result;
                        setState(() {
                          dailySchedule[index] = MapEntry(thisObject.key, originalTimes);
                        });
                      }
                    },
                  ))
        ]);
      }).paddingOnly(
          bottom: dailySchedule.length == index ? SpacingFoundation.verticalSpacing40 * _paddingMultiplier : 0);

  @override
  int get itemsCount => dailySchedule.length;
}

class _CardListWrapper extends StatelessWidget {
  final List<Widget> children;

  const _CardListWrapper({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return UiKitCardWrapper(
        padding: EdgeInsets.symmetric(
            horizontal: SpacingFoundation.horizontalSpacing16, vertical: SpacingFoundation.verticalSpacing16),
        borderRadius: BorderRadiusFoundation.all24,
        color: theme?.colorScheme.surface1,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children.wrapChildrenSeparator(SpacingFoundation.verticalSpace8)));
  }
}

extension WrapChildrenSeparator on List<Widget> {
  List<Widget> wrapChildrenSeparator(Widget separator) {
    final result = <Widget>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i != length - 1) {
        result.add(separator);
      }
    }
    return result;
  }
}
