import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import '../../feed/uifeed_model.dart';

class SchedulerComponent extends StatefulWidget {
  final ScrollController scrollController;
  final DateTime focusedDate;

  //could be event component or place component
  final Future<List<UiUniversalModel>> Function(DateTime firstDay, DateTime lastDay) eventLoader;
  final Function(DateTime focusedDay)? onPageChanged;
  final ValueChanged<UiUniversalModel>? openContentCallback;

  const SchedulerComponent(
      {super.key,
      required this.scrollController,
      required this.focusedDate,
      required this.eventLoader,
      this.onPageChanged,
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

  PageController? pageController;

  DateTime get firstDayToLoad {
    final firstMonthDay = DateTime(focusedDate.year, focusedDate.month, 1);
    return firstMonthDay.subtract(Duration(days: firstMonthDay.weekday - 1));
  }

  DateTime get lastDayToLoad {
    final lastMonthDay = DateTime(focusedDate.year, focusedDate.month, 1)
        .add(Duration(days: DateUtils.getDaysInMonth(focusedDate.year, focusedDate.month)))
        .subtract(Duration(days: 1));
    return lastMonthDay.add(Duration(days: 7 - lastMonthDay.weekday));
  }

  DateTime get firstDay {
    final today = DateTime.now();
    final firstMonthDay = DateTime(today.year, today.month, 1);
    return firstMonthDay;
    // return firstMonthDay.subtract(Duration(days: firstMonthDay.weekday - 1));
  }

  DateTime get lastDay => DateTime(DateTime.now().year + 1, 12, 31);

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState(() {
      currentContent.clear();
    });
    currentContent.addAll(await widget.eventLoader(firstDayToLoad, lastDayToLoad));
    setState(() {
      if (currentContent.isNotEmpty &&
          !currentContent.any((e) => e.shouldVisitAt?.isAtSameDayAs(focusedDate) ?? false)) {
        focusedDate = currentContent
                .firstWhereOrNull((e) => e.shouldVisitAt != null && e.shouldVisitAt?.month == focusedDate.month)
                ?.shouldVisitAt! ??
            focusedDate;
      }
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

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    return BlurredAppBarPage(
      autoImplyLeading: true,
      title: S.of(context).Scheduler,
      controller: widget.scrollController,
      centerTitle: true,
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
                      pageController?.previousPage(duration: pageTransitionDuration, curve: pageTransitionCurve);
                    },
              iconData: ShuffleUiKitIcons.chevronleft,
            ),
            SpacingFoundation.horizontalSpace16,
            FlatCircleButton(
              onTap: () {
                pageController?.nextPage(duration: pageTransitionDuration, curve: pageTransitionCurve);
              },
              iconData: ShuffleUiKitIcons.chevronright,
            ),
          ],
        ).paddingSymmetric(
            horizontal: SpacingFoundation.horizontalSpacing16, vertical: SpacingFoundation.verticalSpacing16),
        UiKitCalendarCompact(
          onCalendarCreated: (controller) {
            pageController = controller;
          },
          enabledDayPredicate: enabledDayPredicate,
          eventLoader: eventLoader,
          focusedDate: focusedDate,
          firstDay: firstDay,
          lastDay: lastDay,
          onPageChanged: (DateTime focusedDay) {
            if (focusedDay.month != focusedDate.month) {
              setState(() {
                focusedDate = focusedDay;
                wasChangedDateToSpecific = false;
              });
              widget.onPageChanged?.call(focusedDay);
              fetchData();
            }
          },
          onDaySelected: (
            DateTime selectedDay,
            DateTime focusedDay,
          ) {
            setState(() {
              focusedDate = focusedDay;
              wasChangedDateToSpecific = true;
            });
          },
        ),
        SpacingFoundation.verticalSpace24,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).Details,
              style: theme?.boldTextTheme.title2,
            ).paddingSymmetric(
              horizontal: SpacingFoundation.horizontalSpacing16,
            ),
            wasChangedDateToSpecific ? Text(DateFormat('dd.MM.yyyy').format(focusedDate)) : const SizedBox.shrink(),
          ],
        ),
        SpacingFoundation.verticalSpace16,
        for (var content in (wasChangedDateToSpecific
            ? currentContent.where((e) => e.shouldVisitAt?.isAtSameDayAs(focusedDate) ?? false)
            : currentContent))
          UiKitPlannerContentCard(
            onTap: () => widget.openContentCallback?.call(content),
            avatarPath: content.media.firstWhereOrNull((el) => el.previewType == UiKitPreviewType.vertical)?.link ??
                content.media.firstWhere((el) => el.type == UiKitMediaType.image).link,
            contentTitle: content.title ?? '',
            tags: content.baseTags ?? [],
            dateTime: content.shouldVisitAt ?? DateTime.now(),
          ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
        MediaQuery.of(context).viewInsets.bottom.heightBox
      ],
    );
  }
}
