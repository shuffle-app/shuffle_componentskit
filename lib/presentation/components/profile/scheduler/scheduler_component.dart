import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/presentation.dart';
import 'package:shuffle_components_kit/services/navigation_service/navigation_key.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../feed/uifeed_model.dart';

class SchedulerComponent extends StatefulWidget {
  final ScrollController scrollController;
  final DateTime focusedDate;

  //could be event component or place component
  final Future<List<UiUniversalModel>> Function(DateTime firstDay, DateTime lastDay) eventLoader;
  final Function(DateTime focusedDay)? onPageChanged;
  final ValueChanged<UiUniversalModel>? openContentCallback;
  final ValueChanged<UiUniversalModel>? onContentDeleted;
  final AsyncValueChanged<UiUniversalModel, UiUniversalModel>? onNotificationSetRequested;

  const SchedulerComponent(
      {super.key,
      required this.scrollController,
      required this.focusedDate,
      required this.eventLoader,
      this.onPageChanged,
      this.onContentDeleted,
      this.onNotificationSetRequested,
      this.openContentCallback});

  @override
  State<SchedulerComponent> createState() => _SchedulerComponentState();
}

class _SchedulerComponentState extends State<SchedulerComponent> with SingleTickerProviderStateMixin {
  late DateTime focusedDate = widget.focusedDate;
  final List<UiUniversalModel> currentContent = List.empty(growable: true);
  final Duration pageTransitionDuration = Duration(milliseconds: 300);
  final Curve pageTransitionCurve = Curves.easeInOut;
  bool wasChangedDateToSpecific = false;
  final Duration showingDuration = const Duration(milliseconds: 170);
  double showingOpacity = 0.0;
  final List<int> deletedCards = List.empty(growable: true);

  PageController? pageController;
  CalendarFormat calendarFormat = CalendarFormat.week;

  DateTime get firstDayToLoad {
    if (calendarFormat == CalendarFormat.week) {
      final firstWeekDay = focusedDate.subtract(Duration(days: focusedDate.weekday));
      return firstWeekDay;
    } else {
      final firstMonthDay = DateTime(focusedDate.year, focusedDate.month, 1);
      return firstMonthDay.subtract(Duration(days: firstMonthDay.weekday - 1));
    }
  }

  DateTime get lastDayToLoad {
    if (calendarFormat == CalendarFormat.week) {
      final lastWeekDay = focusedDate.add(Duration(days: 7 - focusedDate.weekday));
      return lastWeekDay;
    }
    final lastMonthDay = DateTime(focusedDate.year, focusedDate.month, 1)
        .add(Duration(days: DateUtils.getDaysInMonth(focusedDate.year, focusedDate.month)))
        .subtract(Duration(days: 1));
    return lastMonthDay.add(Duration(days: 7 - lastMonthDay.weekday)).add(Duration(days: 1));
  }

  DateTime get firstDay {
    final today = DateTime.now();
    final firstMonthDay = DateTime(today.year, today.month, 1);
    return firstMonthDay;
  }

  DateTime get lastDay => DateTime(DateTime.now().year + 1, 12, 31);

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData({DateTime? newFocusedDate, bool needResetData = true}) async {
    if (needResetData) {
      setState(() {
        showingOpacity = 0;
        wasChangedDateToSpecific = false;
      });
    }
    Future.delayed(showingDuration, currentContent.clear);
    if (newFocusedDate != null) {
      setState(() {
        focusedDate = newFocusedDate;
      });
    }
    currentContent.addAll(await widget.eventLoader(firstDayToLoad, lastDayToLoad));
    setState(() {
      if (currentContent.isNotEmpty &&
          !currentContent.any((e) => e.shouldVisitAt?.isAtSameDayAs(focusedDate) ?? false)) {
        focusedDate = currentContent
                .firstWhereOrNull((e) => e.shouldVisitAt != null && e.shouldVisitAt?.month == focusedDate.month)
                ?.shouldVisitAt! ??
            focusedDate;
      }
      showingOpacity = 1;
    });
  }

  bool enabledDayPredicate(DateTime day) {
    return currentContent.any((e) => e.shouldVisitAt?.isAtSameDayAs(day) ?? false);
  }

  List<String> eventLoader(DateTime day) {
    return currentContent
        .where((e) => e.shouldVisitAt?.isAtSameDayAs(day) ?? false)
        .map((e) =>
            e.media.firstWhereOrNull((el) => el.previewType == UiKitPreviewType.vertical)?.link ??
            e.media.firstWhere((el) => el.type == UiKitMediaType.image).link)
        .toList();
  }

