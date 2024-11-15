import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class BookingByVisitorComponent extends StatefulWidget {
  final BookingUiModel? bookingUiModel;
  final TicketUiModel? ticketUiModel;
  final VoidCallback? onSelectedDate;
  final DateTime? selectedDate;
  final bool isCurrentDate;

  final Function(
    TicketUiModel? ticketUiModel,
    List<SubsUiModel>? subs,
    List<UpsaleUiModel>? upsales,
    int? bookingId,
  )? onSubmit;

  const BookingByVisitorComponent({
    super.key,
    this.bookingUiModel,
    this.ticketUiModel,
    this.onSelectedDate,
    this.selectedDate,
    this.onSubmit,
    this.isCurrentDate = true,
  });

  @override
  State<BookingByVisitorComponent> createState() => _BookingByVisitorComponentState();
}

class _BookingByVisitorComponentState extends State<BookingByVisitorComponent> {
  SubsUiModel? _selectedSub;
  UpsaleUiModel? _selectedUpsale;

  bool errorSelectSubisActive = false;
  bool errorSelectUpsaleisActive = false;

  final List<SubsUiModel> _subs = [];
  final List<UpsaleUiModel> _upsales = [];

  late TicketUiModel _ticketUiModel;

  late double _ticketPrice;
  late int _ticketCount;

  late int _subTicketCount = 0;

  late int _upsaleCount;
  int _upsaleTotalPrice = 0;

  int get _getTotalSubsTicketCount => _ticketCount + _subTicketCount;

  double get _getTotalPrice => (_getTotalSubsTicketCount * _ticketPrice) + (_upsaleTotalPrice);

  @override
  void initState() {
    super.initState();
    _subs.addAll(widget.bookingUiModel?.subsUiModel ?? []);
    _upsales.addAll(widget.bookingUiModel?.upsaleUiModel ?? []);
    _ticketCount = widget.ticketUiModel?.ticketsCount ?? 0;
    _subTicketCount = widget.ticketUiModel?.subs?.count ?? 0;
    _ticketPrice = widget.bookingUiModel?.price != null ? double.parse(widget.bookingUiModel!.price!) : 0;
    _ticketUiModel = widget.ticketUiModel ?? TicketUiModel(id: -1);
    _upsaleCount = widget.ticketUiModel?.totalUpsalesCount ?? 0;
    _upsaleTotalPrice = widget.ticketUiModel?.totalUpsalePrice ?? 0;
  }

  @override
  void didUpdateWidget(covariant BookingByVisitorComponent oldWidget) {
    if (oldWidget.ticketUiModel != widget.ticketUiModel) {
      _subs.clear();
      _upsales.clear();
      _subs.addAll(widget.bookingUiModel?.subsUiModel ?? []);
      _upsales.addAll(widget.bookingUiModel?.upsaleUiModel ?? []);
      _ticketCount = widget.ticketUiModel?.ticketsCount ?? 0;
      _subTicketCount = widget.ticketUiModel?.subs?.count ?? 0;
      _ticketPrice = widget.bookingUiModel?.price != null ? double.parse(widget.bookingUiModel!.price!) : 0;
      _upsaleCount = widget.ticketUiModel?.totalUpsalesCount ?? 0;
      _upsaleTotalPrice = widget.ticketUiModel?.totalUpsalePrice ?? 0;
      _ticketUiModel = widget.ticketUiModel ?? TicketUiModel(id: -1);
    }

    super.didUpdateWidget(oldWidget);
  }

  _onSelectedSub(int id) {
    setState(() {
      if (_ticketUiModel.subs == null || _ticketUiModel.subs?.item?.id == id) {
        if (_selectedSub?.id != id) {
          final sub = _subs.firstWhere((element) => element.id == id);
          if (sub.actualbookingLimit != sub.bookingLimit) {
            _selectedSub = sub;
          } else {
            _selectedSub = null;
          }
        } else {
          _selectedSub = null;
        }
      } else {
        _selectedSub = null;
      }
    });
  }

  _onSelectedUpsale(int id) {
    setState(() {
      if ((_selectedUpsale?.id != id)) {
        final upsale = _upsales.firstWhere((element) {
          return element.id == id;
        });

        if (upsale.limit != upsale.actualLimit) {
          _selectedUpsale = upsale;
        } else {
          _selectedUpsale = null;
        }
      } else {
        _selectedUpsale = null;
      }
    });
  }

