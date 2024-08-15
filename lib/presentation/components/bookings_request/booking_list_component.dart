import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class BookingListComponent extends StatefulWidget {
  final BookingsPlaceOrEventUiModel? bookingsPlaceItemUiModel;
  final Function(int id)? fullRefund;
  final Function(int id)? partialRefund;
  final Function(List<UserItemUiModel>?)? refundEveryone;
  final Function(int id)? contactByMessage;
  final Function(int id)? contactByEmail;
  final BookingUiModel? bookingUiModel;
  final Function(BookingUiModel)? onBookingEdit;

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
  });

  @override
  State<BookingListComponent> createState() => _BookingListComponentState();
}

class _BookingListComponentState extends State<BookingListComponent> {
  bool chekBoxOn = false;

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
                        onBookingCreated: (value) {
                          if (widget.onBookingEdit != null) {
                            return widget.onBookingEdit!(value);
                          }
                        },
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
          if (widget.bookingsPlaceItemUiModel?.usersList != null &&
              widget.bookingsPlaceItemUiModel!.usersList!.isNotEmpty) ...[
            ListView.separated(
              itemCount: widget.bookingsPlaceItemUiModel!.usersList!.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              controller: ScrollController(),
              separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
              itemBuilder: (context, index) {
                final element = widget.bookingsPlaceItemUiModel!.usersList![index];

                return Column(
                  children: [
                    if ((element.productsCount != null && element.productsCount! > 0) || element.tiketsCount > 1) ...[
                      Row(
                        children: [
                          if (element.tiketsCount > 1) ...[
                            Text(
                              S.of(context).Tickets(element.tiketsCount),
                              style: theme?.boldTextTheme.caption1Bold.copyWith(
                                color: ColorsFoundation.mutedText,
                              ),
                            ),
                            SpacingFoundation.horizontalSpace12,
                          ],
                          if (element.productsCount != null && element.productsCount! > 0) ...[
                            Text(
                              S.of(context).Products(element.productsCount!),
                              style: theme?.boldTextTheme.caption1Bold.copyWith(
                                color: ColorsFoundation.mutedText,
                              ),
                            ),
                          ]
                        ],
                      ),
                      SpacingFoundation.verticalSpace2,
                    ],
                    GestureDetector(
                      onLongPress: () {
                        setState(() {
                          chekBoxOn = !chekBoxOn;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          context.userAvatar(
                            size: UserAvatarSize.x40x40,
                            type: element.type ?? UserTileType.ordinary,
                            userName: element.name ?? '',
                            imageUrl: element.avatarUrl,
                          ),
                          SpacingFoundation.horizontalSpace12,
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      element.name ?? '',
                                      style: theme?.boldTextTheme.caption1Medium,
                                    ),
                                    if (element.type == UserTileType.influencer) ...[
                                      SpacingFoundation.horizontalSpace8,
                                      const GradientableWidget(
                                        gradient: GradientFoundation.badgeIcon,
                                        child: ImageWidget(
                                          iconData: ShuffleUiKitIcons.gradientStar,
                                        ),
                                      )
                                    ]
                                  ],
                                ),
                                Text(
                                  element.nickName ?? '',
                                  style: theme?.boldTextTheme.caption1Bold.copyWith(
                                    color: ColorsFoundation.mutedText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (chekBoxOn) ...[
                            UiKitCheckbox(
                              isActive: element.isSelected,
                              onChanged: () {
                                setState(() {
                                  element.isSelected = !element.isSelected;
                                });
                              },
                            )
                          ] else ...[
                            PopupMenuButton(
                              icon: const ImageWidget(iconData: ShuffleUiKitIcons.morevert),
                              splashRadius: 1,
                              menuPadding: EdgeInsets.all(EdgeInsetsFoundation.all24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusFoundation.all16,
                              ),
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  value: 0,
                                  child: Text(
                                    S.of(context).FullRefund,
                                    style: theme?.boldTextTheme.caption2Medium.copyWith(
                                      color: theme.colorScheme.inverseBodyTypography,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: Text(
                                    S.of(context).PartialRefund,
                                    style: theme?.boldTextTheme.caption2Medium.copyWith(
                                      color: theme.colorScheme.inverseBodyTypography,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Text(
                                    S.of(context).Contact,
                                    style: theme?.boldTextTheme.caption2Medium.copyWith(
                                      color: theme.colorScheme.inverseBodyTypography,
                                    ),
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 0) {
                                  if (widget.fullRefund != null) {
                                    widget.fullRefund!(element.id);
                                  }
                                } else if (value == 1) {
                                  if (widget.partialRefund != null) {
                                    widget.partialRefund!(element.id);
                                  }
                                } else {
                                  showUiKitAlertDialog(
                                    context,
                                    AlertDialogData(
                                      defaultButtonText: '',
                                      insetPadding: EdgeInsets.all(EdgeInsetsFoundation.all24),
                                      title: Text(
                                        '${S.of(context).ContactWith} ${element.name}',
                                        style: theme?.boldTextTheme.title2.copyWith(
                                          color: theme.colorScheme.inverseHeadingTypography,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                S.of(context).ByMessage,
                                                style: theme?.boldTextTheme.body.copyWith(
                                                  color: theme.colorScheme.inverseBodyTypography,
                                                ),
                                              ),
                                            ),
                                            context.smallOutlinedButton(
                                              data: BaseUiKitButtonData(
                                                borderColor: theme?.colorScheme.primary,
                                                backgroundColor: Colors.transparent,
                                                iconInfo: BaseUiKitButtonIconData(
                                                  iconData: ShuffleUiKitIcons.chevronright,
                                                  color: theme?.colorScheme.primary,
                                                ),
                                                onPressed: () => widget.contactByMessage != null
                                                    ? widget.contactByMessage!(element.id)
                                                    : null,
                                              ),
                                            )
                                          ],
                                        ),
                                        SpacingFoundation.verticalSpace16,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                S.of(context).ByEmail,
                                                style: theme?.boldTextTheme.body.copyWith(
                                                  color: theme.colorScheme.inverseBodyTypography,
                                                ),
                                              ),
                                            ),
                                            context.smallOutlinedButton(
                                              data: BaseUiKitButtonData(
                                                borderColor: theme?.colorScheme.primary,
                                                backgroundColor: Colors.transparent,
                                                iconInfo: BaseUiKitButtonIconData(
                                                  iconData: ShuffleUiKitIcons.chevronright,
                                                  color: theme?.colorScheme.primary,
                                                ),
                                                onPressed: () => widget.contactByEmail != null
                                                    ? widget.contactByEmail!(element.id)
                                                    : null,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            )
                          ]
                        ],
                      ),
                    ),
                  ],
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
                    if (widget.refundEveryone != null) {
                      widget.refundEveryone!(
                        widget.bookingsPlaceItemUiModel?.usersList!
                            .where(
                              (element) => element.isSelected,
                            )
                            .toList(),
                      );
                    }
                  },
                ),
              ),
            ),
            SpacingFoundation.verticalSpace24,
          ],
        ],
      ),
      //TODO
      // bottomNavigationBar: context
      //     .outlinedButton(
      //       data: BaseUiKitButtonData(
      //         text: 'Refund everyone'.toUpperCase(),
      //         onPressed: () {},
      //       ),
      //     )
      //     .paddingOnly(
      //       left: EdgeInsetsFoundation.all16,
      //       right: EdgeInsetsFoundation.all16,
      //       bottom: EdgeInsetsFoundation.vertical24,
      //     ),
    );
  }
}
