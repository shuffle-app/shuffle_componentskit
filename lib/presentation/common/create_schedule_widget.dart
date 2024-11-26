import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/services/navigation_service/navigation_key.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'select_schedule_type.dart';
import 'select_template_type.dart';

class CreateScheduleWidget extends StatefulWidget {
  final List<UiScheduleModel> availableTemplates;
  final ValueChanged<UiScheduleModel>? onTemplateCreated;
  final ValueChanged<UiScheduleModel>? onScheduleCreated;
  final List<String> availableTypes;
  final UiScheduleModel? scheduleToEdit;

  const CreateScheduleWidget(
      {super.key,
      this.availableTemplates = const [],
      this.onTemplateCreated,
      this.onScheduleCreated,
      this.scheduleToEdit,
      this.availableTypes = const [
        UiScheduleTimeModel.scheduleType,
        UiScheduleDatesModel.scheduleType,
        UiScheduleDatesRangeModel.scheduleType
      ]});

  @override
  State<CreateScheduleWidget> createState() => _CreateScheduleWidgetState();
}

class _CreateScheduleWidgetState extends State<CreateScheduleWidget> {
  late final int initialItemsCount = 2;
  String? selectedScheduleName;

  UiScheduleModel? scheduleModel;

  final listKey = GlobalKey<SliverAnimatedListState>();

