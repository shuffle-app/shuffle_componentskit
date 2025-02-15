import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CreateNotificationOrRemind extends StatefulWidget {
  final bool isNotification;
  final UniversalNotOfferRemUiModel? universalNotOfferRemUiModel;
  final ValueChanged<UniversalNotOfferRemUiModel>? onCreate;
  final bool Function(DateTime)? selectableDayPredicate;

  const CreateNotificationOrRemind({
    super.key,
    this.isNotification = true,
    this.universalNotOfferRemUiModel,
    this.onCreate,
    this.selectableDayPredicate,
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

  late int? _selectedIconIndex;
  final List<String> _iconList = [];

  @override
  void initState() {
    super.initState();
    _universalNotOfferRemUiModel = widget.universalNotOfferRemUiModel ?? UniversalNotOfferRemUiModel(id: -1);
    _titleController.text = widget.universalNotOfferRemUiModel?.title ?? '';
    _isLaunched = widget.universalNotOfferRemUiModel?.isLaunched ?? true;
    _isLaunchedDate = widget.universalNotOfferRemUiModel?.isLaunchedDate;
    _selectedDates.addAll(widget.universalNotOfferRemUiModel?.selectedDates?.toList() ?? [null]);
    for (var element in GraphicsFoundation.instance.png.reminder.values) {
      _iconList.add(element.path);
    }
    _selectedIconIndex =
        _iconList.indexWhere((element) => element == (widget.universalNotOfferRemUiModel?.iconPath ?? 0));
  }

  @override
  void didUpdateWidget(covariant CreateNotificationOrRemind oldWidget) {
    _universalNotOfferRemUiModel = widget.universalNotOfferRemUiModel ?? UniversalNotOfferRemUiModel(id: -1);
    _titleController.text = widget.universalNotOfferRemUiModel?.title ?? '';
    _isLaunched = widget.universalNotOfferRemUiModel?.isLaunched ?? true;
    _isLaunchedDate = widget.universalNotOfferRemUiModel?.isLaunchedDate;
    _selectedDates.clear();
    _selectedDates.addAll(widget.universalNotOfferRemUiModel?.selectedDates?.toList() ?? [null]);
    for (var element in GraphicsFoundation.instance.png.reminder.values) {
      _iconList.add(element.path);
    }
    _selectedIconIndex =
        _iconList.indexWhere((element) => element == (widget.universalNotOfferRemUiModel?.iconPath ?? 0));
    super.didUpdateWidget(oldWidget);
  }

  void _onSubmit() {
    if (_formKey.currentState != null && _formKey.currentState!.validate() && _selectedDates.first != null) {
      _universalNotOfferRemUiModel = _universalNotOfferRemUiModel.copyWith(
        title: _titleController.text.trim(),
        iconPath: (_selectedIconIndex == -1 || _selectedIconIndex == null) ? null : _iconList[_selectedIconIndex!],
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
          if (widget.universalNotOfferRemUiModel != null)
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
          SpacingFoundation.verticalSpace24,
          Text(
            widget.isNotification ? S.of(context).SelectPeriodOfValid : S.of(context).SelectDate,
            style: theme?.regularTextTheme.labelSmall,
          ),
          SpacingFoundation.verticalSpace2,
          UiKitSelectDateWidget(
            selectedDates: _selectedDates,
            selectableDayPredicate: widget.selectableDayPredicate,
            dateToWord: true,
            onCalenderTap: () async {
              _selectedDates.clear();
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
            },
          ),
          SpacingFoundation.verticalSpace24,
          if (!widget.isNotification) ...[
            Text(
              S.of(context).PersonalizeYourReminder,
              style: theme?.regularTextTheme.labelSmall,
            ),
            SpacingFoundation.verticalSpace2,
            UiKitSelectedIconWidget(
              iconList: _iconList,
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
