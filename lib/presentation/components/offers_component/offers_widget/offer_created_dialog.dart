import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

offerCreatedDialog(BuildContext context) {
  final theme = context.uiKitTheme;

  return showUiKitAlertDialog(
    context,
    AlertDialogData(
      insetPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
      title: Text(
        S.of(context).OfferSuccessfullyActivated,
        style: theme?.boldTextTheme.title2.copyWith(color: theme.colorScheme.primary),
        textAlign: TextAlign.center,
      ),
      content: Text(
        S.of(context).YouCanSeeYourOffersPromotionMenu,
        style: theme?.boldTextTheme.body.copyWith(
          color: theme.colorScheme.inverseBodyTypography,
        ),
        textAlign: TextAlign.center,
      ),
      defaultButtonText: S.of(context).OkayCool,
    ),
  );
}
