import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'users_bookings_control.dart';

class BookingsControlListComponent extends StatefulWidget {
  final BookingsPlaceOrEventUiModel? bookingsPlaceItemUiModel;
  final BookingUiModel? bookingUiModel;
  final ValueChanged<BookingUiModel?>? onBookingEdit;
  final Function(int index, int userId)? onPopupMenuSelected;
  final ValueChanged<UserBookingsControlUiModel>? onRequestsRefund;
  final ValueChanged<List<UserBookingsControlUiModel>?>? refundEveryone;

  const BookingsControlListComponent({
    super.key,
    this.bookingsPlaceItemUiModel,
    this.refundEveryone,
    this.bookingUiModel,
    this.onBookingEdit,
    this.onPopupMenuSelected,
    this.onRequestsRefund,
  });

  @override
  State<BookingsControlListComponent> createState() => _BookingsControlListComponentState();
}

class _BookingsControlListComponentState extends State<BookingsControlListComponent> {
  bool chekBoxOn = false;
  List<List<UserBookingsControlUiModel>> groupedUsers = [];

  @override
  void initState() {
    super.initState();
    sortedUserList();
    groupUserList();
  }

  void sortedUserList() {
    if (widget.bookingsPlaceItemUiModel?.users != null && widget.bookingsPlaceItemUiModel!.users!.isNotEmpty) {
      widget.bookingsPlaceItemUiModel!.users!.sort((a, b) {
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
    List<UserBookingsControlUiModel> currentGroup = [];
    final userList = widget.bookingsPlaceItemUiModel?.users;
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
        customTitle: Expanded(
          child: AutoSizeText(
            S.of(context).BookingList,
            style: theme?.boldTextTheme.title1,
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
              if (widget.bookingsPlaceItemUiModel?.users == null ||
                  widget.bookingsPlaceItemUiModel!.users!.isEmpty) ...[
                GestureDetector(
                  onTap: () => widget.onBookingEdit?.call(widget.bookingUiModel),
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
                        (e) => UsersBookingsControl(
                          element: e,
                          isFirst: e == groupedUsers[index].first,
                          checkBox: chekBoxOn,
                          onLongPress: () => setState(() {
                            chekBoxOn = !chekBoxOn;
                          }),
                          onCheckBoxTap: () => setState(() {
                            e.isSelected = !e.isSelected;
                          }),
                          onPopupMenuSelected: widget.onPopupMenuSelected,
                          onRequestsRefund: () => widget.onRequestsRefund?.call(e),
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
                            widget.bookingsPlaceItemUiModel?.users!.where((element) => element.isSelected).toList())
                        : widget.refundEveryone?.call(widget.bookingsPlaceItemUiModel?.users!);
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
