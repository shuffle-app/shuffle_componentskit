import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'users_bookings_control.dart';

class BookingsControlUserList extends StatefulWidget {
  final BookingsPlaceOrEventUiModel? bookingsPlaceItemUiModel;
  final BookingUiModel? bookingUiModel;
  final ValueChanged<BookingUiModel?>? onBookingEdit;
  final Function(String? value, int userId)? onPopupMenuSelected;
  final ValueChanged<UserBookingsControlUiModel>? onRequestsRefund;
  final ValueChanged<List<UserBookingsControlUiModel>?>? refundEveryone;
  final bool canBookingEdit;

  const BookingsControlUserList({
    super.key,
    this.bookingsPlaceItemUiModel,
    this.refundEveryone,
    this.bookingUiModel,
    this.onBookingEdit,
    this.onPopupMenuSelected,
    this.onRequestsRefund,
    this.canBookingEdit = false,
  });

  @override
  State<BookingsControlUserList> createState() => _BookingsControlUserListState();
}

class _BookingsControlUserListState extends State<BookingsControlUserList> {
  bool checkBoxOn = false;
  List<List<UserBookingsControlUiModel>> groupedUsers = [];

  @override
  void initState() {
    super.initState();
    sortedUserList();
    groupUserList();
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
          ),
        ),
        centerTitle: true,
        autoImplyLeading: true,
        customToolbarBaseHeight: 1.sw <= 380 ? 0.18.sh : 0.13.sh,
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
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
              if (widget.canBookingEdit)
                GestureDetector(
                  onTap: () => widget.onBookingEdit?.call(widget.bookingUiModel),
                  child: ImageWidget(
                    link: GraphicsFoundation.instance.svg.pencil.path,
                    color: theme?.colorScheme.inversePrimary,
                  ),
                ),
            ],
          ),
          if (groupedUsers.isNotEmpty) ...[
            ...groupedUsers.map(
              (group) => Column(
                children: group
                    .map(
                      (e) => UsersBookingsControl(
                        element: e,
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
                      ).paddingOnly(bottom: group.last == e ? SpacingFoundation.verticalSpacing16 : 0),
                    )
                    .toList(),
              ),
            ),
            SpacingFoundation.verticalSpace24,
          ] else
            Text(
              S.of(context).NoBookingsYet,
              style: boldTextTheme?.body,
            )
        ],
      ),
      bottomNavigationBar: groupedUsers.isNotEmpty
          ? context
              .outlinedButton(
                showOnCenter: false,
                data: BaseUiKitButtonData(
                  text: S.of(context).RefundEveryone.toUpperCase(),
                  onPressed: () {
                    checkBoxOn
                        ? widget.refundEveryone?.call(
                            widget.bookingsPlaceItemUiModel?.users!.where((element) => element.isSelected).toList())
                        : widget.refundEveryone?.call(widget.bookingsPlaceItemUiModel?.users!);
                  },
                ),
              )
              .paddingOnly(
                left: EdgeInsetsFoundation.all16,
                right: EdgeInsetsFoundation.all16,
                bottom: EdgeInsetsFoundation.vertical24,
              )
          : null,
    );
  }
}