  @override
  void initState() {
    scheduleModel = widget.scheduleToEdit;
    debugPrint('recieved schedule: $scheduleModel');
    if (scheduleModel != null) {
      if (scheduleModel is UiScheduleTimeModel) {
        selectedScheduleName = UiScheduleTimeModel.scheduleType;
      } else if (scheduleModel is UiScheduleDatesModel) {
        selectedScheduleName = UiScheduleDatesModel.scheduleType;
      } else if (scheduleModel is UiScheduleDatesRangeModel) {
        selectedScheduleName = UiScheduleDatesRangeModel.scheduleType;
      }
      if ((scheduleModel?.itemsCount ?? 0) >= 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Pre-fill the list with existing items.
          listKey.currentState!.insertAllItems(1, scheduleModel!.itemsCount);
          onMinusButtonPressed();
        });
      }
    }
    super.initState();
  }

  List<UiScheduleModel> get availableTemplates =>
      widget.availableTemplates.where((e) => e.runtimeType == scheduleModel.runtimeType).toList();

  void onAddButtonPressed() {
    listKey.currentState!.insertItem(initialItemsCount + scheduleModel!.itemsCount - 1);
    // listKey.currentState!.insertItem(scheduleModel!.itemsCount + 1);
  }

  void onMinusButtonPressed({int? index}) {
    listKey.currentState!.removeItem(index != null ? scheduleModel!.itemsCount - index : scheduleModel!.itemsCount - 1,
        (context, animation) {
      return ScaleTransition(scale: animation, child: const SizedBox());
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheduleTypes = widget.availableTypes;
    final theme = context.uiKitTheme;

    TextStyle? textStyle = theme?.boldTextTheme.title1 ?? Theme.of(context).primaryTextTheme.titleMedium;
    textStyle = textStyle?.copyWith(color: theme?.colorScheme.inversePrimary);
    return Scaffold(
        body: SizedBox(
            height: 1.sh,
            child: Stack(children: [
              SizedBox(
                  height: 0.83.sh,
                  child: BlurredAppBarPage(
                    autoImplyLeading: true,
                    customTitle: AutoSizeText(S.of(context).Schedule, maxLines: 1, style: textStyle),
                    centerTitle: true,
                    animatedListKey: listKey,
                    childrenCount: initialItemsCount,
                    childrenPadding: EdgeInsets.symmetric(
                        horizontal: SpacingFoundation.horizontalSpacing12,
                        vertical: SpacingFoundation.verticalSpacing4),
                    childrenBuilder: (context, index) {
                      if (index == 0) {
                        return Column(mainAxisSize: MainAxisSize.min, children: [
                          SelectScheduleType(
                            scheduleTypes: scheduleTypes,
                            selectedScheduleName: selectedScheduleName,
                            showWarningDialog: () => scheduleModel?.isNotEmpty ?? false,
                            onSelectType: (type) {
                              if (type != null) {
                                if ((scheduleModel?.itemsCount ?? 0) > 1) {
                                  for (var i = 0; i < scheduleModel!.itemsCount - 1; i++) {
                                    onMinusButtonPressed(index: i);
                                  }
                                }
                                setState(() {
                                  selectedScheduleName = type;
                                  if (type == UiScheduleTimeModel.scheduleType) {
                                    scheduleModel = UiScheduleTimeModel();
                                  } else if (type == UiScheduleDatesModel.scheduleType) {
                                    scheduleModel = UiScheduleDatesModel();
                                  } else if (type == UiScheduleDatesRangeModel.scheduleType) {
                                    scheduleModel = UiScheduleDatesRangeModel();
                                  }
                                });
                              }
                              context.pop();
                            },
                          ).paddingOnly(bottom: availableTemplates.isEmpty ? SpacingFoundation.verticalSpacing16 : 0.0),
                          if (availableTemplates.isNotEmpty) ...[
                            SpacingFoundation.verticalSpace4,
                            SelectTemplateType(
                              scheduleTypes: availableTemplates,
                              onChanged: (UiScheduleModel? selectedTemplate) {
                                if (selectedTemplate != null) {
                                  if ((scheduleModel?.itemsCount ?? 0) >= 1) {
                                    for (var i = 0; i < scheduleModel!.itemsCount; i++) {
                                      onMinusButtonPressed(index: i);
                                    }
                                  }
                                  setState(() {
                                    scheduleModel = selectedTemplate;
                                    switch (scheduleModel.runtimeType) {
                                      case UiScheduleTimeModel _:
                                        selectedScheduleName = UiScheduleTimeModel.scheduleType;
                                        break;

                                      case UiScheduleDatesModel _:
                                        selectedScheduleName = UiScheduleDatesModel.scheduleType;
                                        break;

                                      case UiScheduleDatesRangeModel _:
                                        selectedScheduleName = UiScheduleDatesRangeModel.scheduleType;
                                    }
                                  });
                                  if ((scheduleModel?.itemsCount ?? 0) >= 1) {
                                    log('scheduleModel!.itemsCount ${scheduleModel!.itemsCount}');
                                    listKey.currentState!.insertAllItems(0, scheduleModel!.itemsCount);
                                  }

                                  context.pop();
                                }
                              },
                            ),
                            SpacingFoundation.verticalSpace16,
                          ]
                        ]);
                      }
                      return scheduleModel?.childrenBuilder(
                              index: index - 1, onAdd: onAddButtonPressed, onRemove: onMinusButtonPressed) ??
                          const SizedBox.shrink();
                    },
                  )),
              Positioned(
                  bottom: 0,
                  left: SpacingFoundation.horizontalSpacing16,
                  right: SpacingFoundation.horizontalSpacing16,
                  child: UiKitCardWrapper(
                      borderRadius: BorderRadiusFoundation.all24,
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.paddingOf(context).bottom + SpacingFoundation.verticalSpacing8,
                      ),
                      color: theme?.colorScheme.surface,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          context.gradientButton(
                            data: BaseUiKitButtonData(
                              text: S.current.Save,
                              onPressed: scheduleModel != null
                                  ? () {
                                      context.pop();
                                      widget.onScheduleCreated?.call(scheduleModel!);
                                    }
                                  : null,
                            ),
                          ),
                          SpacingFoundation.verticalSpace8,
                          if (scheduleModel != null)
                            context.outlinedButton(
                              data: BaseUiKitButtonData(
                                  text: S.of(context).SaveTemplate,
                                  onPressed: scheduleModel == null
                                      ? null
                                      : () async {
                                          final textTheme = theme?.boldTextTheme;
                                          final controller = TextEditingController();
                                          final name = await showUiKitAlertDialog<String?>(
                                              context,
                                              AlertDialogData(
                                                  title: Text(
                                                    S.of(context).SaveTemplate,
                                                    style: textTheme?.title2
                                                        .copyWith(color: UiKitColors.lightHeadingTypographyColor),
                                                  ),
                                                  content: UiKitInputFieldNoIcon(
                                                    hintText: S.current.Title,
                                                    controller: controller,
                                                    autofocus: true,
                                                    textColor: UiKitColors.lightHeadingTypographyColor,
                                                    customLabelColor: UiKitColors.lightBodyTypographyColor,
                                                    fillColor: UiKitColors.lightSurface1,
                                                    borderRadius: BorderRadiusFoundation.all12,
                                                    label: S.of(context).TemplateName,
                                                  ),
                                                  actions: [
                                                    context.button(
                                                        data: BaseUiKitButtonData(
                                                            backgroundColor: theme?.colorScheme.primary,
                                                            textColor: theme?.colorScheme.inversePrimary,
                                                            text: S.current.Save,
                                                            fit: ButtonFit.fitWidth,
                                                            onPressed: () => context.pop(result: controller.text)))
                                                  ],
                                                  defaultButtonText: S.current.Save,
                                                  onPop: () => context.pop(result: controller.text)));
                                          if (name != null) {
                                            scheduleModel!.templateName = name;
                                            widget.onTemplateCreated?.call(scheduleModel!);
                                          }
                                        }),
                            ),
                        ],
                      )))
            ])));
  }
}

