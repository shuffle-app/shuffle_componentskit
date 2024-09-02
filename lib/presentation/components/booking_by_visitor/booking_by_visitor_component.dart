import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BookingByVisitorComponent extends StatefulWidget {
  final BookingUiModel? bookingUiModel;
  final TicketUiModel? ticketUiModel;
  final VoidCallback? onSelectedDate;
  final ValueNotifier<DateTime?>? selectedDate;

  final Function(
    TicketUiModel? ticketUiModel,
    List<SubsUiModel>? subs,
    List<UpsaleUiModel>? upsales,
  )? onSubmit;

  const BookingByVisitorComponent({
    super.key,
    this.bookingUiModel,
    this.ticketUiModel,
    this.onSelectedDate,
    this.selectedDate,
    this.onSubmit,
  });

  @override
  State<BookingByVisitorComponent> createState() => _BookingByVisitorComponentState();
}

class _BookingByVisitorComponentState extends State<BookingByVisitorComponent> {
  SubsUiModel? _selectedSub;
  UpsaleUiModel? _selectedUpsale;

  late final List<SubsUiModel> _subs;
  late final List<UpsaleUiModel> _upsales;

  late TicketUiModel _ticketUiModel;

  late int _ticketPrice;
  late int _ticketCount;

  late int _subTicketCount = 0;

  late int _upsaleCount;
  int _upsaleTotalPrice = 0;

  int get _getTotalSubsTicketCount => _ticketCount + _subTicketCount;

  int get _getTotalPrice => (_getTotalSubsTicketCount * _ticketPrice) + (_upsaleTotalPrice);

  @override
  void initState() {
    super.initState();
    _subs = widget.bookingUiModel?.subsUiModel ?? [];
    _upsales = widget.bookingUiModel?.upsaleUiModel ?? [];
    _ticketCount = widget.ticketUiModel?.ticketsCount ?? 0;
    _subTicketCount = widget.ticketUiModel?.totalSubsCount ?? 0;
    _ticketPrice = widget.bookingUiModel?.price != null ? int.parse(widget.bookingUiModel!.price!) : 0;
    _ticketUiModel = widget.ticketUiModel ?? TicketUiModel(id: -1);
    _upsaleCount = widget.ticketUiModel?.totalUpsalesCount ?? 0;
    _upsaleTotalPrice = widget.ticketUiModel?.totalUpsalePrice ?? 0;
  }