  _onRemoveSubTicket() {
    setState(() {
      if (_selectedSub != null) {
        // final sub = _ticketUiModel.subs?.firstWhere(
        //   (element) => element?.item?.id == _selectedSub?.id,
        //   orElse: () => null,
        // );

        if (_ticketUiModel.subs != null && _ticketUiModel.subs!.count! <= _ticketUiModel.subs!.maxCount!) {
          _updateSubTicket(-1);
        }
      } else if (_ticketCount > 0) {
        _ticketCount--;
      } else if (_selectedSub == null && _subTicketCount > 0 && (_ticketUiModel.subs != null)) {
        _updateSubTicket(-1);
      }
    });
  }

  _onAddSubTicket() {
    if (_getTotalSubsTicketCount == (int.tryParse(widget.bookingUiModel?.bookingLimitPerOne ?? '999') ?? 999)) return;
    setState(() {
      if (_selectedSub != null) {
        _updateSubTicket(1);
      } else if (widget.bookingUiModel?.subsUiModel == null ||
          (widget.bookingUiModel?.subsUiModel != null && widget.bookingUiModel!.subsUiModel!.isEmpty)) {
        _ticketCount++;
      } else {
        errorSelectSubisActive = true;
      }
    });
  }

  void _updateSubTicket(int change) {
    if (_selectedSub != null) {
      /// Looking for a sub-element in the current ticket list
      // TicketItem<SubsUiModel>? subFromTicket = _ticketUiModel.subs?.firstWhere(
      //   (element) => _selectedSub?.id == element?.item?.id,
      //   orElse: () => null,
      // );
      TicketItem<SubsUiModel>? subFromTicket = _ticketUiModel.subs;

      /// If the sub-element is not found in the ticket and the change is positive (addition)
      if (subFromTicket == null && (!change.toString().contains('-'))) {
        TicketItem<SubsUiModel>? subs = _ticketUiModel.subs;
        final maxCount =
            int.parse(_selectedSub?.bookingLimit ?? '0') - int.parse(_selectedSub?.actualbookingLimit ?? '0');
        subs = TicketItem(count: 1, item: _selectedSub, maxCount: maxCount);

        /// Updating the ticket model with a new list of subelements
        _ticketUiModel = _ticketUiModel.copyWith(subs: subs);

        /// Updating the number of bookings for the selected sub-element
        int index = _subs.indexWhere((element) => element.id == _selectedSub?.id);
        _subs[index] = _selectedSub!
            .copyWith(actualbookingLimit: (int.parse(_subs[index].actualbookingLimit ?? '0') + change).toString());

        _subTicketCount += change;
      } else if (subFromTicket != null) {
        final ticketCount = subFromTicket.count! + change;

        /// Update the subelement only if the new quantity is acceptable
        if (ticketCount <= (subFromTicket.maxCount ?? 0) && ticketCount >= 0) {
          subFromTicket = subFromTicket.copyWith(count: ticketCount);

          _ticketUiModel.subs = subFromTicket;

          // int indexOfSub = _ticketUiModel.subs?.indexWhere((element) => element?.item?.id == _selectedSub?.id) ?? -1;
          // if (indexOfSub != -1) {
          //   _ticketUiModel.subs?[indexOfSub] = subFromTicket;
          // }

          /// Updating the actual number of bookings
          int index = _subs.indexWhere((element) => element.id == subFromTicket?.item?.id);
          _subs[index] = subFromTicket.item!
              .copyWith(actualbookingLimit: (int.parse(_subs[index].actualbookingLimit ?? '0') + change).toString());
          _subTicketCount += change;
        }

        /// If the last subelement in the list has zero number, delete it
        if (_ticketUiModel.subs?.count == 0) _ticketUiModel.subs = null;
      }
    } else {
      if (_ticketUiModel.subs?.count != null) {
        _ticketUiModel.subs = _ticketUiModel.subs!.copyWith(count: _ticketUiModel.subs!.count! - 1);

        int index = _subs.indexWhere((element) => element.id == _ticketUiModel.subs!.item?.id);

        /// If the number of the last subelement has become zero, remove it from the list
        if (_ticketUiModel.subs!.count == 0) _ticketUiModel.subs = null;

        /// Updating the number of bookings for the last sub-element
        _subs[index] =
            _subs[index].copyWith(actualbookingLimit: ((int.parse(_subs[index].actualbookingLimit!) - 1).toString()));

        _subTicketCount += change;
      }
    }
  }

  _onRemoveUpsale() {
    setState(() {
      if (_selectedUpsale != null) {
        final upsale = _ticketUiModel.upsales?.firstWhere(
          (element) => element?.item?.id == _selectedUpsale?.id,
          orElse: () => null,
        );

        if (upsale != null && upsale.count! <= upsale.maxCount!) {
          _updateUpsaleTicket(-1);
        }
      } else if (_selectedUpsale == null && _upsaleCount > 0 && (_ticketUiModel.upsales?.isNotEmpty ?? false)) {
        _updateUpsaleTicket(-1);
      }
    });
  }

