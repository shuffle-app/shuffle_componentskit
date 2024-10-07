import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ActivationOffersComponent extends StatelessWidget {
  final UniversalNotOfferRemUiModel? offerUiModel;
  final ValueChanged<UsersOfOffer>? onDetailsTap;

  const ActivationOffersComponent({
    super.key,
    this.offerUiModel,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        title: S.of(context).Offer,
        centerTitle: true,
        autoImplyLeading: true,
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        children: [
          SpacingFoundation.verticalSpace16,
          OfferTitleWidget(offerUiModel: offerUiModel),
          SpacingFoundation.verticalSpace16,
          context.gradientButton(
            data: BaseUiKitButtonData(
              text: S.of(context).CodeScanner.toUpperCase(),
              onPressed: () {},
            ),
          ),
          SpacingFoundation.verticalSpace16,
          if (offerUiModel?.userOfOffer != null && offerUiModel!.userOfOffer!.isNotEmpty)
            ...offerUiModel!.userOfOffer!.map((user) => UserInOfferWidget(
                  offerUser: user,
                  onDetailsTap: onDetailsTap,
                ).paddingOnly(bottom: SpacingFoundation.verticalSpacing20))
          else
            Text(
              S.of(context).ThereNoUsersWhoHaveBoughtOfferYet,
              style: boldTextTheme?.caption1Medium,
            ),
        ],
      ),
    );
  }
}
