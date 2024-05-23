import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/subscription_offer_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SubscriptionOfferWidget extends StatelessWidget {
  final VoidCallback onTap;
  final bool selected;
  final SubscriptionOfferModel model;
  final double? bottomInset;

  const SubscriptionOfferWidget({
    super.key,
    required this.onTap,
    required this.selected,
    required this.model,
    this.bottomInset,
  });

  @override
  Widget build(BuildContext context) {
    final regularTextTheme = context.uiKitTheme?.regularTextTheme;
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          UiKitRadio(selected: selected),
          SpacingFoundation.horizontalSpace12,
          Expanded(
            child: Text(
              model.name,
              style: boldTextTheme?.caption1UpperCaseMedium,
            ),
          ),
          SpacingFoundation.horizontalSpace12,
          if (model.savings != null) ...[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusFoundation.max,
                gradient: GradientFoundation.donationLinearGradient,
              ),
              child: Text(
                '${model.savings}%',
                style: regularTextTheme?.caption4Regular.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ).paddingSymmetric(
                horizontal: EdgeInsetsFoundation.horizontal6,
                vertical: EdgeInsetsFoundation.vertical2,
              ),
            ),
            SpacingFoundation.horizontalSpace12,
          ],
          Text(
            model.formattedPriceWithPeriod,
            style: boldTextTheme?.caption1UpperCaseMedium,
          ),
        ],
      ).paddingOnly(bottom: bottomInset ?? 0),
    );
  }
}
