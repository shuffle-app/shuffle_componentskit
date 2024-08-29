import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BookingByVisitorComponent extends StatefulWidget {
  final BookingUiModel? bookingUiModel;
  final TicketUiModel? ticketUiModel;
  final Function(
    List<TicketItem<SubsUiModel>?>? subsForTicket,
    List<TicketItem<UpsaleUiModel>?>? upsalesForTicket,
  ) onSubmit;

  const BookingByVisitorComponent({
    super.key,
    this.bookingUiModel,
    this.ticketUiModel,
    required this.onSubmit,
  });

  @override
  State<BookingByVisitorComponent> createState() => _BookingByVisitorComponentState();
}

class _BookingByVisitorComponentState extends State<BookingByVisitorComponent> {
  SubsUiModel? _selectedSub;
  UpsaleUiModel? _selectedUpsale;
  late final List<SubsUiModel> _subs;
  late final List<UpsaleUiModel> _upsales;
  late final Map<int, int> _originalBookingLimits;

  late final List<TicketItem<SubsUiModel>?> _subsForTicket;
  late final List<TicketItem<UpsaleUiModel>?> _upsalesForTicket;

  late int ticketCount;
  int subTicketCount = 0;
  late int ticketPrice;

  int totalSubsTicketPrice = 0;

  @override
  void initState() {
    super.initState();
    _subs = widget.bookingUiModel?.subsUiModel ?? [];
    _upsales = widget.bookingUiModel?.upsaleUiModel ?? [];
    ticketCount = widget.ticketUiModel?.ticketsCount ?? 0;
    ticketPrice = widget.bookingUiModel?.price != null ? int.parse(widget.bookingUiModel!.price!) : 0;
    _subsForTicket = widget.ticketUiModel?.subs ?? [];
    _upsalesForTicket = widget.ticketUiModel?.upsales ?? [];
    _originalBookingLimits = {for (var sub in _subs) sub.id: int.parse(sub.actualbookingLimit!)};
  }

  _onSelectedSub(int id) {
    final subFromId = _subs.firstWhere((element) => element.id == id);
    setState(() {
      _selectedSub = (_selectedSub != subFromId) ? subFromId : null;
    });
  }

  _onSelectedUpsale(int id) {
    final upsaleFromId = _upsales.firstWhere((element) => element.id == id);
    setState(() {
      _selectedUpsale = (_selectedUpsale != upsaleFromId) ? upsaleFromId : null;
    });
  }

  _onAddSubTicket() {
    setState(() {
      if (_selectedSub != null) {
        int actualbookingLimit = int.parse(_selectedSub!.actualbookingLimit!);
        int maxLimit = int.parse(_selectedSub!.bookingLimit!);

        if (actualbookingLimit < maxLimit) {
          subTicketCount++;
          totalSubsTicketPrice += ticketPrice;
          _updateSubTicket(1);
        }
      } else {
        ticketCount++;
        totalSubsTicketPrice += ticketPrice;
      }
    });
  }

  _onRemoveSubTicket() {
    setState(() {
      if (_selectedSub != null && ticketCount > 0) {
        int actualbookingLimit = int.parse(_selectedSub!.actualbookingLimit!);
        int originalLimit = _originalBookingLimits[_selectedSub!.id]!;

        if (actualbookingLimit > originalLimit) {
          ticketCount--;
          totalSubsTicketPrice -= ticketPrice;
          _updateSubTicket(-1);
        }
      } else if (ticketCount > 0) {
        ticketCount--;
        totalSubsTicketPrice -= ticketPrice;
      } else if (subTicketCount > 0) {
        subTicketCount--;
        totalSubsTicketPrice -= ticketPrice;
        if (_subsForTicket.isNotEmpty) _updateSubTicket(-1);
      }
    });
  }

  void _updateSubTicket(int change) {
    if (_selectedSub != null) {
      int actualbookingLimit = int.parse(_selectedSub!.actualbookingLimit!) + change;
      _selectedSub = _selectedSub!.copyWith(actualbookingLimit: actualbookingLimit.toString());

      int originalLimit = _originalBookingLimits[_selectedSub!.id]!;
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
      setState(() {
        if (_subsForTicket.last?.count != null) {
          _subsForTicket.last = _subsForTicket.last?.copyWith(count: _subsForTicket.last!.count! - 1);
          int index = _subs.indexWhere((element) => element.id == _subsForTicket.last?.item?.id);
          if (_subsForTicket.last?.count == 0) _subsForTicket.removeLast();

          _subs[index] =
              _subs[index].copyWith(actualbookingLimit: ((int.parse(_subs[index].actualbookingLimit!) - 1).toString()));
        }
      });
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
          Text(
            S.of(context).SelectSubs,
            style: theme?.boldTextTheme.title2,
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace16,
          if (_subs.isNotEmpty)
            SubsInContentCard(
              subs: _subs,
              backgroundColor: theme?.colorScheme.surface,
              selectedSub: _selectedSub,
              onItemTap: (id) {
                _onSelectedSub(id);
              },
            ).paddingOnly(bottom: SpacingFoundation.verticalSpacing2),
          AutoSizeText(
            '${S.of(context).TicketPrice} $totalSubsTicketPrice ${widget.bookingUiModel?.currency}',
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
                  '${ticketCount + subTicketCount}',
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
          //TODO
          Text(
            S.of(context).SelectYourFavoriteProduct,
            style: theme?.boldTextTheme.title2,
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace16,
          if (_upsales.isNotEmpty)
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
                  '$ticketCount',
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
          SafeArea(
            child: context.gradientButton(
              data: BaseUiKitButtonData(
                text: S.of(context).GoToPayment.toUpperCase(),
                onPressed: () => widget.onSubmit(
                  _subsForTicket,
                  _upsalesForTicket,
                ),
              ),
            ),
          ).paddingSymmetric(horizontal: horizontalPadding),
        ],
      ),
    );
  }
}
