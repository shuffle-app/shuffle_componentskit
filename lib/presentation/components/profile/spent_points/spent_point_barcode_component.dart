import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/profile/spent_points/ui_model_discounts.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SpentPointBarcodeComponent extends StatelessWidget {
  const SpentPointBarcodeComponent({
    super.key,
    this.barcode,
    this.uiModelDiscounts, this.discountTitle,
  });

  final Widget? barcode;
  final UiModelDiscounts? uiModelDiscounts;
  final String? discountTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        barcode ??
            UiKitCardWrapper(
              child: SizedBox(width: double.infinity, height: 146.h),
            ),
        SpacingFoundation.verticalSpace16,
        Text(
         S.current.OfferSuccessfullyActivated,
          style: context.uiKitTheme?.boldTextTheme.body,
          textAlign: TextAlign.center,
        ),
        SpacingFoundation.verticalSpace16,
        Text(
         uiModelDiscounts?.contentShortUiModel.title ?? '',
          style: context.uiKitTheme?.boldTextTheme.caption1Bold,
          textAlign: TextAlign.center,
        ),
        Text(
          discountTitle ?? '',
          style: context.uiKitTheme?.boldTextTheme.caption1Bold,
          textAlign: TextAlign.center,
        ),
        SpacingFoundation.verticalSpace16,
        Text(
          S.current.ShowTheBarcode,
          style: context.uiKitTheme?.regularTextTheme.caption1,
          textAlign: TextAlign.center,
        ),
      ],
    ).paddingAll(EdgeInsetsFoundation.all16);
  }
}
