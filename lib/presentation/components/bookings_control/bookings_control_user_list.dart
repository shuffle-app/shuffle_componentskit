import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_components_kit/presentation/utils/validators.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'users_bookings_control.dart';

class BookingsControlUserList extends StatefulWidget {
  final BookingsPlaceOrEventUiModel? bookingsPlaceItemUiModel;
  final VoidCallback? onBookingEdit;
  final VoidCallback? onScannerTap;
  final Function(String? value, int userId)? onPopupMenuSelected;
  final ValueChanged<UserBookingsControlUiModel>? onRequestsRefund;
  final ValueChanged<List<UserBookingsControlUiModel>?>? refundEveryone;
  final ValueChanged<String>? onChangeBookingUrl;
  final bool canBookingEdit;
  final bool isLoading;
  final String? bookingUrl;
  final int? showUpRatio;

  const BookingsControlUserList({
    super.key,
    this.bookingsPlaceItemUiModel,
    this.refundEveryone,
    this.onBookingEdit,
    this.onScannerTap,
    this.onPopupMenuSelected,
    this.onRequestsRefund,
    this.canBookingEdit = false,
    this.isLoading = false,
    this.bookingUrl,
    this.onChangeBookingUrl,
    this.showUpRatio,
  });

  @override
  State<BookingsControlUserList> createState() => _BookingsControlUserListState();
}

class _BookingsControlUserListState extends State<BookingsControlUserList> {
  bool checkBoxOn = false;
  bool isUrlBooking = false;
  bool isLinkValid = false;

  final TextEditingController bookingUrlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<List<UserBookingsControlUiModel>> groupedUsers = [];

  @override
  void initState() {
    super.initState();
    isUrlBooking = widget.bookingUrl != null && widget.bookingUrl!.isNotEmpty;
    if (isUrlBooking) {
      bookingUrlController.text = widget.bookingUrl!;
    } else {
      sortedUserList();
      groupUserList();
    }
  }

  void sortedUserList() {
    final users = widget.bookingsPlaceItemUiModel?.users;
    if (users != null && users.isNotEmpty) {
      users.sort((a, b) {
        final ticketComparison = (b.ticketUiModel?.ticketsCount ?? 0).compareTo(a.ticketUiModel?.ticketsCount ?? 0);
        if (ticketComparison != 0) {
          return ticketComparison;
        }

        final upsalesA = a.ticketUiModel?.totalUpsalesCount ?? 0;
        final upsalesB = b.ticketUiModel?.totalUpsalesCount ?? 0;

        return upsalesB.compareTo(upsalesA);
      });
    }
  }

