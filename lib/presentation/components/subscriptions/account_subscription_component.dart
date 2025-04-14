import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/common/subscription_offer_widget.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AccountSubscriptionComponent extends StatelessWidget {
  final UiSubscriptionModel uiModel;
  final ValueChanged<SubscriptionOfferModel>? onOfferSelected;
  final ComponentModel configModel;
  final String title;
  final List<SubscriptionDescriptionItem> subscriptionFeatures;

  const AccountSubscriptionComponent({
    super.key,
    required this.uiModel,
    required this.configModel,
    required this.title,
    required this.subscriptionFeatures,
    this.onOfferSelected,
  });

  @override
  Widget build(BuildContext context) {
    final verticalMargin = (configModel.positionModel?.verticalMargin ?? 0).toDouble();
    final horizontalMargin = (configModel.positionModel?.horizontalMargin ?? 0).toDouble();
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final regularTextTheme = theme?.regularTextTheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              child: AutoSizeText(
            title,
            style: boldTextTheme?.title1,
          )),
          SpacingFoundation.verticalSpace16,
          context.userTile(
            data: BaseUiKitUserTileData(
              username: uiModel.nickname,
              avatarUrl: uiModel.userAvatarUrl,
              name: uiModel.userName,
              type: uiModel.userType,
              showBadge: true,
            ),
          ),
          SpacingFoundation.verticalSpace16,
          UiKitCardWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: uiModel.offers.map(
                (e) {
                  double padding = 0;
                  if (e != uiModel.offers.last) padding = EdgeInsetsFoundation.vertical16;

                  return SubscriptionOfferWidget(
                    autoSizeGroup: _autoSizeGroup,
                    selected: uiModel.selectedInitialOffer == e,
                    onTap: () => onOfferSelected?.call(e),
                    model: e,
                    bottomInset: padding,
                  );
                },
              ).toList(),
            ).paddingAll(EdgeInsetsFoundation.all16),
          ),
          if (uiModel.selectedInitialOffer?.trialDaysAvailable != null &&
              uiModel.selectedInitialOffer!.trialDaysAvailable! > 0 &&
              uiModel.userType == UserTileType.pro) ...[
            SpacingFoundation.verticalSpace16,
            UiKitCardWrapper(
              gradient: theme?.themeMode == ThemeMode.light
                  ? GradientFoundation.lightShunyGreyGradient
                  : GradientFoundation.shunyGreyGradient,
              padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
              child: Stack(
                children: [
                  Text(
                    '${S.of(context).YouGetAccessToTrial}  ${uiModel.selectedInitialOffer!.trialDaysAvailable} ${S.of(context).Days(uiModel.selectedInitialOffer!.trialDaysAvailable!)}',
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
                            text: '${uiModel.selectedInitialOffer!.trialDaysAvailable!}',
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
                                '${S.of(context).YouGetAccessToTrial}  ${uiModel.selectedInitialOffer!.trialDaysAvailable!} ${S.of(context).Days(uiModel.selectedInitialOffer!.trialDaysAvailable!)} ',
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
            subscriptionFeatures.length,
            (index) {
              final indexIsEven = index.isEven;

              double bottimPaddign = SpacingFoundation.verticalSpacing16;
              if (index == subscriptionFeatures.length - 1) bottimPaddign = SpacingFoundation.zero;

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
                                    subscriptionFeatures[index].description,
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
                                    link: subscriptionFeatures[index].imagePath,
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
                                    link: subscriptionFeatures[index].imagePath,
                                  ).paddingOnly(
                                    right: SpacingFoundation.horizontalSpacing2,
                                    left: SpacingFoundation.horizontalSpacing8,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    subscriptionFeatures[index].description,
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
          if (uiModel.additionalInfo != null) ...[SpacingFoundation.verticalSpace24, uiModel.additionalInfo!],
        ],
      ).paddingSymmetric(
        vertical: verticalMargin,
        horizontal: horizontalMargin,
      ),
    );
  }
}

final AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
