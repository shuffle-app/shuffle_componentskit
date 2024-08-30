import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BookingByVisitorComponent extends StatefulWidget {
  final BookingUiModel? bookingUiModel;
  final TicketUiModel? ticketUiModel;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool canEditTimeOfDay;

  final Function(
    List<TicketItem<SubsUiModel>?>? subsForTicket,
    List<TicketItem<UpsaleUiModel>?>? upsalesForTicket,
  ) onSubmit;

  const BookingByVisitorComponent({
    super.key,
    this.bookingUiModel,
    this.ticketUiModel,
    this.startDate,
    this.endDate,
    this.canEditTimeOfDay = false,
    required this.onSubmit,
  });

  @override
  State<BookingByVisitorComponent> createState() => _BookingByVisitorComponentState();
}

class _BookingByVisitorComponentState extends State<BookingByVisitorComponent> {
  SubsUiModel? _selectedSub;
  UpsaleUiModel? _selectedUpsale;
  late DateTime? _selectedDate;
  late final List<SubsUiModel> _subs;
  late final List<UpsaleUiModel> _upsales;
  late final Map<int, int> _originalSubsBookingLimits;
  late final Map<int, int> _originalUpsaleBookingLimits;

  late final List<TicketItem<SubsUiModel>?> _subsForTicket;
  late final List<TicketItem<UpsaleUiModel>?> _upsalesForTicket;

  late int _ticketCount;
  int _subTicketCount = 0;
  int _totalSubsTicketPrice = 0;

  late int _upsaleCount;
  int _upsaleTotalPrice = 0;

  late int _ticketPrice;

  int _getTotalPrice() {
    return _upsaleTotalPrice + _totalSubsTicketPrice;
  }

  int _getTotalSubsTicketCount() {
    return _ticketCount + _subTicketCount;
  }

  @override
  void initState() {
    super.initState();
    _subs = widget.bookingUiModel?.subsUiModel ?? [];
    _upsales = widget.bookingUiModel?.upsaleUiModel ?? [];
    _ticketCount = widget.ticketUiModel?.ticketsCount ?? 0;
    _ticketPrice = widget.bookingUiModel?.price != null ? int.parse(widget.bookingUiModel!.price!) : 0;
    _subsForTicket = widget.ticketUiModel?.subs ?? [];
    _upsalesForTicket = widget.ticketUiModel?.upsales ?? [];
    _upsaleCount = widget.ticketUiModel?.totalUpsalesCount ?? 0;
    _originalSubsBookingLimits = {for (var sub in _subs) sub.id: int.parse(sub.actualbookingLimit ?? '0')};
    _originalUpsaleBookingLimits = {for (var upsale in _upsales) upsale.id: int.parse(upsale.actualLimit ?? '0')};
    _selectedDate = widget.bookingUiModel?.selectedDateTime ?? widget.startDate;
  }

  _onSelectedSub(int id) {
    setState(() {
      _selectedSub = (_selectedSub?.id != id) ? _subs.firstWhere((element) => element.id == id) : null;
    });
  }

  _onSelectedUpsale(int id) {
    setState(() {
      _selectedUpsale = (_selectedUpsale?.id != id) ? _upsales.firstWhere((element) => element.id == id) : null;
    });
  }

  _onRemoveSubTicket() {
    setState(() {
      if (_selectedSub != null && _ticketCount > 0) {
        int actualbookingLimit = int.parse(_selectedSub!.actualbookingLimit!);
        int originalLimit = _originalSubsBookingLimits[_selectedSub!.id]!;

        if (actualbookingLimit > originalLimit) {
          _ticketCount--;
          _totalSubsTicketPrice -= _ticketPrice;
          _updateSubTicket(-1);
        }
      } else if (_ticketCount > 0) {
        _ticketCount--;
        _totalSubsTicketPrice -= _ticketPrice;
      } else if (_subTicketCount > 0) {
        _subTicketCount--;
        _totalSubsTicketPrice -= _ticketPrice;
        if (_subsForTicket.isNotEmpty) _updateSubTicket(-1);
      }
    });
  }

