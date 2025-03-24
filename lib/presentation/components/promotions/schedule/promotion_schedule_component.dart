import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/promotions/schedule/promotion_schedule_ui_model.dart';
import 'package:shuffle_components_kit/services/navigation_service/navigation_key.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../common/select_one_type_with_bottom.dart';
import '../../../widgets/card_list_widget.dart';

class PromotionScheduleComponent extends StatefulWidget {
  final ValueChanged<PromotionScheduleUiModel>? onScheduleDrafted;
  const PromotionScheduleComponent({super.key, this.onScheduleDrafted});

  @override
  State<PromotionScheduleComponent> createState() => _PromotionScheduleComponentState();
}

class _PromotionScheduleComponentState extends State<PromotionScheduleComponent> {
  DateTime? startTime, endTime;
  ShowTimeType showTimeType = ShowTimeType.continuously;
  ScheduleSetting scheduleSetting = ScheduleSetting.everyday;
  List<MapEntry<String, TimeRange>> scheduleRanges = List.empty(growable: true);

  @override
  void initState() {
    FocusManager.instance.addListener(_draftSchedule);
    super.initState();
  }

  _draftSchedule(){
    if(mounted){
      widget.onScheduleDrafted?.call(PromotionScheduleUiModel(
        startDate: startTime,
        endDate: endTime,
        showTimeType: showTimeType,
        scheduleSetting: scheduleSetting,
        hourlySchedule: scheduleRanges,
      ));
    }
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_draftSchedule);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final bodyText = theme?.regularTextTheme.body;
    final labelSmall = theme?.regularTextTheme.labelSmall;
    return BlurredAppBarPage(
      title: S.current.Timing,
      centerTitle: true,
      autoImplyLeading: true,
      childrenPadding: EdgeInsets.symmetric(
          horizontal: SpacingFoundation.horizontalSpacing12, vertical: SpacingFoundation.verticalSpacing4),
      children: [
        SpacingFoundation.verticalSpace16,
        UiKitCardWrapper(
          padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              S.current.ShowTime,
              style: bodyText,
            ),
            UiKitRadioTile(
              selected: showTimeType == ShowTimeType.continuously,
              title: ShowTimeType.continuously.showTimeTypeDescription,
              onTapped: () {
                setState(() {
                  showTimeType = ShowTimeType.continuously;
                });
              },
            ),
            UiKitRadioTile(
              selected: showTimeType == ShowTimeType.setStartEndDates,
              title: ShowTimeType.setStartEndDates.showTimeTypeDescription,
              onTapped: () {
                setState(() {
                  showTimeType = ShowTimeType.setStartEndDates;
                });
              },
            )
          ],
        )),
        if (showTimeType == ShowTimeType.setStartEndDates)
          CardListWidget(children: [
            Text(
              S.current.Start,
              style: labelSmall,
            ),
            AddableFormChildDateWeek<DateTime>(
              initialValue: startTime,
              onChanged: () async {
                final result = await showUiKitCalendarDialog(
                  context,
                  firstDate: DateTime.now(),
                  selectableDayPredicate: (day) {
                    return day.toLocal().isAfter(DateTime.now().toLocal()) || (day.toLocal().isAtSameDay);
                  },
                );
                if (result != null) {
                  setState(() {
                    startTime = result;
                  });
                }
              },
            ),
            Text(
              S.current.Ending,
              style: labelSmall,
            ),
            AddableFormChildDateWeek<DateTime>(
                initialValue: endTime,
                onChanged: () async {
                  final result = await showUiKitCalendarDialog(
                    context,
                    firstDate: startTime ?? DateTime.now(),
                    selectableDayPredicate: (day) {
                      return day.toLocal().isAfter(DateTime.now().toLocal()) || (day.toLocal().isAtSameDay) && (startTime!=null ? (day.toLocal().isAfter(startTime!.toLocal()) || (day.toLocal().isAtSameDayAs(startTime!))) : true);
                    },
                  );
                  if (result != null) {
                    setState(() {
                      endTime = result;
                    });
                  }
                })
          ]),
        SelectOneTypeWithBottom(
          placeholderType: S.current.ShowSchedule,
          selectedItem: scheduleSetting.scheduleSettingDescription,
          items: ScheduleSetting.values.map((item) => item.scheduleSettingDescription).toList(),
          onSelect: (e) {
            setState(() {
              scheduleSetting = ScheduleSetting.values.firstWhere((el) => el.scheduleSettingDescription == e);
            });
            navigatorKey.currentContext?.pop();
          },
        ),
        SpacingFoundation.verticalSpace2,
        if (scheduleSetting == ScheduleSetting.hourlySet)
          if (scheduleRanges.isEmpty)
            CardListWidget(
              children: [
                UiKitAddableFormField(
                  title: S.current.TimeRange,
                  onAdd: () {
                    setState(() {
                      scheduleRanges.add(const MapEntry('', TimeRange()));
                    });
                  },
                  isAbleToRemove: false,
                  onRemove: null,
                  child: AddableFormChildTime<TimeRange>(
                    initialValue: null,
                    onChanged: () => showUiKitTimeFromToDialog(
                      context,
                      (TimeOfDay? from, TimeOfDay? to) {
                        if (from != null && to != null) {
                          final newValues = TimeRange(start: from, end: to);

                          setState(() {
                            scheduleRanges.add(MapEntry('', newValues));
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
                    initialValue: null,
                    onChanged: () async {
                      final result = await showUiKitWeekdaySelector(context);
                      if (result != null) {
                        setState(() {
                          scheduleRanges.add(MapEntry(result.join(', '), TimeRange()));

                          // log('weeklySchedule ${weeklySchedule}', name: 'UiScheduleTimeModel');
                        });
                      }
                    },
                  ),
                ),
              ],
            )
          else
            for (var i in scheduleRanges)
              CardListWidget(
                children: [
                  UiKitAddableFormField(
                    title: S.current.TimeRange,
                    onAdd: () {
                      // onAdd?.call();
                      setState(() {
                        scheduleRanges.add(const MapEntry('', TimeRange()));
                      });
                    },
                    isAbleToRemove: scheduleRanges.indexOf(i) > 0,
                    onRemove: scheduleRanges.indexOf(i) > 0
                        ? () {
                            setState(() {
                              scheduleRanges.removeAt(scheduleRanges.indexOf(i));
                            });
                          }
                        : null,
                    child: AddableFormChildTime<TimeRange>(
                      initialValue: i.value.isEmpty ? null : i.value,
                      onChanged: () => showUiKitTimeFromToDialog(
                        context,
                        (TimeOfDay? from, TimeOfDay? to) {
                          if (from != null && to != null) {
                            final newValues = TimeRange(start: from, end: to);

                            setState(() {
                              if (scheduleRanges.isNotEmpty && scheduleRanges.length > scheduleRanges.indexOf(i)) {
                                scheduleRanges[scheduleRanges.indexOf(i)] = MapEntry(i.key, newValues);
                              } else {
                                scheduleRanges.add(MapEntry(i.key, newValues));
                              }
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
                      initialValue: i.key,
                      onChanged: () async {
                        final result = await showUiKitWeekdaySelector(context);
                        if (result != null) {
                          setState(() {
                            if (scheduleRanges.isNotEmpty && scheduleRanges.length > scheduleRanges.indexOf(i)) {
                              scheduleRanges[scheduleRanges.indexOf(i)] = MapEntry(result.join(', '), i.value);
                            } else {
                              scheduleRanges.add(MapEntry(result.join(', '), i.value));
                            }
                            // log('weeklySchedule ${weeklySchedule}', name: 'UiScheduleTimeModel');
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
        kBottomNavigationBarHeight.heightBox
      ],
    );
  }
}
