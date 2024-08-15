import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'booking_list_component.dart';
import 'booking_request_event_item.dart';

class BookingRequestComponent extends StatefulWidget {
  final List<BookingsPlaceOrEventUiModel>? places;
  final List<BookingsEventUiModel>? events;
  final Function(int)? fullRefund;
  final Function(int)? partialRefund;
  final Function(List<UserItemUiModel>?)? refundEveryone;
  final Function(int id)? contactByMessage;
  final Function(int id)? contactByEmail;
  final BookingUiModel? bookingUiModel;
  final Function(BookingUiModel)? onBookingEdit;

  const BookingRequestComponent({
    super.key,
    this.places,
    this.events,
    this.fullRefund,
    this.partialRefund,
    this.refundEveryone,
    this.contactByMessage,
    this.contactByEmail,
    this.bookingUiModel,
    this.onBookingEdit,
  });

  @override
  State<BookingRequestComponent> createState() => _BookingRequestComponentState();
}

class _BookingRequestComponentState extends State<BookingRequestComponent> {
  String selectedTab = 'place';

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        title: S.of(context).BookingsHeading,
        autoImplyLeading: true,
        centerTitle: true,
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        children: [
          SpacingFoundation.verticalSpace16,
          UiKitCustomTabBar(
            selectedTab: selectedTab,
            onTappedTab: (index) {
              setState(() {
                selectedTab = [
                  'place',
                  'events',
                ][index];
              });
            },
            tabs: [
              UiKitCustomTab(
                title: S.of(context).Place.toUpperCase(),
                customValue: 'place',
              ),
              UiKitCustomTab(
                title: S.of(context).Events.toUpperCase(),
                customValue: 'events',
              ),
            ],
          ),
          SpacingFoundation.verticalSpace24,
          if (selectedTab == 'place') ...[
            if (widget.places != null && widget.places!.isNotEmpty) ...[
              ListView.separated(
                itemCount: widget.places!.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                controller: ScrollController(),
                separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
                itemBuilder: (context, index) {
                  final element = widget.places![index];

                  return BookingRequestPlaceItemUiKit(
                    title: element.title,
                    description: element.description,
                    imageUrl: element.imageUrl,
                    onTap: () => context.push(
                      BookingListComponent(
                        fullRefund: widget.fullRefund,
                        partialRefund: widget.partialRefund,
                        refundEveryone: widget.refundEveryone,
                        contactByEmail: widget.contactByEmail,
                        contactByMessage: widget.contactByMessage,
                        bookingsPlaceItemUiModel: element,
                        bookingUiModel: widget.bookingUiModel,
                        onBookingEdit: widget.onBookingEdit,
                      ),
                    ),
                  );
                },
              ),
            ]
          ] else ...[
            if (widget.events != null && widget.events!.isNotEmpty) ...[
              ListView.separated(
                itemCount: widget.events!.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                controller: ScrollController(),
                separatorBuilder: (context, index) => Divider(
                  color: theme?.colorScheme.surface2,
                  thickness: 2.0,
                ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
                itemBuilder: (context, index) {
                  final element = widget.events![index];

                  return BookingRequestEventItemUiKit(
                    title: element.title,
                    description: element.description,
                    events: element.events,
                    onTap: (id) => context.push(
                      BookingListComponent(
                        fullRefund: widget.fullRefund,
                        partialRefund: widget.partialRefund,
                        refundEveryone: widget.refundEveryone,
                        contactByEmail: widget.contactByEmail,
                        contactByMessage: widget.contactByMessage,
                        bookingsPlaceItemUiModel: element.events?.firstWhere((element) => element.id == id),
                        bookingUiModel: widget.bookingUiModel,
                        onBookingEdit: widget.onBookingEdit,
                      ),
                    ),
                  );
                },
              )
            ]
          ],
          SpacingFoundation.verticalSpace24,
        ],
      ),
    );
  }
}
