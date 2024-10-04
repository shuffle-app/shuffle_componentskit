import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/activation_offers_component.dart/activation_offers_component.dart';
import 'package:shuffle_components_kit/presentation/components/notification_offer_reminder_components/universal_not_offer_rem_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../profile/uiprofile_model.dart';

class OfferInfo extends StatelessWidget {
  final UiProfileModel? user;
  final UniversalNotOfferRemUiModel? offerUiModel;
  final bool isConfirm;

  const OfferInfo({
    super.key,
    this.user,
    this.offerUiModel,
    this.isConfirm = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        customTitle: Expanded(
          child: AutoSizeText(
            'Инфо о предложении',
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
          UserInOfferWidget(user: user),
          Row(
            children: [
              context.userAvatar(
                size: UserAvatarSize.x40x40,
                type: UserTileType.ordinary,
                userName: '',
                //TODo
                imageUrl: '',
              ),
              SpacingFoundation.horizontalSpace16,
              Text(
                'At.mosphere',
                style: theme?.boldTextTheme.body,
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
                '25.07.2024',
                style: theme?.boldTextTheme.caption3Medium.copyWith(color: ColorsFoundation.mutedText),
              ),
            ],
          ),
          SpacingFoundation.verticalSpace16,
          OfferTitleWidget(offerUiModel: offerUiModel),
          SpacingFoundation.verticalSpace24,
          if (!isConfirm) ...[
            context.gradientButton(
              data: BaseUiKitButtonData(
                text: S.of(context).Confirm.toUpperCase(),
                //TODO
                onPressed: () {},
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.outlinedButton(
              data: BaseUiKitButtonData(
                text: S.of(context).Cancel.toUpperCase(),
                //TODO
                onPressed: () {},
              ),
            ),
          ] else
            Center(
              child: Text(
                'Confirmed'.toUpperCase(),
                style: theme?.boldTextTheme.body,
              ),
            ),
        ],
      ),
    );
  }
}
