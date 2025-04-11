// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/src/iterable_extensions.dart';

class CreateNotificationOrRemind extends StatefulWidget {
  final bool isNotification;
  final UniversalNotOfferRemUiModel? universalNotOfferRemUiModel;
  final ValueChanged<UniversalNotOfferRemUiModel>? onCreate;
  final bool Function(DateTime)? selectableDayPredicate;
  final Map<int, String>? iconsList;
  final bool isOneDate;

  const CreateNotificationOrRemind({
    super.key,
    this.isNotification = true,
    this.universalNotOfferRemUiModel,
    this.onCreate,
    this.selectableDayPredicate,
    this.iconsList,
    this.isOneDate = false,
  });

  @override
  State<CreateNotificationOrRemind> createState() => _CreateNotificationOrRemindState();
}

class _CreateNotificationOrRemindState extends State<CreateNotificationOrRemind> {
  late UniversalNotOfferRemUiModel _universalNotOfferRemUiModel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();

  final List<DateTime?> _selectedDates = [];
  late DateTime? _isLaunchedDate = DateTime.now();

  late bool _isLaunched;

  int? _selectedIconIndex;
  late List<String> _iconsList;

  @override
  void initState() {
    super.initState();
    _universalNotOfferRemUiModel = widget.universalNotOfferRemUiModel ?? UniversalNotOfferRemUiModel(id: -1);
    _titleController.text = widget.universalNotOfferRemUiModel?.title ?? '';
    _isLaunched = widget.universalNotOfferRemUiModel?.isLaunched ?? false;
    _isLaunchedDate = widget.universalNotOfferRemUiModel?.isLaunchedDate;
    _selectedDates.addAll(widget.universalNotOfferRemUiModel?.selectedDates?.toList() ?? [null]);
    _iconsList = widget.iconsList?.values.toList() ?? [];
    _iconsList.firstWhereIndexedOrNull(
      (index, element) {
        if (element == widget.universalNotOfferRemUiModel?.iconPath) {
          _selectedIconIndex = index;
          return true;
        } else {
          _selectedIconIndex = null;
          return false;
        }
      },
    );
  }

