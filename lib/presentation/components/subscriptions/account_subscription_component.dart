import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/common/subscription_offer_widget.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AccountSubscriptionComponent extends StatefulWidget {
  final UiSubscriptionModel uiModel;
  final ValueChanged<SubscriptionOfferModel>? onSubscribe;
  final ComponentModel configModel;
  final String title;
  final bool isLoading;
  final VoidCallback? onRestorePurchase;

  const AccountSubscriptionComponent({
    super.key,
    required this.uiModel,
    required this.configModel,
    required this.title,
    this.onSubscribe,
    this.isLoading = false,
    this.onRestorePurchase,
  });

  @override
  State<AccountSubscriptionComponent> createState() => _AccountSubscriptionComponentState();
}

class _AccountSubscriptionComponentState extends State<AccountSubscriptionComponent> {
  SubscriptionOfferModel? _selectedOffer;
  bool _isLoading = false;

  @override
  void initState() {
    _selectedOffer = widget.uiModel.selectedInitialOffer;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AccountSubscriptionComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      setState(() {
        _isLoading = widget.isLoading;
      });
    }
    if (widget.uiModel.selectedInitialOffer != _selectedOffer) {
      setState(() {
        _selectedOffer = widget.uiModel.selectedInitialOffer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final verticalMargin = (widget.configModel.positionModel?.verticalMargin ?? 0).toDouble();
    final horizontalMargin = (widget.configModel.positionModel?.horizontalMargin ?? 0).toDouble();
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final regularTextTheme = theme?.regularTextTheme;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: boldTextTheme?.title1,
          ),
          SpacingFoundation.verticalSpace16,
          context.userTile(
            data: BaseUiKitUserTileData(
              username: widget.uiModel.nickname,
              avatarUrl: widget.uiModel.userAvatarUrl,
              name: widget.uiModel.userName,
              type: widget.uiModel.userType,
              showBadge: true,
            ),
          ),
          SpacingFoundation.verticalSpace16,
          UiKitCardWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: widget.uiModel.offers.map(
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
              ).toList(),
            ).paddingAll(EdgeInsetsFoundation.all16),
          ),
          if (_selectedOffer?.trialDaysAvailable != null && _selectedOffer!.trialDaysAvailable! > 0) ...[
            UiKitCardWrapper(
                gradient: theme?.themeMode == ThemeMode.light
                    ? GradientFoundation.lightShunyGreyGradient
                    : GradientFoundation.shunyGreyGradient,
                padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
                child: Stack(
                  children: [
                    Text(S.of(context).YouGetAccessToTrial, style: regularTextTheme?.body),
                    GradientableWidget(
                        gradient: GradientFoundation.attentionCard,
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: S.of(context).YouGetAccessToTrial,
                              style: boldTextTheme?.body.copyWith(color: Colors.transparent),
                            ),
                            TextSpan(
                              text:
                                  ' ${_selectedOffer!.trialDaysAvailable!} ${S.of(context).Days(_selectedOffer!.trialDaysAvailable!)} ${S.of(context).TrialPeriod.toLowerCase()}',
                              style: regularTextTheme?.body.copyWith(color: Colors.white),
                            )
                          ]),
                        ))
                  ],
                )),
            SpacingFoundation.verticalSpace16,
          ],
          SpacingFoundation.verticalSpace16,
          UiKitCardWrapper(
            gradient: theme?.themeMode == ThemeMode.light
                ? GradientFoundation.lightShunyGreyGradient
                : GradientFoundation.shunyGreyGradient,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.uiModel.subscriptionFeatures.map(
                (e) {
                  double padding = 0;
                  if (e != widget.uiModel.subscriptionFeatures.last) {
                    padding = EdgeInsetsFoundation.vertical16;
                  }

                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientableWidget(
                        gradient: GradientFoundation.starLinearGradient,
                        child: ImageWidget(
                          iconData: ShuffleUiKitIcons.gradientStar,
                          color: Colors.white,
                          width: 0.0625.sw,
                          height: 0.0625.sw,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SpacingFoundation.horizontalSpace8,
                      Expanded(
                        child: Text(
                          e,
                          style: regularTextTheme?.body,
                        ),
                      ),
                    ],
                  ).paddingOnly(bottom: padding);
                },
              ).toList(),
            ).paddingAll(EdgeInsetsFoundation.all16),
          ),
          if (widget.uiModel.additionalInfo != null) ...[
            SpacingFoundation.verticalSpace24,
            widget.uiModel.additionalInfo!
          ],
          SpacingFoundation.verticalSpace24,
          context.gradientButton(
            data: BaseUiKitButtonData(
              loading: _isLoading,
              fit: ButtonFit.fitWidth,
              text: S
                  .of(context)
                  .UpgradeForNmoney(
                    _selectedOffer == null
                        ? ''
                        : (_selectedOffer!.trialDaysAvailable != null && _selectedOffer!.trialDaysAvailable != 0)
                            ? S.of(context).ForFormattedPrice(S.of(context).Free)
                            : S.of(context).ForFormattedPrice(_selectedOffer!.formattedPriceNoPeriod),
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
      ).paddingSymmetric(
        vertical: verticalMargin,
        horizontal: horizontalMargin,
      ),
    );
  }
}
