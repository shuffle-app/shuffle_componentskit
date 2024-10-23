import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/activation_offers_component.dart/offer_title_widget.dart';
import 'package:shuffle_components_kit/presentation/components/activation_offers_component.dart/user_in_offer_widget.dart';
import 'package:shuffle_components_kit/presentation/components/notification_offer_reminder_components/universal_not_offer_rem_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/notification_offer_reminder_components/users_of_offer.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class OfferInfo extends StatelessWidget {
  final UsersOfOffer? offerUser;
  final UniversalNotOfferRemUiModel? offerUiModel;
  final String? contentImageUrl;
  final String? contentTitle;
  final ValueChanged<String?>? onConfirmTap;
  final Function(int? userId, int? offerId)? onCancelTap;

  const OfferInfo({
    super.key,
    this.offerUser,
    this.offerUiModel,
    this.contentImageUrl,
    this.contentTitle,
    this.onCancelTap,
    this.onConfirmTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        customTitle: Expanded(
          child: AutoSizeText(
            S.of(context).OfferInfo,
            style: theme?.boldTextTheme.title1,
            textAlign: TextAlign.center,
            wrapWords: false,
            maxLines: 1,
          ),
        ),
        expandTitle: true,
        centerTitle: true,
        autoImplyLeading: true,
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        children: [
          SpacingFoundation.verticalSpace16,
          UserInOfferWidget(offerUser: offerUser),
          Row(
            children: [
              context.userAvatar(
                size: UserAvatarSize.x40x40,
                type: UserTileType.ordinary,
                userName: '',
                imageUrl: contentImageUrl,
              ),
              SpacingFoundation.horizontalSpace16,
              Expanded(
                child: Text(
                  contentTitle ?? S.of(context).NothingFound,
                  style: theme?.boldTextTheme.body,
                ),
              ),
            ],
          ).paddingOnly(
            top: SpacingFoundation.verticalSpacing20,
            bottom: SpacingFoundation.verticalSpacing2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                formatDateWithCustomPattern(
                  'dd.MM.yyyy',
                  (offerUiModel?.selectedDates?.last ?? DateTime.now()).toLocal(),
                ),
                style: theme?.boldTextTheme.caption3Medium.copyWith(color: ColorsFoundation.mutedText),
              ),
            ],
          ),
          SpacingFoundation.verticalSpace16,
          OfferTitleWidget(offerUiModel: offerUiModel),
          SpacingFoundation.verticalSpace24,
          if (!(offerUser?.isConfirm ?? false)) ...[
            context.gradientButton(
              data: BaseUiKitButtonData(
                text: S.of(context).Confirm.toUpperCase(),
                onPressed: () => onConfirmTap?.call(offerUser?.ticketNumber),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.outlinedButton(
              data: BaseUiKitButtonData(
                text: S.of(context).Cancel.toUpperCase(),
                onPressed: () => onCancelTap?.call(offerUser?.user?.id, offerUiModel?.id),
              ),
            ),
          ] else
            Center(
              child: Text(
                S.of(context).Confirmed.toUpperCase(),
                style: theme?.boldTextTheme.body,
              ),
            ),
        ],
      ),
    );
  }
}