const _paddingMultiplier = 4.2;

abstract class UiScheduleModel {
  String? templateName;

  TimeRange createTimeRange(TimeOfDay start, TimeOfDay end) {
    return TimeRange(
      start: TimeOfDay(hour: start.hour, minute: start.minute),
      end: TimeOfDay(hour: end.hour, minute: end.minute),
    );
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

  String encodeSchedule();

  static List<MapEntry<String, List<TimeOfDay>>> decodeSchedule(String scheduleString) {
    return scheduleString.split(';').map((schedule) {
      final parts = schedule.split(':');
      return MapEntry(
          parts[0],
          parts[1]
              .split(',')
              .map((time) => TimeOfDay(hour: int.parse(time.split('-')[0]), minute: int.parse(time.split('-')[1])))
              .toList());
    }).toList();
  }

  List<List<String>> getReadableScheduleString();

  bool selectableDayPredicate(DateTime day);

  DateTime? get startDay;

  DateTime? get endDay;

  bool get isNotEmpty;
}

class UiScheduleTimeModel extends UiScheduleModel {
  static const String scheduleType = 'Time Range';
  final List<MapEntry<String, List<TimeOfDay>>> weeklySchedule = List.empty(growable: true)
    ..add(const MapEntry('', []));

  UiScheduleTimeModel([List<MapEntry<String, List<TimeOfDay>>>? schedule]) {
    if (schedule != null && schedule.isNotEmpty) {
      weeklySchedule.clear();
      weeklySchedule.addAll(schedule);
    }
  }

  @override
  Widget childrenBuilder({required int index, VoidCallback? onAdd, VoidCallback? onRemove}) {
    return StatefulBuilder(builder: (context, setState) {
      final MapEntry<String, List<TimeOfDay>> thisObject =
          weeklySchedule.isNotEmpty && weeklySchedule.length > index ? weeklySchedule[index] : const MapEntry('', []);
      log('rebuild is here $thisObject', name: 'UiScheduleTimeModel');
      log('index is $index', name: 'UiScheduleTimeModel');
      return _CardListWrapper(
        children: [
          UiKitAddableFormField(
            title: S.current.TimeRange,
            onAdd: () {
              onAdd?.call();
              setState(() {
                weeklySchedule.add(const MapEntry('', []));
              });
            },
            isAbleToRemove: index > 0,
            onRemove: index > 0
                ? () {
                    setState(() {
                      weeklySchedule.removeAt(index);
                    });
                    onRemove?.call();
                  }
                : null,
            child: AddableFormChildTime<TimeRange>(
              initialValue:
                  thisObject.value.isEmpty ? null : createTimeRange(thisObject.value.first, thisObject.value.last),
              onChanged: () => showUiKitTimeFromToDialog(
                navigatorKey.currentContext!,
                (TimeOfDay? from, TimeOfDay? to) {
                  if (from != null || to != null) {
                    final newValues = [from, to]..removeWhere((element) => element == null);

                    setState(() {
                      if (weeklySchedule.isNotEmpty && weeklySchedule.length > index) {
                        weeklySchedule[index] = MapEntry(thisObject.key, newValues.map((e) => e!).toList());
                      } else {
                        weeklySchedule.add(MapEntry(thisObject.key, newValues.map((e) => e!).toList()));
                      }
                      log('weeklySchedule ${weeklySchedule}', name: 'UiScheduleTimeModel');
                    });
                  }
                },
              ),
            ),
          ),
          UiKitAddableFormField(
            title: S.current.DaysOfWeek,
            isAbleToAdd: false,
            child: AddableFormChildDateWeek<String>(
              initialValue: thisObject.key,
              onChanged: () async {
                final result = await showUiKitWeekdaySelector(navigatorKey.currentContext!);
                if (result != null) {
                  setState(() {
                    if (weeklySchedule.isNotEmpty && weeklySchedule.length > index) {
                      weeklySchedule[index] = MapEntry(result.join(', '), thisObject.value);
                    } else {
                      weeklySchedule.add(MapEntry(result.join(', '), thisObject.value));
                    }
                    log('weeklySchedule ${weeklySchedule}', name: 'UiScheduleTimeModel');
                  });
                }
              },
            ),
          ),
        ],
      );
    }).paddingOnly(
        bottom: weeklySchedule.length - 1 == index ? SpacingFoundation.verticalSpacing40 * _paddingMultiplier : 0);
  }

