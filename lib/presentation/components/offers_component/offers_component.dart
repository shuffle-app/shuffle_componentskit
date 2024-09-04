import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'offer_ui_model.dart';
import 'offers_widget/offer_item_widget.dart';

class OffersComponent extends StatelessWidget {
  final String? placeOrEventName;
  final List<OfferUiModel?>? listOffers;
  final ValueChanged<int?>? onEditOffer;
  final ValueChanged<int?>? onRemoveOffer;
  final VoidCallback? onCreateOffer;

  const OffersComponent({
    super.key,
    this.placeOrEventName,
    this.listOffers,
    this.onEditOffer,
    this.onCreateOffer,
    this.onRemoveOffer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        customTitle: Text(
          S.of(context).Offers,
          style: theme?.boldTextTheme.title1.copyWith(fontSize: 1.sw <= 380 ? 22.w : 23.w),
          textAlign: TextAlign.center,
        ),
        autoImplyLeading: true,
        appBarTrailing: context.outlinedButton(
          padding: EdgeInsets.all(EdgeInsetsFoundation.all6),
          data: BaseUiKitButtonData(
            onPressed: onCreateOffer,
            iconInfo: BaseUiKitButtonIconData(
              iconData: ShuffleUiKitIcons.plus,
            ),
          ),
        ),
        children: [
          SpacingFoundation.verticalSpace16,
          if (listOffers != null && listOffers!.isEmpty)
            UiKitCardWrapper(
              borderRadius: BorderRadiusFoundation.all24r,
              child: Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: Text(
                      S.of(context).CreateNewOfferYourPlace(placeOrEventName ?? S.of(context).Place.toLowerCase()),
                      style: theme?.boldTextTheme.body,
                    ),
                  ),
                  Flexible(
                    child: ImageWidget(
                      height: 60.h,
                      fit: BoxFit.fitHeight,
                      link: GraphicsFoundation.instance.svg.indexFingerHands.path,
                    ),
                  )
                ],
              ).paddingAll(EdgeInsetsFoundation.all16),
            )
          else
            ...listOffers!.map((offer) {
              double padding = SpacingFoundation.verticalSpacing16;
              if (offer == listOffers!.last) padding = 0;

              return OfferItemWidget(
                offerUiModel: offer,
                onDismissed: () => onRemoveOffer?.call(offer?.id),
                onTap: () => onEditOffer?.call(offer?.id),
              ).paddingOnly(bottom: padding);
            }),
        ],
      ),
    );
  }
}