  _onAddSubTicket() {
    setState(() {
      if (_selectedSub != null) {
        int actualbookingLimit = int.parse(_selectedSub!.actualbookingLimit!);
        int maxLimit = int.parse(_selectedSub!.bookingLimit!);

        if (actualbookingLimit < maxLimit) {
          _subTicketCount++;
          _totalSubsTicketPrice += _ticketPrice;
          _updateSubTicket(1);
        }
      } else {
        _ticketCount++;
        _totalSubsTicketPrice += _ticketPrice;
      }
    });
  }

  void _updateSubTicket(int change) {
    if (_selectedSub != null) {
      int actualbookingLimit = int.parse(_selectedSub!.actualbookingLimit!) + change;
      _selectedSub = _selectedSub!.copyWith(actualbookingLimit: actualbookingLimit.toString());

      int originalLimit = _originalSubsBookingLimits[_selectedSub!.id]!;
      int index = _subs.indexWhere((element) => element.id == _selectedSub!.id);
      _subs[index] = _selectedSub!;

      int ticketIndex = _subsForTicket.indexWhere((ticketItem) => ticketItem?.item?.id == _selectedSub!.id);

      if (ticketIndex != -1) {
        if (actualbookingLimit > originalLimit) {
          _subsForTicket[ticketIndex] =
              _subsForTicket[ticketIndex]?.copyWith(count: actualbookingLimit - originalLimit);
        } else {
          _subsForTicket.removeAt(ticketIndex);
        }
      } else {
        if (actualbookingLimit > originalLimit) {
          _subsForTicket.add(TicketItem(count: actualbookingLimit - originalLimit, item: _selectedSub!));
        }
      }
    } else {
      if (_subsForTicket.last?.count != null) {
        _subsForTicket.last = _subsForTicket.last?.copyWith(count: _subsForTicket.last!.count! - 1);
        int index = _subs.indexWhere((element) => element.id == _subsForTicket.last?.item?.id);
        if (_subsForTicket.last?.count == 0) _subsForTicket.removeLast();

        _subs[index] =
            _subs[index].copyWith(actualbookingLimit: ((int.parse(_subs[index].actualbookingLimit!) - 1).toString()));
      }
    }
  }

  _onRemoveUpsale() {
    setState(() {
      if (_selectedUpsale?.actualLimit != null && _upsaleCount > 0) {
        int actualLimit = int.parse(_selectedUpsale!.actualLimit!);
        int originalLimit = _originalUpsaleBookingLimits[_selectedUpsale!.id]!;

        if (actualLimit > originalLimit) {
          _upsaleCount--;
          _upsaleTotalPrice -= int.parse(_selectedUpsale?.price ?? '0');
          _updateUpsaleTicket(-1);
        }
      } else if (_upsaleCount > 0) {
        _upsaleCount--;
        _upsaleTotalPrice -= int.parse(_upsalesForTicket.last?.item?.price ?? '0');
        _updateUpsaleTicket(-1);
      }
    });
  }

  _onAddUpsale() {
    setState(() {
      if (_selectedUpsale?.actualLimit != null) {
        int actualLimit = int.parse(_selectedUpsale!.actualLimit!);
        int maxLimit = int.parse(_selectedUpsale?.limit ?? '0');

        if (actualLimit < maxLimit) {
          _upsaleCount++;
          _upsaleTotalPrice += int.parse(_selectedUpsale?.price ?? '0');
          _updateUpsaleTicket(1);
        }
      }
    });
  }