  _onAddUpsale() {
    setState(() {
      if (_selectedUpsale != null) {
        _updateUpsaleTicket(1);
      } else {
        errorSelectUpsaleisActive = true;
      }
    });
  }

  void _updateUpsaleTicket(int change) {
    if (_selectedUpsale != null) {
      /// Looking for an upsale in the current ticket list
      TicketItem<UpsaleUiModel>? upsaleForTicket = _ticketUiModel.upsales?.firstWhere(
        (element) => _selectedUpsale?.id == element?.item?.id,
        orElse: () => null,
      );

      /// If the upsale is not found in the ticket and the change is positive (addition)
      if (upsaleForTicket == null && (!change.toString().contains('-'))) {
        final upsales = _ticketUiModel.upsales ?? [];
        final maxCount = int.parse(_selectedUpsale?.limit ?? '0') - int.parse(_selectedUpsale?.actualLimit ?? '0');
        upsales.add(TicketItem(count: 1, item: _selectedUpsale, maxCount: maxCount));

        _ticketUiModel = _ticketUiModel.copyWith(upsales: upsales);

        /// Updating the number of actual bookings for the selected upsale
        int index = _upsales.indexWhere((element) => element.id == _selectedUpsale?.id);
        _upsales[index] =
            _selectedUpsale!.copyWith(actualLimit: (int.parse(_upsales[index].actualLimit ?? '0') + change).toString());
        _upsaleCount += change;
        _upsaleTotalPrice += int.parse(_selectedUpsale?.price ?? '0');
      } else if (upsaleForTicket != null) {
        final upsaleCount = upsaleForTicket.count! + change;

        /// Update the upsale only if the new quantity is acceptable
        if (upsaleCount <= (upsaleForTicket.maxCount ?? 0) && upsaleCount >= 0) {
          upsaleForTicket = upsaleForTicket.copyWith(count: upsaleCount);

          /// Find the upsale index in the ticket list
          int indexOfUpsale =
              _ticketUiModel.upsales?.indexWhere((element) => element?.item?.id == _selectedUpsale?.id) ?? -1;

          if (indexOfUpsale != -1) {
            _ticketUiModel.upsales?[indexOfUpsale] = upsaleForTicket;
          }

          /// Updating the number of actual bookings for the upsale
          int index = _upsales.indexWhere((element) => element.id == upsaleForTicket?.item?.id);
          _upsales[index] = upsaleForTicket.item!
              .copyWith(actualLimit: (int.parse(_upsales[index].actualLimit ?? '0') + change).toString());

          _upsaleCount += change;

          if (change.toString().contains('-')) {
            _upsaleTotalPrice -= int.parse(_selectedUpsale?.price ?? '0');
          } else {
            _upsaleTotalPrice += int.parse(_selectedUpsale?.price ?? '0');
          }
        }

        /// If the last upsale in the list has zero number, delete it
        if (_ticketUiModel.upsales!.last?.count == 0) _ticketUiModel.upsales!.removeLast();
      }
    } else {
      if (_ticketUiModel.upsales?.last?.count != null) {
        _ticketUiModel.upsales!.last =
            _ticketUiModel.upsales!.last?.copyWith(count: _ticketUiModel.upsales!.last!.count! - 1);

        int index = _upsales.indexWhere((element) => element.id == _ticketUiModel.upsales!.last?.item?.id);

        /// If the number of the last update has become zero, remove it from the list
        if (_ticketUiModel.upsales!.last?.count == 0) _ticketUiModel.upsales!.removeLast();

        /// Updating the number of actual bookings for the latest update
        _upsales[index] =
            _upsales[index].copyWith(actualLimit: (int.parse(_upsales[index].actualLimit!) - 1).toString());

        _upsaleCount += change;

        /// Reducing the total price by the price of the last upsale
        _upsaleTotalPrice -= int.parse(_upsales[index].price ?? '0');
      }
    }
  }

