import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'ui_model/refresher_ui_model.dart';

class CreateRefresherComponent extends StatefulWidget {
  final RefresherUiModel? refresherUiModel;
  final ValueChanged<RefresherUiModel>? onCreateRefresher;

  const CreateRefresherComponent({
    super.key,
    this.refresherUiModel,
    this.onCreateRefresher,
  });

  @override
  State<CreateRefresherComponent> createState() => _CreateRefresherComponentState();
}

class _CreateRefresherComponentState extends State<CreateRefresherComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oneWeekController = TextEditingController();
  final TextEditingController _oneDayController = TextEditingController();
  final TextEditingController _oneHourController = TextEditingController();

  late bool _oneWeekSelected;
  late bool _oneDaySelected;
  late bool _oneHourSelected;

  @override
  void initState() {
    super.initState();
    _oneWeekController.text = widget.refresherUiModel?.weekText ?? '';
    _oneDayController.text = widget.refresherUiModel?.dayText ?? '';
    _oneHourController.text = widget.refresherUiModel?.hourText ?? '';
    _oneWeekSelected = widget.refresherUiModel?.oneWeekSelected ?? false;
    _oneDaySelected = widget.refresherUiModel?.oneDaySelected ?? false;
    _oneHourSelected = widget.refresherUiModel?.oneHourSelected ?? false;
  }

  @override
  void didUpdateWidget(covariant CreateRefresherComponent oldWidget) {
    _oneWeekController.text = widget.refresherUiModel?.weekText ?? '';
    _oneDayController.text = widget.refresherUiModel?.dayText ?? '';
    _oneHourController.text = widget.refresherUiModel?.hourText ?? '';
    _oneWeekSelected = widget.refresherUiModel?.oneWeekSelected ?? false;
    _oneDaySelected = widget.refresherUiModel?.oneDaySelected ?? false;
    _oneHourSelected = widget.refresherUiModel?.oneHourSelected ?? false;
    super.didUpdateWidget(oldWidget);
  }

  _onChange() {
    setState(() {
      _formKey.currentState?.validate();
    });
  }

  String? _validator(String? value, bool canValidate) {
    if (!canValidate) return null;

    if (value != null && value.isEmpty) {
      return S.of(context).PleaseEnterValidText;
    }
    if (value != null && value.isNotEmpty) {
      final newValue = value.replaceAll(' ', '');
      if (newValue == '') {
        return S.of(context).PleaseEnterValidText;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final horizontalMargin = SpacingFoundation.horizontalSpacing16;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: BlurredAppBarPage(
          title: S.of(context).Refresher,
          autoImplyLeading: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: BouncingScrollPhysics(),
          centerTitle: true,
          children: [
            SpacingFoundation.verticalSpace16,
            _RefresherCreateItem(
              title: S.of(context).XWeek(1),
              controller: _oneWeekController,
              onChange: _onChange,
              validator: (value) => _validator(value, _oneWeekSelected),
              isSelected: _oneWeekSelected,
              onCheckBoxTap: () {
                _oneWeekSelected = !_oneWeekSelected;
                _formKey.currentState?.validate();
                setState(() {});
              },
            ).paddingSymmetric(horizontal: horizontalMargin),
            SpacingFoundation.verticalSpace16,
            _RefresherCreateItem(
              title: S.of(context).XDay(1),
              controller: _oneDayController,
              onChange: _onChange,
              validator: (value) => _validator(value, _oneDaySelected),
              isSelected: _oneDaySelected,
              onCheckBoxTap: () {
                _oneDaySelected = !_oneDaySelected;
                _formKey.currentState?.validate();
                setState(() {});
              },
            ).paddingSymmetric(horizontal: horizontalMargin),
            SpacingFoundation.verticalSpace16,
            _RefresherCreateItem(
              title: S.of(context).XHour(1),
              controller: _oneHourController,
              onChange: _onChange,
              validator: (value) => _validator(value, _oneHourSelected),
              isSelected: _oneHourSelected,
              onCheckBoxTap: () {
                _oneHourSelected = !_oneHourSelected;
                _formKey.currentState?.validate();
                setState(() {});
              },
            ).paddingSymmetric(horizontal: horizontalMargin),
            SpacingFoundation.verticalSpace16,
            Text(
              S.of(context).YourStartNotificationWillBeShownXTimes(3),
              style: theme?.boldTextTheme.caption1Medium.copyWith(color: ColorsFoundation.mutedText),
            ).paddingSymmetric(horizontal: horizontalMargin),
            SpacingFoundation.verticalSpace16,
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight + EdgeInsetsFoundation.vertical24,
        child: SafeArea(
          top: false,
          child: context.gradientButton(
            data: BaseUiKitButtonData(
              text: S.of(context).SaveAndPay,
              autoSizeGroup: AutoSizeGroup(),
              fit: ButtonFit.fitWidth,
              onPressed: () => widget.onCreateRefresher?.call(
                RefresherUiModel(
                  id: -1,
                  weekText: _oneWeekSelected ? _oneWeekController.text : null,
                  dayText: _oneDaySelected ? _oneDayController.text : null,
                  hourText: _oneHourSelected ? _oneHourController.text : null,
                  oneWeekSelected: _oneWeekSelected,
                  oneDaySelected: _oneDaySelected,
                  oneHourSelected: _oneHourSelected,
                  isLaunched: true,
                ),
              ),
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

class _RefresherCreateItem extends StatelessWidget {
  final TextEditingController controller;
  final String? title;
  final bool isSelected;
  final VoidCallback? onChange;
  final VoidCallback? onCheckBoxTap;
  final String? Function(String?)? validator;

  const _RefresherCreateItem({
    required this.controller,
    required this.isSelected,
    this.title,
    this.onChange,
    this.onCheckBoxTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            UiKitCheckbox(
              isActive: isSelected,
              onChanged: onCheckBoxTap,
            ),
            SpacingFoundation.horizontalSpace12,
            Text(
              title ?? '',
              style: theme?.boldTextTheme.body,
            ),
          ],
        ),
        SpacingFoundation.verticalSpace8,
        IntrinsicHeight(
          child: UiKitInputFieldNoFill(
            enabled: isSelected,
            label: S.of(context).Text,
            maxSymbols: 45,
            expands: true,
            controller: controller,
            onChanged: (value) {
              onChange?.call();
            },
            validator: validator,
          ),
        ),
      ],
    );
  }
}