  void groupUserList() {
    final List<UserBookingsControlUiModel> users = widget.bookingsPlaceItemUiModel?.users ?? [];
    if (users.isEmpty) return;

    List<UserBookingsControlUiModel> currentGroup = [];
    groupedUsers.clear();

    for (int i = 0; i < users.length; i++) {
      final currentUser = users[i];

      if (i == 0 ||
          (currentUser.ticketUiModel?.ticketsCount == users[i - 1].ticketUiModel?.ticketsCount &&
              (currentUser.ticketUiModel?.totalUpsalesCount ?? 0) ==
                  (users[i - 1].ticketUiModel?.totalUpsalesCount ?? 0))) {
        currentGroup.add(currentUser);
      } else {
        groupedUsers.add(currentGroup);
        currentGroup = [currentUser];
      }
    }
    groupedUsers.add(currentGroup);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        customTitle: Expanded(
          child: AutoSizeText(
            S.of(context).BookingList,
            style: boldTextTheme?.title1,
            textAlign: TextAlign.center,
            wrapWords: false,
            maxLines: 1,
          ),
        ),
        centerTitle: true,
        autoImplyLeading: true,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SpacingFoundation.verticalSpace16,
                    Text(
                      widget.bookingsPlaceItemUiModel?.title ?? '',
                      style: boldTextTheme?.title2,
                    ),
                    SpacingFoundation.verticalSpace2,
                    Text(
                      widget.bookingsPlaceItemUiModel?.description ?? '',
                      style: boldTextTheme?.caption2Bold.copyWith(color: ColorsFoundation.mutedText),
                    ),
                    groupedUsers.isNotEmpty ? SpacingFoundation.verticalSpace16 : SpacingFoundation.verticalSpace24,
                  ],
                ),
              ),
              if (!isUrlBooking)
                if (widget.canBookingEdit)
                  GestureDetector(
                    onTap: widget.onBookingEdit,
                    child: ImageWidget(
                      link: GraphicsFoundation.instance.svg.pencil.path,
                      color: theme?.colorScheme.inversePrimary,
                    ),
                  )
                else
                  GestureDetector(
                    onTap: widget.onBookingEdit,
                    child: ImageWidget(
                      iconData: ShuffleUiKitIcons.view,
                      color: theme?.colorScheme.inversePrimary,
                    ),
                  )
            ],
          ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          if (widget.isLoading)
            const Center(child: CircularProgressIndicator()).paddingAll(EdgeInsetsFoundation.all16)
          else if (isUrlBooking)
            Form(
              key: _formKey,
              child: UiKitInputFieldNoFill(
                label: 'URL',
                keyboardType: TextInputType.url,
                hintText: 'https://yoursite.com',
                inputFormatters: [PrefixFormatter(prefix: 'https://')],
                controller: bookingUrlController,
                validator: bookingWebsiteValidator,
                onChanged: (value) {
                  setState(() {
                    isLinkValid = _formKey.currentState!.validate();
                  });
                },
              ),
            ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16)
          else if (groupedUsers.isNotEmpty) ...[
            if (widget.showUpRatio != null && widget.showUpRatio! > 0 && groupedUsers.isNotEmpty)
              UiKitCardWrapper(
                color: theme?.colorScheme.surface2,
                border: BorderSide(color: ColorsFoundation.neutral16),
                borderRadius: BorderRadiusFoundation.all8,
                child: Row(
                  children: [
                    SpacingFoundation.horizontalSpace12,
                    Flexible(
                      flex: 8,
                      child: AutoSizeText(
                        S.of(context).ShowUpRatio.toUpperCase(),
                        style: theme?.regularTextTheme.caption1UpperCase,
                        wrapWords: false,
                        maxLines: 1,
                      ),
                    ),
                    SpacingFoundation.horizontalSpace8,
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => showUiKitPopover(
                          context,
                          customMinHeight: 30.h,
                          showButton: false,
                          title: Text(
                            S.of(context).BookingPopUpText,
                            style: theme?.regularTextTheme.body.copyWith(color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        child: ImageWidget(
                          iconData: ShuffleUiKitIcons.info,
                          width: 16.w,
                          color: theme?.colorScheme.darkNeutral900,
                        ),
                      ),
                    ),
                    Spacer(),
                    GradientableWidget(
                      gradient: GradientFoundation.attentionCard,
                      child: Text(
                        '${widget.showUpRatio}%',
                        style: boldTextTheme?.body,
                      ),
                    ),
                    SpacingFoundation.horizontalSpace12,
                  ],
                ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing10),
              ).paddingOnly(
                bottom: SpacingFoundation.horizontalSpacing16,
                left: SpacingFoundation.horizontalSpacing16,
                right: SpacingFoundation.horizontalSpacing16,
              ),
            ...groupedUsers.map(
              (group) => Column(
                children: group
                    .map(
                      (e) => UsersBookingsControl(
                        element: e,
                        noShows: e.noShows,
                        isFirst: e == group.first,
                        checkBox: checkBoxOn,
                        onLongPress: () => setState(() {
                          checkBoxOn = !checkBoxOn;
                        }),
                        onCheckBoxTap: () => setState(() {
                          e.isSelected = !e.isSelected;
                        }),
                        onPopupMenuSelected: widget.onPopupMenuSelected,
                        onRequestsRefund: () => widget.onRequestsRefund?.call(e),
                      ).paddingOnly(
                        bottom: group.last == e ? SpacingFoundation.verticalSpacing16 : 0,
                        left: SpacingFoundation.horizontalSpacing16,
                        right: checkBoxOn ? SpacingFoundation.horizontalSpacing16 : 0.0,
                      ),
                    )
                    .toList(),
              ),
            ),
            SpacingFoundation.verticalSpace24,
          ] else
            Text(
              S.of(context).NoBookingsYet,
              style: boldTextTheme?.body,
            ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16)
        ],
      ),
      bottomNavigationBar: groupedUsers.isNotEmpty
          ? SizedBox(
              height: (kBottomNavigationBarHeight + EdgeInsetsFoundation.vertical24) * 2,
              child: Column(
                children: [
                  SizedBox(
                    height: kBottomNavigationBarHeight + EdgeInsetsFoundation.vertical24,
                    child: context
                        .outlinedButton(
                          borderRadius: BorderRadiusFoundation.all24r,
                          data: BaseUiKitButtonData(
                            text: S.of(context).RefundEveryone.toUpperCase(),
                            onPressed: () {
                              checkBoxOn
                                  ? widget.refundEveryone?.call(widget.bookingsPlaceItemUiModel?.users!
                                      .where((element) => element.isSelected)
                                      .toList())
                                  : widget.refundEveryone?.call(widget.bookingsPlaceItemUiModel?.users!);
                            },
                          ),
                        )
                        .paddingOnly(
                          left: EdgeInsetsFoundation.all16,
                          right: EdgeInsetsFoundation.all16,
                          bottom: EdgeInsetsFoundation.all16,
                        ),
                  ),
                  SizedBox(
                    height: kBottomNavigationBarHeight + EdgeInsetsFoundation.vertical24,
                    width: 1.sw,
                    child: context
                        .gradientButton(
                          data: BaseUiKitButtonData(
                            text: S.of(context).CodeScanner.toUpperCase(),
                            onPressed: widget.onScannerTap,
                          ),
                        )
                        .paddingOnly(
                          left: EdgeInsetsFoundation.all16,
                          right: EdgeInsetsFoundation.all16,
                          bottom: EdgeInsetsFoundation.vertical24,
                        ),
                  ),
                ],
              ),
            )
          : isLinkValid
              ? SizedBox(
                  height: kBottomNavigationBarHeight + EdgeInsetsFoundation.vertical24,
                  width: 1.sw,
                  child: context
                      .gradientButton(
                        data: BaseUiKitButtonData(
                          text: S.of(context).Save.toUpperCase(),
                          onPressed: () => widget.onChangeBookingUrl?.call(bookingUrlController.text),
                        ),
                      )
                      .paddingOnly(
                        left: EdgeInsetsFoundation.all16,
                        right: EdgeInsetsFoundation.all16,
                        bottom: EdgeInsetsFoundation.vertical24,
                      ),
                )
              : null,
    );
  }
}
