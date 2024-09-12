import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/common/subscription_offer_widget.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  final _autoSizeGroup = AutoSizeGroup();

  @override
  void initState() {
    _selectedOffer = widget.uiModel.selectedInitialOffer;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CompanySubscriptionComponent oldWidget) {
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
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final regularTextTheme = theme?.regularTextTheme;
    final colorScheme = theme?.colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UiKitCardWrapper(
            borderRadius: BorderRadiusFoundation.all24r,
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
            borderRadius: BorderRadiusFoundation.all24r,
            gradient: GradientFoundation.companySubscriptionGradient,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageWidget(
                  height: 12.h,
                  width: 12.h,
                  fit: BoxFit.fill,
                  link: GraphicsFoundation.instance.svg.influencerAccountMark.path,
                ),
                SpacingFoundation.verticalSpace4,
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
          SpacingFoundation.verticalSpace16,
          UiKitCardWrapper(
            borderRadius: BorderRadiusFoundation.all24r,
            color: colorScheme?.surface1,
            child: Column(
              children: [
                if (_selectedOffer?.trialDaysAvailable != null && _selectedOffer!.trialDaysAvailable! > 0) ...[
                  Stack(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${S.of(context).YouGetAccessToTrial} ',
                              style: regularTextTheme?.body,
                            ),
                            TextSpan(
                              text: ' ${_selectedOffer!.trialDaysAvailable!}',
                              style: regularTextTheme?.body.copyWith(color: Colors.transparent),
                            ),
                            TextSpan(
                              text: ' ${S.of(context).Days(_selectedOffer!.trialDaysAvailable!)}',
                              style: boldTextTheme?.body.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      GradientableWidget(
                        gradient: GradientFoundation.attentionCard,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: S.of(context).YouGetAccessToTrial,
                                style: boldTextTheme?.body.copyWith(color: Colors.transparent),
                              ),
                              TextSpan(
                                text: ' ${_selectedOffer!.trialDaysAvailable!}',
                                style: regularTextTheme?.body.copyWith(color: Colors.white),
                              ),
                              TextSpan(
                                text: ' ${S.of(context).Days(_selectedOffer!.trialDaysAvailable!)}',
                                style: boldTextTheme?.body.copyWith(color: Colors.transparent),
                              ),
                              TextSpan(
                                text: ' ${S.of(context).TrialPeriod.toLowerCase()}',
                                style: boldTextTheme?.body.copyWith(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SpacingFoundation.verticalSpace16,
                ],
                if (widget.uiModel.offersTitle != null)
                  Text(
                    widget.uiModel.offersTitle!,
                    style: regularTextTheme?.body,
                  ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16),
                ...widget.uiModel.offers.map(
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
                ),
              ],
            ).paddingAll(EdgeInsetsFoundation.all16),
          ),
          SpacingFoundation.verticalSpace24,
          context.gradientButton(
            data: BaseUiKitButtonData(
              loading: _isLoading,
              autoSizeGroup: AutoSizeGroup(),
              fit: ButtonFit.fitWidth,
              text: _selectedOffer == null
                  ? S.current.UpgradeForFree.toUpperCase()
                  : (_selectedOffer!.trialDaysAvailable != null && _selectedOffer!.trialDaysAvailable != 0)
                      ? S.current.UpgradeForFree.toUpperCase()
                      : S.of(context).ForFormattedPrice(_selectedOffer!.formattedPriceNoPeriod).toUpperCase(),
              onPressed: _selectedOffer == null ? null : () => widget.onSubscribe?.call(_selectedOffer!),
            ),
          ),
          TextButton(
            onPressed: widget.onRestorePurchase,
            child: Text(
              S.current.RestorePurchase,
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
      ).paddingAll(EdgeInsetsFoundation.all16),
    );
  }
}
