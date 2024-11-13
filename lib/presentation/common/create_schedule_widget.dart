import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/services/navigation_service/navigation_key.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

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
      if ((scheduleModel?.itemsCount ?? 0) >= 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Pre-fill the list with existing items.
          listKey.currentState!.insertAllItems(1, scheduleModel!.itemsCount);
        });
      }
    }
    super.initState();
  }

  List<UiScheduleModel> get availableTemplates =>
      widget.availableTemplates.where((e) => e.runtimeType == scheduleModel.runtimeType).toList();

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
    final scheduleTypes = widget.availableTypes;
    final theme = context.uiKitTheme;

    TextStyle? textStyle = theme?.boldTextTheme.title1 ?? Theme.of(context).primaryTextTheme.titleMedium;
    textStyle = textStyle?.copyWith(color: theme?.colorScheme.inversePrimary);
    return Scaffold(
        body: Stack(children: [
      BlurredAppBarPage(
        autoImplyLeading: true,
        customTitle: AutoSizeText(S.of(context).WorkHours, maxLines: 1, style: textStyle),
        centerTitle: true,
        animatedListKey: listKey,
        childrenCount: initialItemsCount,
        childrenPadding: EdgeInsets.symmetric(
            horizontal: SpacingFoundation.horizontalSpacing12, vertical: SpacingFoundation.verticalSpacing4),
        childrenBuilder: (context, index) {
          if (index == 0) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              UiKitBaseDropdown<String>(
                items: scheduleTypes,
                value: selectedScheduleName,
                onChanged: (String? type) {
                  if (type != null) {
                    if ((scheduleModel?.itemsCount ?? 0) > 1) {
                      for (var i = 0; i < scheduleModel!.itemsCount; i++) {
                        onMinusButtonPressed();
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
                },
              ),
              if (availableTemplates.isNotEmpty) ...[
                SpacingFoundation.verticalSpace4,
                UiKitBaseDropdown<UiScheduleModel>(
                  items: availableTemplates,
                  onChanged: (UiScheduleModel? selectedTemplate) {
                    if (selectedTemplate != null) {
                      if ((scheduleModel?.itemsCount ?? 0) >= 1) {
                        for (var i = 0; i < scheduleModel!.itemsCount; i++) {
                          onMinusButtonPressed();
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
                        listKey.currentState!.insertAllItems(1, scheduleModel!.itemsCount);
                      }
                    }
                  },
                )
              ]
            ]);
          }

          return scheduleModel?.childrenBuilder(
                  index: index - 1, onAdd: onAddButtonPressed, onRemove: onMinusButtonPressed) ??
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
                                        style:
                                            textTheme?.title2.copyWith(color: UiKitColors.lightHeadingTypographyColor),
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
          ))
    ]));
  }
}

const _paddingMultiplier = 4.2;

abstract class UiScheduleModel {
  String? templateName;

  DateTimeRange createTimeRange(TimeOfDay start, TimeOfDay end) {
    if (end.isBefore(start)) {
      showUiKitAlertDialog(
          navigatorKey.currentContext!,
          AlertDialogData(
              title:
                  Text(S.current.TimeRangeError, style: navigatorKey.currentContext!.uiKitTheme?.regularTextTheme.body),
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
    String? errorText;

    return StatefulBuilder(builder: (context, setState) {
      final MapEntry<String, List<TimeOfDay>> thisObject =
          weeklySchedule.isNotEmpty && weeklySchedule.length > index ? weeklySchedule[index] : const MapEntry('', []);
      log('rebuild is here $thisObject', name: 'UiScheduleTimeModel');
      log('index is $index', name: 'UiScheduleTimeModel');
      return _CardListWrapper(
        children: [
          UiKitAddableFormField(
            title: S.current.Time,
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
            child: AddableFormChildTime<DateTimeRange>(
              initialValue:
                  thisObject.value.isEmpty ? null : createTimeRange(thisObject.value.first, thisObject.value.last),
              onChanged: () => showUiKitTimeFromToDialog(
                navigatorKey.currentContext!,
                (TimeOfDay? from, TimeOfDay? to) {
                  if (from != null || to != null) {
                    if (from != null && (to?.isBefore(from) ?? false)) {
                      setState(() {
                        errorText = S.of(context).StartTimeShouldBeEarlierThanEndTime;
                      });
                      return;
                    } else {
                      setState(() {
                        errorText = null;
                      });
                    }
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
          if (errorText != null)
            Text(
              errorText!,
              style: context.uiKitTheme?.boldTextTheme.body.copyWith(
                color: ColorsFoundation.error,
              ),
            ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing4),
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
        .map((e) => ['${e.key}:', (e.value.map((time) => '${time.hour}-${time.minute}').join(', '))])
        .toList();
  }
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
              child: AddableFormChildTime<DateTime>(
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
              child: AddableFormChildTime<DateTime>(
                initialValue: DateTime(2020, 1, 1, time.hour, time.minute),
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
    return dailySchedule
        .map((e) => ['${e.key}:', e.value.map((time) => '${time.hour}-${time.minute}').join(', ')])
        .toList();
  }
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
              title: S.current.Time,
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
              child: AddableFormChildTime<DateTimeRange>(
                onChanged: () async {
                  final result = await showUiKitTimeDialog(navigatorKey.currentContext!);
                  if (result != null) {
                    if (dailySchedule[index].key.isNotEmpty) {
                      final nowTime = TimeOfDay.now();
                      if (atSameDayDatesRange(dailySchedule[index].key) &&
                          result.hour < nowTime.hour &&
                          result.minute < nowTime.minute) {
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
              child: AddableFormChildTime<DateTime>(
                initialValue: DateTime(2020, 1, 1, time.hour, time.minute),
                onChanged: () async {
                  final result = await showUiKitTimeDialog(navigatorKey.currentContext!);
                  if (result != null) {
                    if (dailySchedule[index].key.isNotEmpty) {
                      final nowTime = TimeOfDay.now();
                      if (atSameDayDatesRange(dailySchedule[index].key) &&
                          result.hour < nowTime.hour &&
                          result.minute < nowTime.minute) {
                        setState(() {
                          errorText = S.current.TheSelectedTimeCannotBeElapsed;
                        });
                        return;
                      } else if (errorText != null) {
                        setState(() {
                          errorText = null;
                        });
                      }
                    }
                  } else {
                    setState(() {
                      errorText = S.of(context).ItNecessaryToChooseADay;
                    });
                    return;
                  }

                  final originalTimes = thisObject.value;
                  originalTimes[i] = result;
                  setState(() {
                    dailySchedule[index] = MapEntry(thisObject.key, originalTimes);
                  });
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
    return dailySchedule
        .map((e) => ['${e.key}:', e.value.map((time) => '${time.hour}-${time.minute}').join(', ')])
        .toList();
  }
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