  void _updateUpsaleTicket(int change) {
    if (_selectedUpsale?.actualLimit != null) {
      int actualLimit = int.parse(_selectedUpsale!.actualLimit!) + change;
      _selectedUpsale = _selectedUpsale!.copyWith(actualLimit: actualLimit.toString());

      int originalLimit = _originalUpsaleBookingLimits[_selectedUpsale!.id]!;
      int index = _upsales.indexWhere((element) => element.id == _selectedUpsale!.id);
      _upsales[index] = _selectedUpsale!;

      int ticketIndex = _upsalesForTicket.indexWhere((ticketItem) => ticketItem?.item?.id == _selectedUpsale!.id);

      if (ticketIndex != -1) {
        if (actualLimit > originalLimit) {
          _upsalesForTicket[ticketIndex] = _upsalesForTicket[ticketIndex]?.copyWith(count: actualLimit - originalLimit);
        } else {
          _upsalesForTicket.removeAt(ticketIndex);
        }
      } else {
        if (actualLimit > originalLimit) {
          _upsalesForTicket.add(TicketItem(count: actualLimit - originalLimit, item: _selectedUpsale!));
        }
      }
    } else {
      if (_upsalesForTicket.last?.count != null) {
        _upsalesForTicket.last = _upsalesForTicket.last?.copyWith(count: _upsalesForTicket.last!.count! - 1);

        int index = _upsales.indexWhere((element) => element.id == _upsalesForTicket.last?.item?.id);
        if (_upsalesForTicket.last?.count == 0) _upsalesForTicket.removeLast();

        _upsales[index] =
            _upsales[index].copyWith(actualLimit: ((int.parse(_upsales[index].actualLimit!) - 1).toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    double horizontalPadding = SpacingFoundation.horizontalSpacing16;

    return Scaffold(
      body: BlurredAppBarPage(
        title: S.of(context).Booking,
        centerTitle: true,
        autoImplyLeading: true,
        children: [
          SpacingFoundation.verticalSpace16,
          if (_subs.isNotEmpty) ...[
            Text(
              S.of(context).SelectSubs,
              style: theme?.boldTextTheme.title2,
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace16,
            SubsInContentCard(
              subs: _subs,
              backgroundColor: theme?.colorScheme.surface,
              selectedSub: _selectedSub,
              onItemTap: (id) {
                _onSelectedSub(id);
              },
            ).paddingOnly(bottom: SpacingFoundation.verticalSpacing2),
          ],
          AutoSizeText(
            '${S.of(context).TicketPrice} $_ticketPrice ${widget.bookingUiModel?.currency}',
            style: theme?.boldTextTheme.title2,
            maxLines: 1,
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace16,
          Row(
            children: [
              Text(
                S.of(context).Ticket,
                style: theme?.regularTextTheme.labelLarge,
              ),
              const Spacer(),
              context.badgeButtonNoValue(
                data: BaseUiKitButtonData(
                  onPressed: () => _onRemoveSubTicket(),
                  iconWidget: const GradientableWidget(
                    gradient: GradientFoundation.defaultLinearGradient,
                    child: ImageWidget(
                      iconData: ShuffleUiKitIcons.minus,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
              ),
              SpacingFoundation.horizontalSpace8,
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme?.colorScheme.surface3,
                  borderRadius: BorderRadiusFoundation.all24r,
                ),
                child: Text(
                  '${_ticketCount + _subTicketCount}',
                  style: theme?.boldTextTheme.caption1Medium,
                ).paddingSymmetric(
                  vertical: SpacingFoundation.verticalSpacing16,
                  horizontal: SpacingFoundation.horizontalSpacing32,
                ),
              ),
              SpacingFoundation.horizontalSpace8,
              context.badgeButtonNoValue(
                data: BaseUiKitButtonData(
                  onPressed: () => _onAddSubTicket(),
                  iconWidget: const GradientableWidget(
                    gradient: GradientFoundation.defaultLinearGradient,
                    child: ImageWidget(
                      iconData: ShuffleUiKitIcons.gradientPlus,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace24,
          if (_upsales.isNotEmpty) ...[
            Text(
              S.of(context).SelectYourFavoriteProduct,
              style: theme?.boldTextTheme.title2,
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace16,
            SubsInContentCard(
              upsales: _upsales,
              backgroundColor: theme?.colorScheme.surface,
              selectedUpsale: _selectedUpsale,
              onItemTap: (id) {
                _onSelectedUpsale(id);
              },
            ).paddingOnly(bottom: SpacingFoundation.verticalSpacing2),
            Row(
              children: [
                Text(
                  S.of(context).Product,
                  style: theme?.regularTextTheme.labelLarge,
                ),
                const Spacer(),
                context.badgeButtonNoValue(
                  data: BaseUiKitButtonData(
                    onPressed: () => _onRemoveUpsale(),
                    iconWidget: const GradientableWidget(
                      gradient: GradientFoundation.defaultLinearGradient,
                      child: ImageWidget(
                        iconData: ShuffleUiKitIcons.minus,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                ),
                SpacingFoundation.horizontalSpace8,
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme?.colorScheme.surface3,
                    borderRadius: BorderRadiusFoundation.all24r,
                  ),
                  child: Text(
                    '$_upsaleCount',
                    style: theme?.boldTextTheme.caption1Medium,
                  ).paddingSymmetric(
                    vertical: SpacingFoundation.verticalSpacing16,
                    horizontal: SpacingFoundation.horizontalSpacing32,
                  ),
                ),
                SpacingFoundation.horizontalSpace8,
                context.badgeButtonNoValue(
                  data: BaseUiKitButtonData(
                    onPressed: () => _onAddUpsale(),
                    iconWidget: const GradientableWidget(
                      gradient: GradientFoundation.defaultLinearGradient,
                      child: ImageWidget(
                        iconData: ShuffleUiKitIcons.gradientPlus,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace24,
          ],
          if (_getTotalSubsTicketCount() != 0) ...[
            Text(
              S.of(context).SelectDateTime,
              style: theme?.boldTextTheme.title2,
            ).paddingSymmetric(horizontal: horizontalPadding),
            if ((widget.startDate != null && widget.endDate != null) ||
                (widget.startDate != null && widget.endDate == null && widget.canEditTimeOfDay)) ...[
              SpacingFoundation.verticalSpace24,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    S.of(context).Schedule,
                    style: theme?.regularTextTheme.labelSmall,
                  ),
                  const Spacer(),
                  context.outlinedButton(
                    padding: EdgeInsets.all(EdgeInsetsFoundation.all12),
                    data: BaseUiKitButtonData(
                      iconInfo: BaseUiKitButtonIconData(iconData: ShuffleUiKitIcons.calendar),
                      onPressed: () async {
                        if (widget.canEditTimeOfDay && widget.endDate == null) {
                          final timeOfDay = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (timeOfDay != null) {
                            setState(() {
                              _selectedDate = _selectedDate!.copyWith(hour: timeOfDay.hour, minute: timeOfDay.minute);
                            });
                          }
                        } else {
                          final selectedDateFromDialog = await showUiKitCalendarDialog(
                            firstDate: widget.startDate,
                            lastDate: widget.endDate,
                            context,
                          );

                          if (selectedDateFromDialog != null) {
                            setState(() {
                              _selectedDate = selectedDateFromDialog;
                            });
                            if (mounted) {
                              final timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (timeOfDay != null) {
                                setState(() {
                                  _selectedDate =
                                      _selectedDate!.copyWith(hour: timeOfDay.hour, minute: timeOfDay.minute);
                                });
                              }
                            }
                          }
                        }
                      },
                    ),
                  )
                ],
              ).paddingSymmetric(horizontal: horizontalPadding),
            ],
            SpacingFoundation.verticalSpace16,
            if (_selectedDate != null)
              Row(
                children: [
                  Text(
                    formatDateWithCustomPattern('dd.MM.yyyy', _selectedDate!.toLocal()),
                    style: theme?.boldTextTheme.body,
                  ),
                  SpacingFoundation.horizontalSpace16,
                  Text(
                    formatChatMessageDate(_selectedDate!),
                    style: theme?.regularTextTheme.body,
                  ),
                ],
              ).paddingOnly(
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: SpacingFoundation.verticalSpacing24,
              ),
            Text(
              '${S.of(context).Total}: ${_getTotalPrice()} ${widget.bookingUiModel?.currency ?? 'AED'}',
              style: theme?.boldTextTheme.title2,
            ).paddingSymmetric(horizontal: horizontalPadding),
          ],
          if ((_subs.isNotEmpty || _upsales.isNotEmpty) && _getTotalSubsTicketCount() != 0)
            SafeArea(
              top: false,
              child: context.gradientButton(
                data: BaseUiKitButtonData(
                  text: S.of(context).GoToPayment.toUpperCase(),
                  onPressed: () => widget.onSubmit(
                    _subsForTicket,
                    _upsalesForTicket,
                  ),
                ),
              ),
            ).paddingSymmetric(horizontal: horizontalPadding, vertical: SpacingFoundation.verticalSpacing24),
        ],
      ),
      bottomNavigationBar: (_subs.isEmpty && _upsales.isEmpty) && _getTotalSubsTicketCount() != 0
          ? SafeArea(
              top: false,
              child: context.gradientButton(
                data: BaseUiKitButtonData(
                  text: S.of(context).GoToPayment.toUpperCase(),
                  onPressed: () => widget.onSubmit(
                    _subsForTicket,
                    _upsalesForTicket,
                  ),
                ),
              ),
            ).paddingSymmetric(horizontal: horizontalPadding, vertical: SpacingFoundation.verticalSpacing24)
          : null,
    );
  }
}
