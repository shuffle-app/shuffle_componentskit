import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'bookings_control_ui_models/user_bookings_control_ui_model.dart';

class UsersBookingsControl extends StatelessWidget {
  final bool isFirst;
  final bool checkBox;
  final UserBookingsControlUiModel element;
  final VoidCallback? onLongPress;
  final VoidCallback? onCheckBoxTap;
  final VoidCallback? onRequestsRefund;
  final Function(String? value, int userId)? onPopupMenuSelected;

  const UsersBookingsControl({
    super.key,
    required this.element,
    this.isFirst = false,
    this.checkBox = false,
    this.onLongPress,
    this.onCheckBoxTap,
    this.onRequestsRefund,
    this.onPopupMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;

    return Column(
      children: [
        if (element.ticketUiModel?.totalUpsalesCount != null && isFirst) ...[
          Row(
            children: [
              if (element.ticketUiModel!.ticketsCount >= 1) ...[
                Text(
                  S.of(context).Tickets(element.ticketUiModel!.ticketsCount),
                  style: boldTextTheme?.caption1Bold.copyWith(
                    color: ColorsFoundation.mutedText,
                  ),
                ),
                SpacingFoundation.horizontalSpace12,
              ],
              if (element.ticketUiModel!.totalUpsalesCount >= 1)
                Text(
                  S.of(context).Products(element.ticketUiModel!.totalUpsalesCount),
                  style: boldTextTheme?.caption1Bold.copyWith(
                    color: ColorsFoundation.mutedText,
                  ),
                ),
            ],
          ),
          SpacingFoundation.verticalSpace2,
        ],
        GestureDetector(
          onLongPress: onLongPress,
          onTap: element.refundUiModel != null ? onRequestsRefund : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  context.userAvatar(
                    size: UserAvatarSize.x40x40,
                    type: element.profile?.userTileType ?? UserTileType.ordinary,
                    userName: element.profile?.name ?? '',
                    imageUrl: element.profile?.avatarUrl,
                  ),
                  if (element.refundUiModel != null)
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        color: ColorsFoundation.error,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        width: 10,
                        height: 10,
                      ),
                    )
                ],
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
                          element.profile?.name ?? '',
                          style: boldTextTheme?.caption1Medium,
                        ),
                        if (element.profile?.userTileType == UserTileType.influencer) ...[
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
                      element.profile?.nickname ?? '',
                      style: boldTextTheme?.caption1Bold.copyWith(
                        color: ColorsFoundation.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              checkBox
                  ? UiKitCheckbox(
                      isActive: element.isSelected,
                      onChanged: onCheckBoxTap,
                    )
                  : PopupMenuButton(
                      icon: const ImageWidget(iconData: ShuffleUiKitIcons.morevert),
                      splashRadius: 1,
                      menuPadding: EdgeInsets.all(EdgeInsetsFoundation.all24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusFoundation.all16,
                      ),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'refund',
                          child: Text(
                            S.of(context).FullRefund,
                            style: boldTextTheme?.caption2Medium.copyWith(
                              color: theme?.colorScheme.inverseBodyTypography,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'partialrefund',
                          child: Text(
                            S.of(context).PartialRefund,
                            style: boldTextTheme?.caption2Medium.copyWith(
                              color: theme?.colorScheme.inverseBodyTypography,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'contact',
                          child: Text(
                            S.of(context).Contact,
                            style: boldTextTheme?.caption2Medium.copyWith(
                              color: theme?.colorScheme.inverseBodyTypography,
                            ),
                          ),
                        ),
                      ],
                      onSelected: (value) => onPopupMenuSelected?.call(value, element.id),
                    )
            ],
          ),
        ),
      ],
    ).paddingOnly(top: !isFirst ? SpacingFoundation.verticalSpacing16 : 0);
  }
}
