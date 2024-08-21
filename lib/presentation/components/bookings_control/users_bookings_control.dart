import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'bookings_control_ui_models/user_bookings_control_ui_molde.dart';

class UsersBookingsControl extends StatelessWidget {
  final bool isFirst;
  final bool checkBox;
  final UserBookingsControlUiModel element;
  final VoidCallback? onLongPress;
  final VoidCallback? onCheckBoxTap;
  final VoidCallback? onRequestsRefund;
  final Function(int index, int userId)? onPopupMenuSelected;

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

    return Column(
      children: [
        if (element.productsCount != null && isFirst) ...[
          Row(
            children: [
              if (element.tiketsCount >= 1) ...[
                Text(
                  S.of(context).Tickets(element.tiketsCount),
                  style: theme?.boldTextTheme.caption1Bold.copyWith(
                    color: ColorsFoundation.mutedText,
                  ),
                ),
                SpacingFoundation.horizontalSpace12,
              ],
              if (element.productsCount! >= 1)
                Text(
                  S.of(context).Products(element.productsCount!),
                  style: theme?.boldTextTheme.caption1Bold.copyWith(
                    color: ColorsFoundation.mutedText,
                  ),
                ),
            ],
          ),
          SpacingFoundation.verticalSpace2,
        ],
        GestureDetector(
          onLongPress: onLongPress,
          onTap: element.requestRefunUiModel != null ? onRequestsRefund : null,
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
                  if (element.requestRefunUiModel != null &&
                      element.requestRefunUiModel!.ticketRefund > 0 &&
                      element.requestRefunUiModel!.upsaleRefund > 0) ...[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: ColorsFoundation.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ]
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
                          style: theme?.boldTextTheme.caption1Medium,
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
                      style: theme?.boldTextTheme.caption1Bold.copyWith(
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
                      onSelected: (value) => onPopupMenuSelected?.call(value, element.id),
                    )
            ],
          ),
        ),
      ],
    ).paddingOnly(top: !isFirst ? SpacingFoundation.verticalSpacing16 : 0);
  }
}
