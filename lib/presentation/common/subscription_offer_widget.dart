import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/subscription_offer_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SubscriptionOfferWidget extends StatelessWidget {
  final VoidCallback onTap;
  final bool selected;
  final SubscriptionOfferModel model;
  final double? bottomInset;
  final AutoSizeGroup autoSizeGroup;

  const SubscriptionOfferWidget({
    super.key,
    required this.onTap,
    required this.selected,
    required this.model,
    required this.autoSizeGroup,
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
            child: AutoSizeText(
              textAlign: TextAlign.start,
              model.name,
              maxLines: 1,
              style: boldTextTheme?.caption1UpperCaseMedium,
              group: autoSizeGroup,
            ),
          ),
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
          ],
          SpacingFoundation.horizontalSpace12,
          Expanded(
            child: AutoSizeText(
              minFontSize: 11.0,
              textAlign: TextAlign.right,
              maxLines: 1,
              model.formattedPriceWithPeriod,
              style: boldTextTheme?.caption1UpperCaseMedium,
              group: autoSizeGroup,
            ),
          ),
        ],
      ).paddingOnly(bottom: bottomInset ?? 0),
    );
  }
}