  @override
  void didUpdateWidget(covariant CreateNotificationOrRemind oldWidget) {
    if (oldWidget.universalNotOfferRemUiModel != widget.universalNotOfferRemUiModel) {
      _universalNotOfferRemUiModel = widget.universalNotOfferRemUiModel ?? UniversalNotOfferRemUiModel(id: -1);
      _titleController.text = widget.universalNotOfferRemUiModel?.title ?? '';
      _isLaunched = widget.universalNotOfferRemUiModel?.isLaunched ?? false;
      _isLaunchedDate = widget.universalNotOfferRemUiModel?.isLaunchedDate;
      _selectedDates.clear();
      _selectedDates.addAll(widget.universalNotOfferRemUiModel?.selectedDates?.toList() ?? [null]);
      _iconsList = widget.iconsList?.values.toList() ?? [];
      _iconsList.firstWhereIndexedOrNull(
        (index, element) {
          if (element == widget.universalNotOfferRemUiModel?.iconPath) {
            _selectedIconIndex = index;
            return true;
          } else {
            _selectedIconIndex = null;
            return false;
          }
        },
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  void _onSubmit() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      if (widget.isNotification && _selectedDates.first == null) return;

      late final String? iconPath;
      late final int? iconId;

      if (_selectedIconIndex != null) {
        iconPath = _iconsList[_selectedIconIndex!];
        iconId = widget.iconsList!.keys.firstWhereOrNull(
          (k) => widget.iconsList?[k] == _iconsList[_selectedIconIndex!],
        );
      } else {
        iconPath = null;
        iconId = null;
      }

      _universalNotOfferRemUiModel = _universalNotOfferRemUiModel.copyWith(
        title: _titleController.text.trim(),
        iconId: iconId,
        iconPath: iconPath,
        isLaunched: _isLaunched,
        selectedDates: _selectedDates,
        isLaunchedDate: _isLaunchedDate ?? DateTime.now(),
      );
      widget.onCreate?.call(_universalNotOfferRemUiModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        customTitle: Flexible(
          child: AutoSizeText(
            widget.isNotification ? S.of(context).Notification : S.of(context).Reminder,
            style: theme?.boldTextTheme.title1,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
        centerTitle: true,
        autoImplyLeading: true,
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        children: [
          if (widget.universalNotOfferRemUiModel != null &&
              widget.universalNotOfferRemUiModel?.status == TicketIssueStatus.paid)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    _isLaunched ? S.of(context).Launched : S.of(context).Paused,
                    style: theme?.regularTextTheme.labelLarge,
                  ),
                ),
                UiKitGradientSwitch(
                  onChanged: (value) {
                    setState(() {
                      _isLaunched = !_isLaunched;
                      _isLaunched != widget.universalNotOfferRemUiModel?.isLaunched
                          ? _isLaunchedDate = DateTime.now().toLocal()
                          : _isLaunchedDate = widget.universalNotOfferRemUiModel?.isLaunchedDate ?? DateTime.now();
                    });
                  },
                  switchedOn: _isLaunched,
                ),
              ],
            ).paddingOnly(top: SpacingFoundation.verticalSpacing16),
          SpacingFoundation.verticalSpace16,
          Form(
            key: _formKey,
            child: IntrinsicHeight(
              child: UiKitInputFieldNoFill(
                label: widget.isNotification ? S.of(context).NotificationText : S.of(context).YourEvent,
                maxSymbols: 45,
                expands: true,
                controller: _titleController,
                onChanged: (value) {
                  setState(() {
                    _formKey.currentState?.validate();
                  });
                },
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return S.of(context).PleaseEnterValidTitle;
                  }
                  if (value != null && value.isNotEmpty) {
                    final newValue = value.replaceAll(' ', '');

                    if (newValue == '') {
                      return S.of(context).PleaseEnterValidTitle;
                    }
                  }
                  return null;
                },
              ),
            ),
          ),
          if (widget.isNotification) ...[
            SpacingFoundation.verticalSpace24,
            Text(
              widget.isNotification ? S.of(context).SelectPeriodOfValid : S.of(context).SelectDate,
              style: theme?.regularTextTheme.labelSmall,
            ),
            SpacingFoundation.verticalSpace2,
            UiKitSelectDateWidget(
              selectedDates: _selectedDates,
              selectableDayPredicate: widget.selectableDayPredicate,
              isOneDate: widget.isOneDate,
              onCalenderTap: () async {
                _selectedDates.clear();
                if (widget.isOneDate) {
                  final today = DateTime.now();

                  final DateTime? date = await showDatePicker(
                    context: context,
                    firstDate: today.add(const Duration(days: 1)),
                    lastDate: today.add(const Duration(days: 60)),
                    selectableDayPredicate: widget.selectableDayPredicate,
                  );

                  if (date != null) {
                    _selectedDates.addAll([date]);
                    setState(() {});
                  }
                } else {
                  final dates = await showDateRangePickerDialog(context);

                  if (dates != null) {
                    final DateTime now = DateTime.now();
                    final List<DateTime> generateDateList = generateDateRange([dates.start, dates.end]);

                    if (generateDateList.isEmpty) {
                      setState(() {
                        _selectedDates.add(null);
                      });
                    } else if (widget.selectableDayPredicate != null &&
                        !generateDateList.any((element) => widget.selectableDayPredicate!(element))) {
                      setState(() {
                        _selectedDates.add(null);
                      });
                    } else if ((!dates.start.isBefore(now)) ||
                        (((!dates.start.isBefore(now) || dates.start.isAtSameDay) && !dates.end.isBefore(now))) ||
                        (dates.start.isAtSameDay && dates.end.isAtSameDay)) {
                      setState(() {
                        _selectedDates.addAll([dates.start, dates.end]);
                      });
                    } else if (dates.start.isAtSameDayAs(dates.end)) {
                      setState(() {
                        _selectedDates.addAll([dates.start]);
                      });
                    } else {
                      setState(() {
                        _selectedDates.add(null);
                      });
                    }
                  }
                }
              },
            ),
          ],
          SpacingFoundation.verticalSpace24,
          if (!widget.isNotification) ...[
            Text(
              S.of(context).PersonalizeYourReminder,
              style: theme?.regularTextTheme.labelSmall,
            ),
            SpacingFoundation.verticalSpace8,
            UiKitSelectedIconWidget(
              iconList: _iconsList,
              onIconTap: (index) {
                setState(() {
                  if (_selectedIconIndex != index) {
                    _selectedIconIndex = index;
                  } else {
                    _selectedIconIndex = null;
                  }
                });
              },
              selectedIndex: _selectedIconIndex,
            ),
            SpacingFoundation.verticalSpace16,
          ],
          Text(
            widget.isNotification
                ? S.of(context).YourNotificationWillBeShown
                : widget.universalNotOfferRemUiModel == null
                    ? S.of(context).YourReminderIsShown1Time
                    : S.of(context).YourReminderIsShown1TimeMax3,
            style: theme?.boldTextTheme.caption1Medium.copyWith(color: ColorsFoundation.mutedText),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight + EdgeInsetsFoundation.vertical24,
        child: SafeArea(
          top: false,
          child: context.gradientButton(
            data: BaseUiKitButtonData(
              autoSizeGroup: AutoSizeGroup(),
              text: widget.isNotification
                  ? widget.universalNotOfferRemUiModel != null
                      ? S.of(context).Save
                      : S.of(context).SaveAndPay
                  : S.of(context).Save,
              fit: ButtonFit.fitWidth,
              onPressed: () => _onSubmit(),
            ),
          ),
        ).paddingOnly(
          bottom: SpacingFoundation.verticalSpacing24,
          left: SpacingFoundation.horizontalSpacing16,
          right: SpacingFoundation.horizontalSpacing16,
        ),
      ),
    );
  }
}