  @override
  int get itemsCount => weeklySchedule.length;

  @override
  String encodeSchedule() {
    return weeklySchedule
        .map((e) => '${e.key}:${e.value.map((time) => '${time.hour}-${time.minute}').join(',')}')
        .join(';');
  }

  @override
  List<List<String>> getReadableScheduleString() {
    return weeklySchedule
        .map((e) => ['${e.key}:', (e.value.map((time) => time.normalizedString).join(' - '))])
        .toList();
  }

  @override
  bool selectableDayPredicate(DateTime day) {
    final List<int> indexesOfWeekdays = [];

    weeklySchedule.forEach(
      (element) {
        final index = element.key.split(',').map((e) {
          return uiKitConstWeekdays.indexOf(e.trim()) + 1;
        }).toList();
        indexesOfWeekdays.addAll(index);
      },
    );

    return indexesOfWeekdays.contains(day.weekday);
  }

  @override
  // there is no start day in the weekly schedule
  DateTime? get startDay => null;

  @override
  DateTime? get endDay => null;

  @override
  bool get isNotEmpty => weeklySchedule.any((e) => e.value.isNotEmpty);
}

class UiScheduleDatesModel extends UiScheduleModel {
  static const String scheduleType = 'Date – Time';
  final List<MapEntry<String, List<TimeOfDay>>> dailySchedule = List.empty(growable: true)..add(const MapEntry('', []));

  UiScheduleDatesModel([List<MapEntry<String, List<TimeOfDay>>>? schedule]) {
    if (schedule != null && schedule.isNotEmpty) {
      dailySchedule.clear();
      dailySchedule.addAll(schedule);
    }
  }