  updateOne(UiUniversalModel event,) {
    setState(() {
      final index = currentContent.indexWhere((i) => i.id == event.id);
      currentContent[index] = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    return BlurredAppBarPage(
      autoImplyLeading: true,
      title: S.of(context).Scheduler,
      controller: widget.scrollController,
      centerTitle: true,
      appBarTrailing: context.iconButtonNoPadding(
          data: BaseUiKitButtonData(
              onPressed: () {
                setState(() {
                  if (calendarFormat == CalendarFormat.week) {
                    calendarFormat = CalendarFormat.month;
                  } else {
                    calendarFormat = CalendarFormat.week;
                  }
                  wasChangedDateToSpecific = false;
                });
                fetchData();
              },
              iconInfo: BaseUiKitButtonIconData(
                  iconData: calendarFormat == CalendarFormat.week
                      ? ShuffleUiKitIcons.calendar
                      : CupertinoIcons.list_bullet_below_rectangle,
                  color: theme?.colorScheme.inversePrimary))),
      children: [
        Row(
          children: [
            Expanded(
                child: Text(
              DateFormat('MMMM yyyy').format(focusedDate),
              style: theme?.boldTextTheme.title2,
            )),
            SpacingFoundation.horizontalSpace4,
            FlatCircleButton(
              onTap: pageController?.page == 0
                  ? null
                  : () {
                      FeedbackIsolate.instance.addEvent(FeedbackIsolateHaptics(intensities: [100]));
                      pageController?.previousPage(duration: pageTransitionDuration, curve: pageTransitionCurve);
                    },
              iconData: ShuffleUiKitIcons.chevronleft,
            ),
            SpacingFoundation.horizontalSpace16,
            FlatCircleButton(
              onTap: () {
                FeedbackIsolate.instance.addEvent(FeedbackIsolateHaptics(intensities: [100]));
                pageController?.nextPage(duration: pageTransitionDuration, curve: pageTransitionCurve);
              },
              iconData: ShuffleUiKitIcons.chevronright,
            ),
          ],
        ).paddingSymmetric(
            horizontal: SpacingFoundation.horizontalSpacing16, vertical: SpacingFoundation.verticalSpacing16),
        UiKitCalendarCompact(
          calendarFormat: calendarFormat,
          onCalendarCreated: (controller) {
            pageController = controller;
          },
          enabledDayPredicate: enabledDayPredicate,
          wasChangedDateToSpecific: wasChangedDateToSpecific,
          eventLoader: eventLoader,
          focusedDate: focusedDate,
          firstDay: firstDay,
          lastDay: lastDay,
          onPageChanged: (DateTime focusedDay) {
            if (focusedDay.month != focusedDate.month || calendarFormat == CalendarFormat.week) {
              FeedbackIsolate.instance.addEvent(FeedbackIsolateHaptics(intensities: [100]));

              // setState(() {
              //   focusedDate = focusedDay;
              //   wasChangedDateToSpecific = false;
              // });
              widget.onPageChanged?.call(focusedDay);
              fetchData(newFocusedDate: focusedDay);
            }
          },
          onDaySelected: (
            DateTime selectedDay,
            DateTime focusedDay,
          ) async {
            if (!selectedDay.isAtSameDayAs(focusedDay)) {
              return;
            }
            setState(() {
              showingOpacity = 0;
            });
            FeedbackIsolate.instance.addEvent(FeedbackIsolateHaptics(intensities: [100]));
            await Future.delayed(
              showingDuration,
            );
            setState(() {
              if (focusedDate.isAtSameDayAs(focusedDay) && wasChangedDateToSpecific) {
                wasChangedDateToSpecific = false;
              } else {
                wasChangedDateToSpecific = true;
              }
              focusedDate = focusedDay;
              showingOpacity = 1;
            });
          },
        ),
        SpacingFoundation.verticalSpace24,
        if (currentContent.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).Details,
                style: theme?.boldTextTheme.title2,
              ).paddingSymmetric(
                horizontal: SpacingFoundation.horizontalSpacing16,
              ),
              wasChangedDateToSpecific
                  ? Text(
                      DateFormat('dd.MM.yyyy').format(focusedDate),
                      style: theme?.regularTextTheme.bodyUpperCase.copyWith(color: ColorsFoundation.mutedText),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        SpacingFoundation.verticalSpace16,
        for (var content in (wasChangedDateToSpecific
            ? currentContent.where((e) => e.shouldVisitAt?.isAtSameDayAs(focusedDate) ?? false)
            : currentContent))
          AnimatedOpacity(
              opacity: showingOpacity,
              duration: showingDuration,
              child: Dismissible(
                  key: ValueKey(content.id),
                  direction: DismissDirection.endToStart,
                  background: UiKitBackgroundDismissible(),
                  confirmDismiss: (direction) async {
                    bool confirmation = false;

                    await showUiKitAlertDialog(
                        context,
                        AlertDialogData(
                            title: Text(
                              S.of(context).YouSureToDeleteX(content.title ?? ''),
                              style: theme?.boldTextTheme.title2.copyWith(color: Colors.black),
                            ),
                            defaultButtonText: S.of(context).Cancel,
                            additionalButton: context.dialogButton(
                                small: true,
                                dialogButtonType: DialogButtonType.buttonRed,
                                data: BaseUiKitButtonData(
                                    text: S.of(context).Confirm,
                                    onPressed: () {
                                      confirmation = true;
                                      navigatorKey.currentState?.pop();
                                    }))));

                    return confirmation;
                  },
                  dismissThresholds: {DismissDirection.endToStart: 0.5},
                  onDismissed: (direction) async {
                    setState(() {
                      deletedCards.add(content.id);
                      currentContent.removeWhere((e) => e.id == content.id);
                    });
                    widget.onContentDeleted?.call(content);
                    await Future.delayed(const Duration(milliseconds: 500), fetchData);
                  },
                  child: UiKitPlannerContentCard(
                    onNotification: () =>
                        widget.onNotificationSetRequested?.call(content).then((e) => updateOne(e)),
                    showNotificationSet: content.hasNotificationSet,
                    onTap: () => widget.openContentCallback?.call(content),
                    avatarPath:
                        content.media.firstWhereOrNull((el) => el.previewType == UiKitPreviewType.vertical)?.link ??
                            content.media.firstWhere((el) => el.type == UiKitMediaType.image).link,
                    contentTitle: content.title ?? '',
                    tags: content.baseTags ?? [],
                    dateTime: content.shouldVisitAt ?? DateTime.now(),
                  ))).paddingSymmetric(
              horizontal: EdgeInsetsFoundation.horizontal16, vertical: EdgeInsetsFoundation.vertical8),
        SpacingFoundation.verticalSpace24,
        MediaQuery.of(context).viewInsets.bottom.heightBox
      ],
    );
  }
}