  String formatDouble(double number) {
    String formatted = number.toStringAsFixed(10);
    formatted = formatted.replaceAll(RegExp(r'0*$'), '');
    formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    double horizontalPadding = SpacingFoundation.horizontalSpacing16;

    return Scaffold(
      body: BlurredAppBarPage(
        customTitle: Flexible(
          child: AutoSizeText(
            S.of(context).Booking,
            style: theme?.boldTextTheme.title1,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
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
              selectedSubId: _selectedSub?.id,
              onItemTap: (id) {
                _onSelectedSub(id);
              },
            ).paddingOnly(bottom: SpacingFoundation.verticalSpacing2),
          ],
          AutoSizeText(
            '${S.of(context).TicketPrice} ${formatDouble(_ticketPrice)} ${widget.bookingUiModel?.currency ?? 'AED'}',
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
                  '$_getTotalSubsTicketCount',
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
                      iconData: ShuffleUiKitIcons.plus,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: horizontalPadding),
          if (errorSelectSubisActive) ...[
            Text(
              S.of(context).SelectSubs,
              style: theme?.regularTextTheme.body.copyWith(color: UiKitColors.error),
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace16,
          ],
          SpacingFoundation.verticalSpace24,
          if (_getTotalSubsTicketCount == (int.tryParse(widget.bookingUiModel?.bookingLimitPerOne ?? '9999') ?? 9999))
            Text(
              '${S.of(context).BookingLimitPerOne}: ${widget.bookingUiModel?.bookingLimitPerOne}',
              style: theme?.regularTextTheme.labelLarge,
            ).paddingOnly(left: horizontalPadding, bottom: SpacingFoundation.verticalSpacing24),
          if (_upsales.isNotEmpty) ...[
            Text(
              S.of(context).SelectYourFavoriteProduct,
              style: theme?.boldTextTheme.title2,
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace16,
            SubsInContentCard(
              upsales: _upsales,
              backgroundColor: theme?.colorScheme.surface,
              selectedUpsaleId: _selectedUpsale?.id,
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
                        iconData: ShuffleUiKitIcons.plus,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: horizontalPadding),
            if (errorSelectUpsaleisActive) ...[
              Text(
                S.of(context).SelectYourFavoriteProduct,
                style: theme?.regularTextTheme.body.copyWith(color: UiKitColors.error),
              ).paddingSymmetric(horizontal: horizontalPadding),
              SpacingFoundation.verticalSpace16,
            ],
            SpacingFoundation.verticalSpace24,
          ],
          if (_getTotalSubsTicketCount != 0) ...[
            Text(
              S.of(context).SelectDateTime,
              style: theme?.boldTextTheme.title2,
            ).paddingSymmetric(horizontal: horizontalPadding),
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
                    onPressed: widget.onSelectedDate,
                  ),
                )
              ],
            ).paddingSymmetric(horizontal: horizontalPadding),
            SpacingFoundation.verticalSpace16,
            if (widget.selectedDate != null)
              Row(
                children: [
                  if (widget.isCurrentDate) ...[
                    Text(
                      formatDateWithCustomPattern('dd.MM.yyyy', widget.selectedDate!.toLocal()),
                      style: theme?.boldTextTheme.body,
                    ),
                    SpacingFoundation.horizontalSpace16,
                    Text(
                      formatChatMessageDate(widget.selectedDate!),
                      style: theme?.regularTextTheme.body,
                    ),
                  ] else
                    Expanded(
                      child: Text(
                        S.of(context).SelectTimeCorrespondingToContentCard,
                        style: theme?.regularTextTheme.body.copyWith(color: ColorsFoundation.error),
                      ),
                    ),
                ],
              ).paddingOnly(
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: SpacingFoundation.verticalSpacing24,
              ),
            Text(
              '${S.of(context).Total}: ${formatDouble(_getTotalPrice)} ${widget.bookingUiModel?.currency ?? 'AED'}',
              style: theme?.boldTextTheme.title2,
            ).paddingSymmetric(horizontal: horizontalPadding),
          ],
          if ((_subs.isNotEmpty || _upsales.isNotEmpty) && _getTotalSubsTicketCount != 0)
            SafeArea(
              top: false,
              child: context.gradientButton(
                data: BaseUiKitButtonData(
                  text: S.of(context).GoToPayment.toUpperCase(),
                  onPressed: widget.selectedDate != null && widget.isCurrentDate
                      ? () {
                          widget.onSubmit?.call(
                            _ticketUiModel.copyWith(ticketsCount: _getTotalSubsTicketCount),
                            _subs,
                            _upsales,
                            widget.bookingUiModel?.id,
                          );
                        }
                      : null,
                ),
              ),
            ).paddingSymmetric(horizontal: horizontalPadding, vertical: SpacingFoundation.verticalSpacing24),
        ],
      ),
      bottomNavigationBar: (_subs.isEmpty && _upsales.isEmpty) && _getTotalSubsTicketCount != 0
          ? SafeArea(
              top: false,
              child: context.gradientButton(
                data: BaseUiKitButtonData(
                  text: S.of(context).GoToPayment.toUpperCase(),
                  onPressed: widget.selectedDate != null
                      ? () {
                          widget.onSubmit?.call(
                            _ticketUiModel.copyWith(ticketsCount: _getTotalSubsTicketCount),
                            _subs,
                            _upsales,
                            widget.bookingUiModel?.id,
                          );
                        }
                      : null,
                ),
              ),
            ).paddingSymmetric(horizontal: horizontalPadding, vertical: SpacingFoundation.verticalSpacing24)
          : null,
    );
  }
}
