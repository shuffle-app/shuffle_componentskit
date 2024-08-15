import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'user_booking_list_item.dart';

class BookingListComponent extends StatefulWidget {
  final BookingsPlaceOrEventUiModel? bookingsPlaceItemUiModel;
  final BookingUiModel? bookingUiModel;
  final ValueChanged<int>? fullRefund;
  final ValueChanged<int>? partialRefund;
  final ValueChanged<int>? contactByMessage;
  final ValueChanged<String?>? contactByEmail;
  final ValueChanged<List<UserItemUiModel>?>? refundEveryone;
  final ValueChanged<BookingUiModel>? onBookingEdit;
  final VoidCallback? onGoAheadTap;
  final ValueChanged<int>? onContactTap;

  const BookingListComponent({
    super.key,
    this.bookingsPlaceItemUiModel,
    this.fullRefund,
    this.partialRefund,
    this.refundEveryone,
    this.contactByEmail,
    this.contactByMessage,
    this.bookingUiModel,
    this.onBookingEdit,
    this.onContactTap,
    this.onGoAheadTap,
  });

  @override
  State<BookingListComponent> createState() => _BookingListComponentState();
}

class _BookingListComponentState extends State<BookingListComponent> {
  bool chekBoxOn = false;
  List<List<UserItemUiModel>> groupedUsers = [];

  @override
  void initState() {
    super.initState();
    sortedUserList();
    groupUserList();
  }

  void sortedUserList() {
    if (widget.bookingsPlaceItemUiModel?.usersList != null && widget.bookingsPlaceItemUiModel!.usersList!.isNotEmpty) {
      widget.bookingsPlaceItemUiModel!.usersList!.sort((a, b) {
        if (a.tiketsCount != b.tiketsCount) {
          return b.tiketsCount.compareTo(a.tiketsCount);
        }

        int productsA = a.productsCount ?? 0;
        int productsB = b.productsCount ?? 0;

        return productsB.compareTo(productsA);
      });
    }
  }

  void groupUserList() {
    List<UserItemUiModel> currentGroup = [];
    final userList = widget.bookingsPlaceItemUiModel?.usersList;
    if (userList != null && userList.isNotEmpty) {
      for (var i = 0; i < userList.length; i++) {
        if (i == 0 ||
            (userList[i].tiketsCount == userList[i - 1].tiketsCount &&
                (userList[i].productsCount ?? 0) == (userList[i - 1].productsCount ?? 0))) {
          currentGroup.add(userList[i]);
        } else {
          groupedUsers.add(currentGroup);
          currentGroup = [userList[i]];
        }
      }
      groupedUsers.add(currentGroup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        title: S.of(context).BookingList,
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
                      style: theme?.boldTextTheme.title2,
                    ),
                    SpacingFoundation.verticalSpace2,
                    Text(
                      widget.bookingsPlaceItemUiModel?.description ?? '',
                      style: theme?.boldTextTheme.caption2Bold.copyWith(color: ColorsFoundation.mutedText),
                    ),
                    SpacingFoundation.verticalSpace16,
                  ],
                ),
              ),
              if (widget.bookingsPlaceItemUiModel?.usersList == null ||
                  widget.bookingsPlaceItemUiModel!.usersList!.isEmpty) ...[
                GestureDetector(
                  onTap: () {
                    context.push(
                      CreateBookingComponent(
                        onBookingCreated: (value) => widget.onBookingEdit?.call(value),
                        bookingUiModel: widget.bookingUiModel,
                      ),
                    );
                  },
                  child: ImageWidget(
                    link: GraphicsFoundation.instance.svg.pencil.path,
                    color: theme?.colorScheme.inversePrimary,
                  ),
                ),
              ],
            ],
          ),
          if (groupedUsers.isNotEmpty) ...[
            ListView.separated(
              itemCount: groupedUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              controller: ScrollController(),
              separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
              itemBuilder: (context, index) {
                return Column(
                  children: groupedUsers[index]
                      .map(
                        (e) => UserBookingListItem(
                          element: e,
                          isFirst: e == groupedUsers[index].first,
                          checkBox: chekBoxOn,
                          onLongPress: () => setState(() {
                            chekBoxOn = !chekBoxOn;
                          }),
                          onCheckBoxTap: () => setState(() {
                            e.isSelected = !e.isSelected;
                          }),
                          contactByEmail: widget.contactByEmail,
                          contactByMessage: widget.contactByMessage,
                          fullRefund: widget.fullRefund,
                          partialRefund: widget.partialRefund,
                          onRequestsRefund: () => getRefundBookingDialogUiKit(
                            context: context,
                            userName: e.name,
                            allTicket: e.tiketsCount,
                            allUpsale: e.productsCount ?? 0,
                            ticketRefun: e.requestRefunUiModel?.ticketRefun ?? 0,
                            upsaleRefun: e.requestRefunUiModel?.upsaleRefun ?? 0,
                            onContactTap: () => widget.onContactTap?.call(e.id),
                            onGoAheadTap: () => widget.onGoAheadTap?.call(),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            SpacingFoundation.verticalSpace24,
            SafeArea(
              top: false,
              child: context.outlinedButton(
                data: BaseUiKitButtonData(
                  fit: ButtonFit.fitWidth,
                  text: S.of(context).RefundEveryone.toUpperCase(),
                  onPressed: () {
                    chekBoxOn
                        ? widget.refundEveryone?.call(
                            widget.bookingsPlaceItemUiModel?.usersList!.where((element) => element.isSelected).toList())
                        : widget.refundEveryone?.call(widget.bookingsPlaceItemUiModel?.usersList!);
                  },
                ),
              ),
            ),
            SpacingFoundation.verticalSpace24,
          ],
        ],
      ),
    );
  }
}
