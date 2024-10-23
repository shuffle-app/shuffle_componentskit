// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/notification_offer_reminder_components/universal_not_offer_rem_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:collection/src/iterable_extensions.dart';

class CreateOffer extends StatefulWidget {
  final UniversalNotOfferRemUiModel? offerUiModel;
  final ValueChanged<UniversalNotOfferRemUiModel>? onCreateOffer;
  final int? offerPrice;
  final DateTime? lastDate;
  final Map<int, String>? iconsList;

  const CreateOffer({
    super.key,
    this.offerUiModel,
    this.onCreateOffer,
    this.offerPrice,
    this.lastDate,
    this.iconsList,
  });

  @override
  State<CreateOffer> createState() => _CreateOfferState();
}

class _CreateOfferState extends State<CreateOffer> {
  late UniversalNotOfferRemUiModel _offerUiModel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late DateTime? _isLaunchedDate;
  final List<DateTime?> _selectedDates = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();

  late bool _isLaunched;
  late bool _notifyTheAudience;

  late int? _selectedIconIndex;
  late List<String>? _iconsList;

  @override
  void initState() {
    _offerUiModel = widget.offerUiModel ?? UniversalNotOfferRemUiModel(id: -1);
    _titleController.text = widget.offerUiModel?.title?.trim() ?? '';
    _pointController.text = widget.offerUiModel?.pointPrice.toString().trim() ?? '';
    _selectedDates.addAll(widget.offerUiModel?.selectedDates?.toList() ?? [null]);
    _isLaunchedDate = widget.offerUiModel?.isLaunchedDate;
    _notifyTheAudience = widget.offerUiModel?.notifyTheAudience ?? true;
    _isLaunched = widget.offerUiModel?.isLaunched ?? true;
    _iconsList = widget.iconsList?.values.toList() ?? [];
    _iconsList?.firstWhereIndexedOrNull(
      (index, element) {
        if (element == widget.offerUiModel?.iconPath) {
          _selectedIconIndex = index;
          return true;
        } else {
          _selectedIconIndex = null;
          return false;
        }
      },
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CreateOffer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _offerUiModel = widget.offerUiModel ?? UniversalNotOfferRemUiModel(id: -1);
    _titleController.text = widget.offerUiModel?.title?.trim() ?? '';
    _pointController.text = widget.offerUiModel?.pointPrice.toString().trim() ?? '';
    _selectedDates.clear();
    _selectedDates.addAll(widget.offerUiModel?.selectedDates?.toList() ?? [null]);
    _isLaunchedDate = widget.offerUiModel?.isLaunchedDate;
    _notifyTheAudience = widget.offerUiModel?.notifyTheAudience ?? true;
    _isLaunched = widget.offerUiModel?.isLaunched ?? true;
    _iconsList = widget.iconsList?.values.toList() ?? [];
    _iconsList?.firstWhereIndexedOrNull(
      (index, element) {
        if (element == widget.offerUiModel?.iconPath) {
          _selectedIconIndex = index;
          return true;
        } else {
          _selectedIconIndex = null;
          return false;
        }
      },
    );
  }

  void _onSubmit() {
    if (_formKey.currentState != null && _formKey.currentState!.validate() && _selectedDates.first != null) {
      late final String? iconPath;
      late final int? iconId;

      if (_selectedIconIndex != null) {
        iconPath = _iconsList?[_selectedIconIndex!];
        iconId = widget.iconsList!.keys.firstWhereOrNull(
          (k) => widget.iconsList?[k] == _iconsList?[_selectedIconIndex!],
        );
      } else {
        iconPath = null;
        iconId = null;
      }

      _offerUiModel = _offerUiModel.copyWith(
        title: _titleController.text.trim(),
        iconId: iconId,
        iconPath: iconPath,
        isLaunched: _isLaunched,
        notifyTheAudience: _notifyTheAudience,
        pointPrice: _pointController.text.isEmpty ? 0 : int.parse(_pointController.text.trim().replaceAll(' ', '')),
        selectedDates: _selectedDates,
        isLaunchedDate: _isLaunchedDate ?? DateTime.now(),
        isOffer: true,
      );

      widget.onCreateOffer?.call(_offerUiModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: BlurredAppBarPage(
          title: S.of(context).Offer,
          centerTitle: true,
          autoImplyLeading: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          children: [
            if (widget.offerUiModel != null)
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
                        _isLaunched != widget.offerUiModel?.isLaunched
                            ? _isLaunchedDate = DateTime.now().toLocal()
                            : _isLaunchedDate = widget.offerUiModel?.isLaunchedDate ?? DateTime.now();
                      });
                    },
                    switchedOn: _isLaunched,
                  ),
                ],
              ).paddingOnly(top: SpacingFoundation.verticalSpacing16),
            SpacingFoundation.verticalSpace16,
            IntrinsicHeight(
              child: UiKitInputFieldNoFill(
                label: S.of(context).Title,
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
            SpacingFoundation.verticalSpace16,
            UiKitInputFieldNoFill(
              label: S.of(context).Points,
              maxSymbols: 7,
              controller: _pointController,
              keyboardType: TextInputType.number,
              inputFormatters: [PriceWithSpacesFormatter(allowDecimal: false)],
            ),
            SpacingFoundation.verticalSpace16,
            Row(
              children: [
                Flexible(
                  child: Text(
                    S.of(context).PersonalizeYourOffer,
                    style: theme?.regularTextTheme.labelSmall,
                  ),
                ),
                SpacingFoundation.horizontalSpace12,
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () => showUiKitPopover(
                      context,
                      customMinHeight: 30.h,
                      showButton: false,
                      title: Text(
                        S.of(context).ByDefaultYourOfferWillDisplay,
                        style: theme?.regularTextTheme.body.copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    child: ImageWidget(
                      iconData: ShuffleUiKitIcons.info,
                      width: 20.w,
                      color: theme?.colorScheme.darkNeutral900,
                    ),
                  ),
                ),
              ],
            ),
            SpacingFoundation.verticalSpace4,
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
            Text(
              S.of(context).SelectPeriodOfValid,
              style: theme?.regularTextTheme.labelSmall,
            ),
            SpacingFoundation.verticalSpace2,
            UiKitSelectDateWidget(
              selectedDates: _selectedDates,
              lastDate: widget.lastDate,
              onCalenderTap: () async {
                await showUiKitCalendarFromToDialog(
                  context,
                  lastDate: (widget.lastDate != null &&
                          widget.lastDate!.isAfter(DateTime.now()) &&
                          !widget.lastDate!.isAtSameDay)
                      ? widget.lastDate
                      : null,
                  (from, to) {
                    setState(() {
                      _selectedDates.clear();
                      (from != null && (from!.isAfter(DateTime.now()) || from!.isAtSameDay))
                          ? _selectedDates.add(from)
                          : from = null;
                      (from != null && from != to) ? _selectedDates.add(to) : _selectedDates.add(null);
                    });
                  },
                );
              },
            ),
            if (widget.offerUiModel == null) ...[
              SpacingFoundation.verticalSpace24,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).NotifyTheAudience,
                      style: theme?.regularTextTheme.labelSmall,
                    ),
                  ),
                  UiKitGradientSwitch(
                    onChanged: (value) {
                      setState(() {
                        _notifyTheAudience = !_notifyTheAudience;
                      });
                    },
                    switchedOn: _notifyTheAudience,
                  ),
                ],
              ),
              SpacingFoundation.verticalSpace2,
              Text(
                S.of(context).TheOfferWillBeAddedToPersonal,
                style: theme?.boldTextTheme.caption1Medium.copyWith(color: ColorsFoundation.mutedText),
              ),
            ],
            SpacingFoundation.verticalSpace16,
            Text(
              S.of(context).YourOfferWillShown1Time,
              style: theme?.boldTextTheme.caption1Medium.copyWith(color: ColorsFoundation.mutedText),
            ),
            SpacingFoundation.verticalSpace16,
            if (widget.offerUiModel == null) ...[
              Center(
                child: Text(
                  S.of(context).FreeNowXLater(widget.offerPrice ?? 5),
                  style: theme?.boldTextTheme.body,
                ),
              ).paddingOnly(top: SpacingFoundation.verticalSpacing16),
              SizedBox(height: SpacingFoundation.verticalSpacing32),
              SafeArea(
                top: false,
                child: context.gradientButton(
                  data: BaseUiKitButtonData(
                    text: S.of(context).Save,
                    fit: ButtonFit.fitWidth,
                    onPressed: () => _onSubmit(),
                  ),
                ),
              ),
              SpacingFoundation.verticalSpace24,
            ],
          ],
        ),
      ),
      bottomNavigationBar: widget.offerUiModel != null
          ? SizedBox(
              height: kBottomNavigationBarHeight + EdgeInsetsFoundation.vertical24,
              child: SafeArea(
                top: false,
                child: context.gradientButton(
                  data: BaseUiKitButtonData(
                    text: S.of(context).Save,
                    fit: ButtonFit.fitWidth,
                    onPressed: () => _onSubmit(),
                  ),
                ),
              ).paddingOnly(
                bottom: SpacingFoundation.verticalSpacing24,
                left: SpacingFoundation.horizontalSpacing16,
                right: SpacingFoundation.horizontalSpacing16,
              ),
            )
          : null,
    );
  }
}