  @override
  Widget childrenBuilder({required int index, VoidCallback? onAdd, VoidCallback? onRemove}) {
    String? errorText;

    return StatefulBuilder(builder: (context, setState) {
      final MapEntry<String, List<TimeOfDay>> thisObject =
          dailySchedule.isNotEmpty && dailySchedule.length > index ? dailySchedule[index] : const MapEntry('', []);
      log('rebuild is here $thisObject', name: 'UiScheduleDatesModel');
      return _CardListWrapper(children: [
        UiKitAddableFormField(
            title: S.current.Date,
            onAdd: () {
              onAdd?.call();
              dailySchedule.add(const MapEntry('', []));
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
                  final result = await showUiKitCalendarDialog(
                    navigatorKey.currentContext!,
                    selectableDayPredicate: (day) {
                      return day.toLocal().isAfter(DateTime.now().toLocal()) || (day.toLocal().isAtSameDay);
                    },
                  );
                  if (dailySchedule[index].value.isNotEmpty) dailySchedule[index].value.clear();

                  if (result != null) {
                    setState(() {
                      if (dailySchedule.isNotEmpty && dailySchedule.length > index) {
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
                  if (dailySchedule.isNotEmpty && dailySchedule.length > index) {
                    dailySchedule[index] = MapEntry(thisObject.key, [...thisObject.value, TimeOfDay.now()]);
                  } else {
                    dailySchedule.add(MapEntry(thisObject.key, [...thisObject.value, TimeOfDay.now()]));
                  }
                });
              },
              child: AddableFormChildTime<TimeOfDay>(
                onChanged: () async {
                  final result = await showUiKitTimeDialog(navigatorKey.currentContext!);
                  if (result != null) {
                    if (dailySchedule[index].key.isNotEmpty) {
                      if (result.isBefore(TimeOfDay.now()) && asSameDayDateTime(dailySchedule[index].key)) {
                        setState(() {
                          errorText = S.of(context).TheSelectedTimeCannotBeElapsed;
                        });
                        return;
                      } else if (errorText != null) {
                        setState(() {
                          errorText = null;
                        });
                      }
                    } else {
                      setState(() {
                        errorText = S.of(context).ItNecessaryToChooseADay;
                      });
                      return;
                    }

                    setState(() {
                      if (dailySchedule.isNotEmpty && dailySchedule.length > index) {
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
                  if (dailySchedule.isNotEmpty && dailySchedule.length > index) {
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
              child: AddableFormChildTime<TimeOfDay>(
                initialValue: time,
                onChanged: () async {
                  final result = await showUiKitTimeDialog(navigatorKey.currentContext!);
                  if (result != null) {
                    if (result.isBefore(TimeOfDay.now()) && asSameDayDateTime(dailySchedule[index].key)) {
                      setState(() {
                        errorText = S.of(context).TheSelectedTimeCannotBeElapsed;
                      });
                      return;
                    } else if (errorText != null) {
                      setState(() {
                        errorText = null;
                      });
                    }

                    final originalTimes = thisObject.value;
                    originalTimes[i] = result;
                    setState(() {
                      dailySchedule[index] = MapEntry(thisObject.key, originalTimes);
                    });
                  }
                },
              ),
            ),
        if (errorText != null)
          Text(
            errorText!,
            style: context.uiKitTheme?.boldTextTheme.body.copyWith(
              color: ColorsFoundation.error,
            ),
          ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing4),
      ]);
    }).paddingOnly(
        bottom: dailySchedule.length - 1 == index ? SpacingFoundation.verticalSpacing40 * _paddingMultiplier : 0);
  }

  @override
  int get itemsCount => dailySchedule.length;

  @override
  String encodeSchedule() {
    return dailySchedule
        .map((e) => '${e.key}:${e.value.map((time) => '${time.hour}-${time.minute}').join(',')}')
        .join(';');
  }

  @override
  List<List<String>> getReadableScheduleString() {
    return dailySchedule.map((e) => ['${e.key}:', e.value.map((time) => time.normalizedString).join(', ')]).toList();
  }

  @override
  bool selectableDayPredicate(DateTime day) {
    final daysList = dailySchedule.map((e) => getDateFromKey(e.key)).nonNulls.toList();
    return daysList.any((e) => e.isAtSameDayAs(day));
  }

  @override
  DateTime? get startDay {
    final daysList = dailySchedule.map((e) => getDateFromKey(e.key)).nonNulls.toList();
    daysList.sort((a, b) => a.compareTo(b));
    return daysList.firstOrNull;
  }

  @override
  DateTime? get endDay {
    final daysList = dailySchedule.map((e) => getDateFromKey(e.key)).nonNulls.toList();
    daysList.sort((a, b) => a.compareTo(b));
    return daysList.lastOrNull;
  }

  @override
  bool get isNotEmpty => dailySchedule.any((e) => e.key.isNotEmpty);
}

class UiScheduleDatesRangeModel extends UiScheduleModel {
  static const String scheduleType = 'Date Range - Time';
  final List<MapEntry<String, List<TimeOfDay>>> dailySchedule = List.empty(growable: true)..add(const MapEntry('', []));

  UiScheduleDatesRangeModel([List<MapEntry<String, List<TimeOfDay>>>? schedule]) {
    if (schedule != null && schedule.isNotEmpty) {
      dailySchedule.clear();
      dailySchedule.addAll(schedule);
    }
  }

  @override
  Widget childrenBuilder({required int index, VoidCallback? onAdd, VoidCallback? onRemove}) {
    String? errorText;

    return StatefulBuilder(builder: (context, setState) {
      final MapEntry<String, List<TimeOfDay>> thisObject =
          dailySchedule.isNotEmpty && dailySchedule.length > index ? dailySchedule[index] : const MapEntry('', []);
      log('rebuild is here $thisObject', name: 'UiScheduleDatesRangeModel');
      final now = DateTime.now();
      return _CardListWrapper(children: [
        UiKitAddableFormField(
            title: S.current.DateRange,
            onAdd: () {
              onAdd?.call();
              dailySchedule.add(const MapEntry('', []));
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
                    if (!result.start.isAtSameDay) {
                      if ((result.start.isBefore(now) || result.end.isBefore(now))) {
                        setState(() {
                          errorText = S.current.APeriodOrPartOfPeriodOfTimeCannotBeInPast;
                        });
                        return;
                      } else if (errorText != null) {
                        setState(() {
                          errorText = null;
                        });
                      }
                    } else if (errorText != null) {
                      setState(() {
                        errorText = null;
                      });
                    }

                    setState(() {
                      if (dailySchedule.isNotEmpty && dailySchedule.length > index) {
                        dailySchedule[index] = MapEntry(convertDateRangeToKey(result), thisObject.value);
                      } else {
                        dailySchedule.add(MapEntry(convertDateRangeToKey(result), thisObject.value));
                      }
                    });
                  }
                })),
        if (thisObject.value.isEmpty)
          UiKitAddableFormField(
              title: S.current.TimeRange,
              onAdd: () {
                if (dailySchedule[index].key.isNotEmpty) {
                  setState(() {
                    if (dailySchedule.isNotEmpty && dailySchedule.length > index) {
                      dailySchedule[index] = MapEntry(thisObject.key, [...thisObject.value, TimeOfDay.now()]);
                    } else {
                      dailySchedule.add(MapEntry(thisObject.key, [...thisObject.value, TimeOfDay.now()]));
                    }
                  });
                } else {
                  setState(() {
                    errorText = S.of(context).ItNecessaryToChooseADay;
                  });
                  return;
                }
              },
              child: AddableFormChildTime<TimeRange>(
                onChanged: () async {
                  await showUiKitTimeFromToDialog(navigatorKey.currentContext!, (timeFrom, timeTo) {
                    if (timeFrom != null) {
                      if (dailySchedule[index].key.isNotEmpty) {
                        final nowTime = TimeOfDay.now();
                        if (atSameDayDatesRange(dailySchedule[index].key) &&
                            timeFrom.hour < nowTime.hour &&
                            timeFrom.minute < nowTime.minute) {
                          setState(() {
                            errorText = S.current.TheSelectedTimeCannotBeElapsed;
                          });
                          return;
                        } else if (errorText != null) {
                          setState(() {
                            errorText = null;
                          });
                        }
                      } else {
                        setState(() {
                          errorText = S.of(context).ItNecessaryToChooseADay;
                        });
                        return;
                      }

                      // if(timeTo!=null){
                      //   if(timeFrom.isAfter(timeTo)) {
                      //     setState(() {
                      //       errorText = S.current.TheSelectedTimeCannotBeElapsed;
                      //     });
                      //     return;
                      //   }
                      // }
                      dailySchedule[index] = MapEntry(thisObject.key, [timeFrom, timeTo].nonNulls.toList());
                      setState(() {});
                    }
                  });
                },
              ))
        else
          for (var (i, timeRange) in listTimeDayToTimeRange(thisObject.value).indexed)
            UiKitAddableFormField(
              title: S.current.TimeRange,
              onAdd: () {
                setState(() {
                  if (dailySchedule.isNotEmpty && dailySchedule.length > index) {
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
              child: AddableFormChildTime<TimeRange>(
                  initialValue: timeRange,
                  onChanged: () async {
                    await showUiKitTimeFromToDialog(navigatorKey.currentContext!, (timeFrom, timeTo) {
                      if (timeFrom != null) {
                        if (dailySchedule[index].key.isNotEmpty) {
                          final nowTime = TimeOfDay.now();
                          if (atSameDayDatesRange(dailySchedule[index].key) &&
                              timeFrom.hour < nowTime.hour &&
                              timeFrom.minute < nowTime.minute) {
                            setState(() {
                              errorText = S.current.TheSelectedTimeCannotBeElapsed;
                            });
                            return;
                          } else if (errorText != null) {
                            setState(() {
                              errorText = null;
                            });
                          }
                        } else {
                          setState(() {
                            errorText = S.of(context).ItNecessaryToChooseADay;
                          });
                          return;
                        }

                        // if(timeTo!=null){
                        //   if(timeFrom.isAfter(timeTo)) {
                        //     setState(() {
                        //       errorText = S.current.TheSelectedTimeCannotBeElapsed;
                        //     });
                        //     return;
                        //   }
                        // }
                        final originalTimes = dailySchedule[index].value;

                        final itemsToRemove = originalTimes.length.isEven ? 2 : 1;
                        originalTimes.removeRange(originalTimes.length - itemsToRemove, originalTimes.length);

                        dailySchedule[index] =
                            MapEntry(thisObject.key, originalTimes + [timeFrom, timeTo].nonNulls.toList());
                        setState(() {});
                      }
                    });
                  }),
            ),
        if (errorText != null)
          Text(
            errorText!,
            style: context.uiKitTheme?.boldTextTheme.body.copyWith(
              color: ColorsFoundation.error,
            ),
          ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing4),
      ]);
    }).paddingOnly(
        bottom: dailySchedule.length - 1 == index ? SpacingFoundation.verticalSpacing40 * _paddingMultiplier : 0);
  }

  @override
  int get itemsCount => dailySchedule.length;

  @override
  String encodeSchedule() {
    return dailySchedule
        .map((e) => '${e.key}:${e.value.map((time) => '${time.hour}-${time.minute}').join(',')}')
        .join(';');
  }

  @override
  List<List<String>> getReadableScheduleString() {
    return dailySchedule
        .map((e) => [
              '${getDateRangeFromKey(e.key)!.toPrettyString()}:',
              e.value.map((time) => time.normalizedString).join(' - ')
            ])
        .toList();
  }

  @override
  bool selectableDayPredicate(DateTime day) {
    final List<DateTimeRange> dateRanges = dailySchedule.map((e) => getDateRangeFromKey(e.key)).nonNulls.toList();
    return dateRanges.any((range) =>
        (range.start.isBefore(day) || range.start.isAtSameDayAs(day)) &&
        (range.end.isAfter(day) || range.end.isAtSameDayAs(day)));
  }

  @override
  DateTime? get startDay {
    final List<DateTimeRange> dateRanges = dailySchedule.map((e) => getDateRangeFromKey(e.key)).nonNulls.toList();
    dateRanges.sort((a, b) => a.start.compareTo(b.start));
    return dateRanges.firstOrNull?.start;
  }

  @override
  DateTime? get endDay {
    final List<DateTimeRange> dateRanges = dailySchedule.map((e) => getDateRangeFromKey(e.key)).nonNulls.toList();
    dateRanges.sort((a, b) => a.end.compareTo(b.end));
    return dateRanges.lastOrNull?.end;
  }

  @override
  bool get isNotEmpty => dailySchedule.any((e) => e.key.isNotEmpty);
}

class _CardListWrapper extends StatelessWidget {
  final List<Widget> children;

  const _CardListWrapper({required this.children});

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

bool atSameDayDatesRange(String key) {
  final dateRange = key.split('/');
  bool isSameDay = false;
  if (dateRange.length == 2) {
    if (dateRange[0] == dateRange[1]) {
      final parseDay = dateRange[0].split('-');
      if (DateTime(
        int.parse('20${parseDay[0]}'),
        int.parse(parseDay[1]),
        int.parse(parseDay[2]),
      ).isAtSameDay) {
        log('AT same day ');
        isSameDay = true;
      }
    }
  }

  return isSameDay;
}

bool asSameDayDateTime(String key) {
  final selectedDateList = key.split('-');
  final DateTime selectedDate = DateTime(
    int.parse('20${selectedDateList[0]}'),
    int.parse(selectedDateList[1]),
    int.parse(selectedDateList[2]),
  );
  return selectedDate.isAtSameDay;
}
