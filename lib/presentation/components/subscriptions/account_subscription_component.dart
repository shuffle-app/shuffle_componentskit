import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/common/subscription_offer_widget.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AccountSubscriptionComponent extends StatefulWidget {
  final UiSubscriptionModel uiModel;
  final ValueChanged<SubscriptionOfferModel>? onSubscribe;
  final ComponentModel configModel;
  final String title;
  final bool isLoading;
  final VoidCallback? onRestorePurchase;
  final List<SubscriptionDescriptionItem> subscriptionFeatures;

  const AccountSubscriptionComponent({
    super.key,
    required this.uiModel,
    required this.configModel,
    required this.title,
    required this.subscriptionFeatures,
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
  final _autoSizeGroup = AutoSizeGroup();

  String _buttonText() {
    if (widget.uiModel.userType == UserTileType.premium) {
      return S.of(context).GoPremium.toUpperCase();
    } else if (widget.uiModel.userType == UserTileType.pro) {
      return S.of(context).GoProFree.toUpperCase();
    } else {
      return S
          .of(context)
          .UpgradeForNmoney(
            _selectedOffer == null
                ? ''
                : (_selectedOffer!.trialDaysAvailable != null && _selectedOffer!.trialDaysAvailable != 0)
                    ? S.of(context).ForFormattedPrice(S.of(context).Free)
                    : S.of(context).ForFormattedPrice(_selectedOffer!.formattedPriceNoPeriod),
          )
          .toUpperCase();
    }
  }

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
      physics: const BouncingScrollPhysics(),
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
                    autoSizeGroup: _autoSizeGroup,
                    selected: _selectedOffer == e,
                    onTap: () => setState(() => _selectedOffer = e),
                    model: e,
                    bottomInset: padding,
                  );
                },
              ).toList(),
            ).paddingAll(EdgeInsetsFoundation.all16),
          ),
          if (_selectedOffer?.trialDaysAvailable != null &&
              _selectedOffer!.trialDaysAvailable! > 0 &&
              widget.uiModel.userType == UserTileType.pro) ...[
            SpacingFoundation.verticalSpace16,
            UiKitCardWrapper(
              gradient: theme?.themeMode == ThemeMode.light
                  ? GradientFoundation.lightShunyGreyGradient
                  : GradientFoundation.shunyGreyGradient,
              padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
              child: Stack(
                children: [
                  Text(
                    '${S.of(context).YouGetAccessToTrial}  ${_selectedOffer!.trialDaysAvailable} ${S.of(context).Days(_selectedOffer!.trialDaysAvailable!)}',
                    style: regularTextTheme?.body,
                  ),
                  GradientableWidget(
                    gradient: GradientFoundation.defaultLinearGradient,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${S.of(context).YouGetAccessToTrial} ',
                            style: boldTextTheme?.body.copyWith(color: Colors.transparent),
                          ),
                          TextSpan(
                            text: '${_selectedOffer!.trialDaysAvailable!}',
                            style: regularTextTheme?.body.copyWith(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  GradientableWidget(
                    gradient: GradientFoundation.defaultLinearGradient,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${S.of(context).YouGetAccessToTrial}  ${_selectedOffer!.trialDaysAvailable!} ${S.of(context).Days(_selectedOffer!.trialDaysAvailable!)} ',
                            style: regularTextTheme?.body.copyWith(color: Colors.transparent),
                          ),
                          TextSpan(
                            text: S.of(context).TrialPeriod.toLowerCase(),
                            style: boldTextTheme?.body.copyWith(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SpacingFoundation.verticalSpace16,
          ...List.generate(
            widget.subscriptionFeatures.length,
            (index) {
              final indexIsEven = index.isEven;

              double bottimPaddign = SpacingFoundation.verticalSpacing16;
              if (index == widget.subscriptionFeatures.length - 1) bottimPaddign = SpacingFoundation.zero;

              return UiKitCardWrapper(
                      gradient: theme?.themeMode == ThemeMode.light
                          ? GradientFoundation.lightShunyGreyGradient
                          : GradientFoundation.shunyGreyGradient,
                      child: indexIsEven
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    widget.subscriptionFeatures[index].description,
                                    style: regularTextTheme?.body,
                                  ).paddingOnly(
                                    left: SpacingFoundation.horizontalSpacing16,
                                    top: SpacingFoundation.horizontalSpacing16,
                                    bottom: SpacingFoundation.horizontalSpacing16,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ImageWidget(
                                    link: widget.subscriptionFeatures[index].imagePath,
                                  ).paddingOnly(
                                    left: SpacingFoundation.horizontalSpacing2,
                                    right: SpacingFoundation.horizontalSpacing8,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: ImageWidget(
                                    link: widget.subscriptionFeatures[index].imagePath,
                                  ).paddingOnly(
                                    right: SpacingFoundation.horizontalSpacing2,
                                    left: SpacingFoundation.horizontalSpacing8,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    widget.subscriptionFeatures[index].description,
                                    style: regularTextTheme?.body,
                                  ).paddingOnly(
                                    right: SpacingFoundation.horizontalSpacing16,
                                    top: SpacingFoundation.horizontalSpacing16,
                                    bottom: SpacingFoundation.horizontalSpacing16,
                                  ),
                                )
                              ],
                            ))
                  .paddingOnly(bottom: bottimPaddign);
            },
          ),
          if (widget.uiModel.additionalInfo != null) ...[
            SpacingFoundation.verticalSpace24,
            widget.uiModel.additionalInfo!
          ],
          SpacingFoundation.verticalSpace24,
          context.gradientButton(
            data: BaseUiKitButtonData(
              loading: _isLoading,
              autoSizeGroup: AutoSizeGroup(),
              fit: ButtonFit.fitWidth,
              text: _buttonText(),
              onPressed: _selectedOffer == null ? null : () => widget.onSubscribe?.call(_selectedOffer!),
            ),
          ),
          TextButton(
            onPressed: widget.onRestorePurchase,
            child: Text(
              S.current.RestorePurchase,
              style: boldTextTheme?.caption1Bold,
            ),
          ),
          if (_selectedOffer?.trialDaysAvailable != null && _selectedOffer!.trialDaysAvailable != 0) ...[
            Align(
                alignment: Alignment.centerLeft,
                child: Text('Cancel any time in ${Platform.isIOS ? 'AppStore' : 'Play Store'}',
                    style: regularTextTheme?.caption3))
          ],
          Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                  text: TextSpan(
                children: [
                  TextSpan(
                      text: S.of(context).TermsOfService,
                      style: regularTextTheme?.caption3.copyWith(color: ColorsFoundation.darkNeutral600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launchUrlString(widget.uiModel.termsOfServiceUrl)),
                  TextSpan(
                    text: S.of(context).AndWithWhitespaces.toLowerCase(),
                    style: regularTextTheme?.caption3,
                  ),
                  TextSpan(
                      text: S.of(context).PrivacyPolicy,
                      style: regularTextTheme?.caption3.copyWith(color: ColorsFoundation.darkNeutral600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launchUrlString(widget.uiModel.privacyPolicyUrl)),
                ],
              ))),
          SpacingFoundation.verticalSpace24,
        ],
      ).paddingSymmetric(
        vertical: verticalMargin,
        horizontal: horizontalMargin,
      ),
    );
  }
}
