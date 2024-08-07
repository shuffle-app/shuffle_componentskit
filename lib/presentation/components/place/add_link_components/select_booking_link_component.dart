import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SelectBookingLinkComponent extends StatelessWidget {
  final VoidCallback onExternalTap;
  final VoidCallback onBookingTap;

  const SelectBookingLinkComponent({
    super.key,
    required this.onExternalTap,
    required this.onBookingTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpacingFoundation.verticalSpace16,
        Text(
          S.of(context).SelectYourBooking,
          style: theme?.boldTextTheme.subHeadline,
          textAlign: TextAlign.center,
        ),
        SpacingFoundation.verticalSpace16,
        Divider(
          color: theme?.colorScheme.surface2,
          thickness: 2,
        ),
        SpacingFoundation.verticalSpace16,
        Row(
          children: [
            Expanded(
              child: Text(
                S.of(context).EnterExternalLink,
                style: theme?.boldTextTheme.caption1Medium,
              ),
            ),
            context.smallOutlinedButton(
              data: BaseUiKitButtonData(
                backgroundColor: Colors.transparent,
                iconInfo: BaseUiKitButtonIconData(
                  iconData: ShuffleUiKitIcons.chevronright,
                ),
                onPressed: onExternalTap,
              ),
            )
          ],
        ),
        SpacingFoundation.verticalSpace16,
        Divider(
          color: theme?.colorScheme.surface2,
          thickness: 2,
        ),
        SpacingFoundation.verticalSpace16,
        Row(
          children: [
            Expanded(
              child: Text(
                S.of(context).StartBookingCreation,
                style: theme?.boldTextTheme.caption1Medium,
              ),
            ),
            context.smallOutlinedButton(
              data: BaseUiKitButtonData(
                backgroundColor: Colors.transparent,
                iconInfo: BaseUiKitButtonIconData(
                  iconData: ShuffleUiKitIcons.chevronright,
                ),
                onPressed: onBookingTap,
              ),
            )
          ],
        ),
        SpacingFoundation.verticalSpace16,
        Divider(
          color: theme?.colorScheme.surface2,
          thickness: 2,
        ),
      ],
    ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16);
  }
}
