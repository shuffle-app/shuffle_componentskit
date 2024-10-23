import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ActivationOffersComponent extends StatelessWidget {
  final UniversalNotOfferRemUiModel? offerUiModel;
  final ValueChanged<UsersOfOffer>? onDetailsTap;
  final PagingController<int, UsersOfOffer> pagingController;
  final VoidCallback? onScannerTap;

  const ActivationOffersComponent({
    super.key,
    required this.pagingController,
    this.offerUiModel,
    this.onDetailsTap,
    this.onScannerTap,
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
              onPressed: onScannerTap,
            ),
          ),
          SpacingFoundation.verticalSpace16,
          SizedBox(
            height: 0.65.sh,
            child: PagedListView<int, UsersOfOffer>(
              pagingController: pagingController,
              padding: EdgeInsets.all(EdgeInsetsFoundation.zero),
              builderDelegate: PagedChildBuilderDelegate(
                noItemsFoundIndicatorBuilder: (context) => Text(
                  S.of(context).ThereNoUsersWhoHaveBoughtOfferYet,
                  style: boldTextTheme?.caption1Medium,
                ),
                itemBuilder: (context, item, index) {
                  return UserInOfferWidget(
                    offerUser: item,
                    onDetailsTap: onDetailsTap,
                  ).paddingOnly(bottom: SpacingFoundation.verticalSpacing20);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}