  @override
  void didUpdateWidget(covariant BookingByVisitorComponent oldWidget) {
    _subs.clear();
    _upsales.clear();
    _subs = List.from(widget.bookingUiModel?.subsUiModel ?? []);
    _upsales = List.from(widget.bookingUiModel?.upsaleUiModel ?? []);
    _ticketCount = widget.ticketUiModel?.ticketsCount ?? 0;
    _subTicketCount = widget.ticketUiModel?.totalSubsCount ?? 0;
    _ticketPrice = widget.bookingUiModel?.price != null ? int.parse(widget.bookingUiModel!.price!) : 0;
    _ticketUiModel = widget.ticketUiModel ?? TicketUiModel(id: -1);
    _upsaleCount = widget.ticketUiModel?.totalUpsalesCount ?? 0;
    _upsaleTotalPrice = widget.ticketUiModel?.totalUpsalePrice ?? 0;
    super.didUpdateWidget(oldWidget);
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
      if (_selectedSub != null) {
        final sub = _ticketUiModel.subs?.firstWhere(
          (element) => element?.item?.id == _selectedSub?.id,
          orElse: () => null,
        );

        if (sub != null && sub.count! <= sub.maxCount!) {
          _updateSubTicket(-1);
        }
      } else if (_ticketCount > 0) {
        _ticketCount--;
      } else if (_selectedSub == null && _subTicketCount > 0 && (_ticketUiModel.subs?.isNotEmpty ?? false)) {
        _updateSubTicket(-1);
      }
    });
  }

  _onAddSubTicket() {
    setState(() {
      if (_selectedSub != null) {
        _updateSubTicket(1);
      } else if (_selectedSub == null) {
        _ticketCount++;
      }
    });
  }

  void _updateSubTicket(int change) {
    if (_selectedSub != null) {
      TicketItem<SubsUiModel>? subFromTicket = _ticketUiModel.subs?.firstWhere(
        (element) => _selectedSub?.id == element?.item?.id,
        orElse: () => null,
      );

      if (subFromTicket == null && (!change.toString().contains('-'))) {
        final subs = _ticketUiModel.subs ?? [];
        final maxCount =
            int.parse(_selectedSub?.bookingLimit ?? '0') - int.parse(_selectedSub?.actualbookingLimit ?? '0');

        subs.add(TicketItem(count: 1, item: _selectedSub, maxCount: maxCount));

        _ticketUiModel = _ticketUiModel.copyWith(subs: subs);

        int index = _subs.indexWhere((element) => element.id == _selectedSub?.id);
        _subs[index] = _selectedSub!
            .copyWith(actualbookingLimit: (int.parse(_subs[index].actualbookingLimit ?? '0') + change).toString());

        _subTicketCount += change;
      } else if (subFromTicket != null) {
        final ticketCount = subFromTicket.count! + change;
        if (ticketCount <= (subFromTicket.maxCount ?? 0) && ticketCount >= 0) {
          subFromTicket = subFromTicket.copyWith(count: ticketCount);
          int indexOfSub = _ticketUiModel.subs?.indexWhere((element) => element?.item?.id == _selectedSub?.id) ?? -1;
          if (indexOfSub != -1) {
            _ticketUiModel.subs?[indexOfSub] = subFromTicket;
          }

          int index = _subs.indexWhere((element) => element.id == subFromTicket?.item?.id);
          _subs[index] = subFromTicket.item!
              .copyWith(actualbookingLimit: (int.parse(_subs[index].actualbookingLimit ?? '0') + change).toString());

          _subTicketCount += change;
        }

        if (_ticketUiModel.subs!.last?.count == 0) _ticketUiModel.subs!.removeLast();
      }
    } else {
      if (_ticketUiModel.subs?.last?.count != null) {
        _ticketUiModel.subs!.last = _ticketUiModel.subs!.last?.copyWith(count: _ticketUiModel.subs!.last!.count! - 1);
        int index = _subs.indexWhere((element) => element.id == _ticketUiModel.subs!.last?.item?.id);
        if (_ticketUiModel.subs!.last?.count == 0) _ticketUiModel.subs!.removeLast();

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
          _upsaleTotalPrice -= int.parse(upsale.item?.price ?? '0');
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
        _upsaleTotalPrice += int.parse(_selectedUpsale?.price ?? '0');
        _updateUpsaleTicket(1);
      }
    });
  }

  void _updateUpsaleTicket(int change) {
    if (_selectedUpsale != null) {
      TicketItem<UpsaleUiModel>? upsaleForTicket = _ticketUiModel.upsales?.firstWhere(
        (element) => _selectedUpsale?.id == element?.item?.id,
        orElse: () => null,
      );

      if (upsaleForTicket == null && (!change.toString().contains('-'))) {
        final upsales = _ticketUiModel.upsales ?? [];
        final maxCount = int.parse(_selectedUpsale?.limit ?? '0') - int.parse(_selectedUpsale?.actualLimit ?? '0');

        upsales.add(TicketItem(count: 1, item: _selectedUpsale, maxCount: maxCount));
        _ticketUiModel = _ticketUiModel.copyWith(upsales: upsales);

        int index = _upsales.indexWhere((element) => element.id == _selectedUpsale?.id);
        _upsales[index] =
            _selectedUpsale!.copyWith(actualLimit: (int.parse(_upsales[index].actualLimit ?? '0') + change).toString());

        _upsaleCount += change;
      } else if (upsaleForTicket != null) {
        final upsaleCount = upsaleForTicket.count! + change;
        if (upsaleCount <= (upsaleForTicket.maxCount ?? 0) && upsaleCount >= 0) {
          upsaleForTicket = upsaleForTicket.copyWith(count: upsaleCount);
          int indexOfUpsale =
              _ticketUiModel.upsales?.indexWhere((element) => element?.item?.id == _selectedUpsale?.id) ?? -1;

          if (indexOfUpsale != -1) {
            _ticketUiModel.upsales?[indexOfUpsale] = upsaleForTicket;
          }

          int index = _subs.indexWhere((element) => element.id == upsaleForTicket?.item?.id);
          _upsales[index] = upsaleForTicket.item!
              .copyWith(actualLimit: (int.parse(_upsales[index].actualLimit ?? '0') + change).toString());
          _upsaleCount += change;
        }

        if (_ticketUiModel.upsales!.last?.count == 0) _ticketUiModel.upsales!.removeLast();
      }
    } else {
      if (_ticketUiModel.upsales?.last?.count != null) {
        _ticketUiModel.upsales!.last =
            _ticketUiModel.upsales!.last?.copyWith(count: _ticketUiModel.upsales!.last!.count! - 1);
        int index = _upsales.indexWhere((element) => element.id == _ticketUiModel.upsales!.last?.item?.id);
        if (_ticketUiModel.upsales!.last?.count == 0) _ticketUiModel.upsales!.removeLast();

        _upsales[index] =
            _upsales[index].copyWith(actualLimit: (int.parse(_upsales[index].actualLimit!) - 1).toString());

        _upsaleCount += change;
        _upsaleTotalPrice -= int.parse(_upsales[index].price ?? '0');
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
              selectedSubId: _selectedSub?.id,
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
            if (widget.selectedDate?.value != null)
              ValueListenableBuilder(
                valueListenable: widget.selectedDate!,
                builder: (context, value, child) {
                  return Row(
                    children: [
                      Text(
                        formatDateWithCustomPattern('dd.MM.yyyy', widget.selectedDate!.value!.toLocal()),
                        style: theme?.boldTextTheme.body,
                      ),
                      SpacingFoundation.horizontalSpace16,
                      Text(
                        formatChatMessageDate(widget.selectedDate!.value!),
                        style: theme?.regularTextTheme.body,
                      ),
                    ],
                  ).paddingOnly(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    bottom: SpacingFoundation.verticalSpacing24,
                  );
                },
              ),
            Text(
              '${S.of(context).Total}: $_getTotalPrice ${widget.bookingUiModel?.currency ?? 'AED'}',
              style: theme?.boldTextTheme.title2,
            ).paddingSymmetric(horizontal: horizontalPadding),
          ],
          if ((_subs.isNotEmpty || _upsales.isNotEmpty) && _getTotalSubsTicketCount != 0)
            SafeArea(
              top: false,
              child: context.gradientButton(
                data: BaseUiKitButtonData(
                  text: S.of(context).GoToPayment.toUpperCase(),
                  onPressed: () {
                    widget.onSubmit?.call(
                      _ticketUiModel.copyWith(ticketsCount: _ticketCount),
                      _subs,
                      _upsales,
                    );
                  },
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
                  onPressed: () {
                    widget.onSubmit?.call(
                      _ticketUiModel.copyWith(ticketsCount: _ticketCount),
                      _subs,
                      _upsales,
                    );
                  },
                ),
              ),
            ).paddingSymmetric(horizontal: horizontalPadding, vertical: SpacingFoundation.verticalSpacing24)
          : null,
    );
  }
}
