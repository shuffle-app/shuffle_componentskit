import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/profile/spent_points/ui_model_discounts.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SpentPointBarcodeComponent extends StatelessWidget {
  final Widget? barcode;
  final String? barcodeNumber;
  final UiModelDiscounts? uiModelDiscounts;
  final String? discountTitle;
  final String? xActivated;

  const SpentPointBarcodeComponent({
    super.key,
    this.barcode,
    this.uiModelDiscounts,
    this.discountTitle,
    this.barcodeNumber,
    this.xActivated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        barcode != null
            ? barcode!
            : (barcodeNumber != null && barcodeNumber!.isNotEmpty)
                ? UiKitCardWrapper(
                    width: 0.85.sw,
                    height: 0.24.sh,
                    color: theme?.colorScheme.inversePrimary,
                    borderRadius: BorderRadiusFoundation.all24r,
                    child: BarcodeWidget(
                      barcode: Barcode.code128(escapes: true),
                      data: barcodeNumber!,
                      style: theme?.regularTextTheme.caption2.copyWith(color: theme.colorScheme.primary),
                      textPadding: SpacingFoundation.verticalSpacing8,
                    ).paddingOnly(
                      top: SpacingFoundation.verticalSpacing10,
                      bottom: SpacingFoundation.verticalSpacing6,
                      left: SpacingFoundation.horizontalSpacing12,
                      right: SpacingFoundation.horizontalSpacing12,
                    ),
                  )
                : UiKitCardWrapper(
                    child: SizedBox(width: double.infinity, height: 146.h),
                  ),
        SpacingFoundation.verticalSpace16,
        Text(
          S.current.XSuccessfullyActivated(xActivated ?? S.current.Offer),
          style: theme?.boldTextTheme.body,
          textAlign: TextAlign.center,
        ),
        SpacingFoundation.verticalSpace16,
        Text(
          uiModelDiscounts?.contentShortUiModel.title ?? '',
          style: theme?.boldTextTheme.caption1Bold,
          textAlign: TextAlign.center,
        ),
        Text(
          discountTitle ?? '',
          style: theme?.boldTextTheme.caption1Bold,
          textAlign: TextAlign.center,
        ),
        SpacingFoundation.verticalSpace16,
        Text(
          S.current.ShowTheBarcode,
          style: theme?.regularTextTheme.caption1,
          textAlign: TextAlign.center,
        ),
      ],
    ).paddingAll(EdgeInsetsFoundation.all16);
  }
}
