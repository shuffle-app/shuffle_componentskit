import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/common/subscription_offer_widget.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CompanySubscriptionComponent extends StatefulWidget {
  final UiCompanySubscriptionModel uiModel;
  final ValueChanged<SubscriptionOfferModel>? onSubscribe;
  final VoidCallback? onRestorePurchase;
  final bool isLoading;

  const CompanySubscriptionComponent({
    super.key,
    required this.uiModel,
    this.onSubscribe,
    this.onRestorePurchase,
    this.isLoading = false,
  });

  @override
  State<CompanySubscriptionComponent> createState() => _CompanySubscriptionComponentState();
}

class _CompanySubscriptionComponentState extends State<CompanySubscriptionComponent> {
  SubscriptionOfferModel? _selectedOffer;
  bool _isLoading = false;

  @override
  void didUpdateWidget(covariant CompanySubscriptionComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != oldWidget.isLoading) {
      setState(() {
        _isLoading = oldWidget.isLoading;
      });
    }
    log('here we got did update widget with loading $_isLoading', name: 'AccountSubscriptionComponent');
  }

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final regularTextTheme = context.uiKitTheme?.regularTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UiKitCardWrapper(
            color: colorScheme?.surface1,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                context.userAvatar(
                  size: UserAvatarSize.x48x48,
                  type: UserTileType.ordinary,
                  userName: widget.uiModel.companyName,
                  imageUrl: widget.uiModel.companyLogoLink,
                ),
                SpacingFoundation.horizontalSpace12,
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.uiModel.companyName,
                        style: boldTextTheme?.subHeadline,
                      ),
                      SpacingFoundation.verticalSpace2,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ImageWidget(
                            link: widget.uiModel.nicheIconPath,
                            height: 14.h,
                            width: 14.h,
                            fit: BoxFit.cover,
                            color: ColorsFoundation.darkNeutral500,
                          ),
                          SpacingFoundation.horizontalSpace2,
                          Text(
                            widget.uiModel.nicheTitle,
                            style: boldTextTheme?.caption2Bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingAll(EdgeInsetsFoundation.all16),
          ),
          SpacingFoundation.verticalSpace16,
          UiKitCardWrapper(
            gradient: GradientFoundation.companySubscriptionGradient,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InfluencerAccountMark(),
                SpacingFoundation.verticalSpace8,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: S.current.BuildYOurBusiness,
                        style: regularTextTheme?.body,
                      ),
                      TextSpan(
                        text: '\nshuffle',
                        style: boldTextTheme?.subHeadline.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ).paddingAll(EdgeInsetsFoundation.all16),
          ),
          SpacingFoundation.verticalSpace8,
          UiKitCardWrapper(
            color: colorScheme?.surface1,
            child: Column(
              children: [
                if (widget.uiModel.offersTitle != null)
                  Text(
                    widget.uiModel.offersTitle!,
                    style: regularTextTheme?.body,
                  ).paddingOnly(bottom: EdgeInsetsFoundation.vertical16),
                ...widget.uiModel.offers.map(
                  (e) {
                    double padding = 0;
                    if (e != widget.uiModel.offers.last) padding = EdgeInsetsFoundation.vertical16;

                    return SubscriptionOfferWidget(
                      selected: _selectedOffer == e,
                      onTap: () => setState(() => _selectedOffer = e),
                      model: e,
                      bottomInset: padding,
                    );
                  },
                ),
              ],
            ).paddingAll(EdgeInsetsFoundation.all16),
          ),
          SpacingFoundation.verticalSpace16,
          SpacingFoundation.verticalSpace16,
          SpacingFoundation.verticalSpace16,
          SpacingFoundation.verticalSpace16,
          context.gradientButton(
            data: BaseUiKitButtonData(
              loading: _isLoading,
              fit: ButtonFit.fitWidth,
              text: S.current
                  .UpgradeForNmoney(
                    _selectedOffer == null ? '' : S.current.ForFormattedPrice(_selectedOffer!.formattedPriceNoPeriod),
                  )
                  .toUpperCase(),
              onPressed: _selectedOffer == null ? null : () => widget.onSubscribe?.call(_selectedOffer!),
            ),
          ),
          SpacingFoundation.verticalSpace16,
          TextButton(
            onPressed: widget.onRestorePurchase,
            child: Text(
              S.current.RestorePurchase,
            ),
          ),
          SpacingFoundation.verticalSpace24,
        ],
      ).paddingAll(EdgeInsetsFoundation.all16),
    );
  }
}
