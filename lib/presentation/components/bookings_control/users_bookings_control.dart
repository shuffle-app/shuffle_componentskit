import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'bookings_control_ui_models/user_bookings_control_ui_molde.dart';

class UsersBookingsControl extends StatelessWidget {
  final bool isFirst;
  final bool checkBox;
  final UserBookingsControlUiModel element;
  final VoidCallback? onLongPress;
  final VoidCallback? onCheckBoxTap;
  final ValueChanged<int>? contactByMessage;
  final ValueChanged<int>? fullRefund;
  final ValueChanged<int>? partialRefund;
  final ValueChanged<String?>? contactByEmail;
  final VoidCallback? onRequestsRefund;

  const UsersBookingsControl({
    super.key,
    required this.element,
    this.isFirst = false,
    this.checkBox = false,
    this.fullRefund,
    this.onLongPress,
    this.partialRefund,
    this.onCheckBoxTap,
    this.contactByEmail,
    this.contactByMessage,
    this.onRequestsRefund,
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
              if (element.productsCount! >= 1) ...[
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
                    type: element.type ?? UserTileType.ordinary,
                    userName: element.name ?? '',
                    imageUrl: element.avatarUrl,
                  ),
                  if (element.requestRefunUiModel != null &&
                      element.requestRefunUiModel!.ticketRefun > 0 &&
                      element.requestRefunUiModel!.upsaleRefun > 0) ...[
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
              if (checkBox) ...[
                UiKitCheckbox(
                  isActive: element.isSelected,
                  onChanged: onCheckBoxTap,
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
                      fullRefund?.call(element.id);
                    } else if (value == 1) {
                      partialRefund?.call(element.id);
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
                                    onPressed: () {
                                      contactByMessage?.call(element.id);
                                    },
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
                                    onPressed: () {
                                      contactByEmail?.call(element.email);
                                    },
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
    ).paddingOnly(top: !isFirst ? SpacingFoundation.verticalSpacing16 : 0);
  }
}
