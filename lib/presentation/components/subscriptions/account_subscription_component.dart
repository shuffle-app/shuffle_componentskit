import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/common/subscription_offer_widget.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AccountSubscriptionComponent extends StatefulWidget {
  final UiSubscriptionModel uiModel;
  final ValueChanged<SubscriptionOfferModel>? onSubscribe;
  final ComponentModel configModel;
  final String title;

  const AccountSubscriptionComponent({
    Key? key,
    required this.uiModel,
    required this.configModel,
    required this.title,
    this.onSubscribe,
  }) : super(key: key);

  @override
  State<AccountSubscriptionComponent> createState() => _AccountSubscriptionComponentState();
}

class _AccountSubscriptionComponentState extends State<AccountSubscriptionComponent> {
  SubscriptionOfferModel? _selectedOffer;

  @override
  Widget build(BuildContext context) {
    final verticalMargin = (widget.configModel.positionModel?.verticalMargin ?? 0).toDouble();
    final horizontalMargin = (widget.configModel.positionModel?.horizontalMargin ?? 0).toDouble();
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final regularTextTheme = context.uiKitTheme?.regularTextTheme;

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
          SpacingFoundation.verticalSpace16,
          UiKitCardWrapper(
            gradient: GradientFoundation.shunyGreyGradient,
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
                        gradient: GradientFoundation.buttonGradient,
                        child: ImageWidget(
                          svgAsset: GraphicsFoundation.instance.svg.gradientStar,
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
          SpacingFoundation.verticalSpace24,
          context.gradientButton(
            data: BaseUiKitButtonData(
              fit: ButtonFit.fitWidth,
              text: S
                  .of(context)
                  .UpgradeForNmoney(
                    _selectedOffer == null
                        ? ''
                        : S.of(context).ForFormattedPrice(_selectedOffer!.formattedPriceNoPeriod),
                  )
                  .toUpperCase(),
              onPressed: _selectedOffer == null ? null : () => widget.onSubscribe?.call(_selectedOffer!),
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
