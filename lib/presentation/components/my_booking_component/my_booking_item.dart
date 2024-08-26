import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'my_booking_ui_model/my_booking_ui_model.dart';

class MyBookingItem extends StatelessWidget {
  final MyBookingUiModel? myBookingUiModel;
  final VoidCallback? onAlertCircleTap;
  final ValueChanged<int?>? onBarCodeTap;
  final ValueChanged<int?>? onLeaveFeedbackTap;
  final ValueChanged<int?>? onFullRefundTap;
  final ValueChanged<int?>? onPartialRefundTap;

  const MyBookingItem({
    super.key,
    this.myBookingUiModel,
    this.onAlertCircleTap,
    this.onBarCodeTap,
    this.onLeaveFeedbackTap,
    this.onFullRefundTap,
    this.onPartialRefundTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            context.userAvatar(
              size: UserAvatarSize.x40x40,
              type: UserTileType.ordinary,
              userName: '',
              imageUrl: GraphicsFoundation.instance.png.avatars.avatar9.path,
            ),
            SpacingFoundation.horizontalSpace12,
            Expanded(
              child: Text(
                myBookingUiModel?.name ?? S.of(context).NothingFound,
                style: boldTextTheme?.body,
              ),
            ),
            SpacingFoundation.horizontalSpace12,
            if (myBookingUiModel?.isPast ?? false)
              context.outlinedButton(
                padding: EdgeInsets.all(EdgeInsetsFoundation.all6),
                data: BaseUiKitButtonData(
                  iconInfo: BaseUiKitButtonIconData(
                    iconData: ShuffleUiKitIcons.alertcircle,
                    size: 14.h,
                  ),
                  onPressed: onAlertCircleTap,
                ),
              )
            else
              context.iconButtonNoPadding(
                data: BaseUiKitButtonData(
                  onPressed: () => onBarCodeTap?.call(myBookingUiModel?.id),
                  iconInfo: BaseUiKitButtonIconData(
                    iconData: ShuffleUiKitIcons.barcode,
                  ),
                ),
              ),
          ],
        ),
        SpacingFoundation.verticalSpace16,
        Row(
          children: [
            Expanded(
              child: Text(
                S.of(context).Ticket,
                style: boldTextTheme?.labelLarge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${myBookingUiModel?.ticketUiModel?.ticketsCount ?? '1'}',
                style: boldTextTheme?.subHeadline,
              ),
            ),
          ],
        ),
        SpacingFoundation.verticalSpace2,
        if (myBookingUiModel?.ticketUiModel?.totalUpsalesCount != null &&
            myBookingUiModel!.ticketUiModel!.totalUpsalesCount > 0) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  S.of(context).Product,
                  style: boldTextTheme?.labelLarge,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  myBookingUiModel!.ticketUiModel!.totalUpsalesCount.toString(),
                  style: boldTextTheme?.subHeadline,
                ),
              ),
            ],
          ),
          SpacingFoundation.verticalSpace2,
        ],
        Row(
          children: [
            Expanded(
              child: Text(
                S.of(context).Total,
                style: boldTextTheme?.labelLarge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${myBookingUiModel?.total ?? '0'} ${myBookingUiModel?.currency ?? ''}',
                style: boldTextTheme?.subHeadline,
              ),
            ),
          ],
        ),
        if (myBookingUiModel?.isPast ?? false) ...[
          SpacingFoundation.verticalSpace16,
          context.gradientButton(
            padding: EdgeInsets.symmetric(vertical: SpacingFoundation.verticalSpacing6),
            data: BaseUiKitButtonData(
              text: S.of(context).LeaveFeedback,
              onPressed: () => onLeaveFeedbackTap?.call(myBookingUiModel?.id),
              fit: ButtonFit.fitWidth,
            ),
          ),
        ] else ...[
          SpacingFoundation.verticalSpace16,
          context.outlinedButton(
            borderColor: theme?.colorScheme.primary,
            data: BaseUiKitButtonData(
              fit: ButtonFit.fitWidth,
              backgroundColor: theme?.colorScheme.inversePrimary,
              textColor: theme?.colorScheme.primary,
              text: S.of(context).FullRefund.toUpperCase(),
              onPressed: () => onFullRefundTap?.call(myBookingUiModel?.id),
            ),
          ),
          SpacingFoundation.verticalSpace12,
          context.outlinedButton(
            data: BaseUiKitButtonData(
              fit: ButtonFit.fitWidth,
              textColor: theme?.colorScheme.inversePrimary,
              text: S.of(context).PartialRefund.toUpperCase(),
              onPressed: () => onPartialRefundTap?.call(myBookingUiModel?.id),
            ),
          )
        ],
      ],
    );
  }
}
