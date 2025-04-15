import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../components.dart';

class SpentPointsComponent extends StatelessWidget {
  const SpentPointsComponent({
    super.key,
    this.onHistoryTap,
    this.balance,
    this.onDiscountTap,
    this.isContentCard = false,
    this.uiKitTag,
    this.contentImage,
    this.contentTitle,
    required this.pagingController,
  });

  final int? balance;
  final VoidCallback? onHistoryTap;
  final ValueChanged<UiModelDiscounts>? onDiscountTap;
  final bool isContentCard;
  final UiKitTag? uiKitTag;
  final String? contentImage;
  final String? contentTitle;
  final PagingController<int, UiModelDiscounts> pagingController;

  String stringWithSpace(int text) {
    NumberFormat formatter = NumberFormat('#,###');
    return formatter.format(text).replaceAll(',', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final uiKitTheme = context.uiKitTheme;
    return Scaffold(
      body: BlurredAppBarPage(
        autoImplyLeading: true,
        centerTitle: true,
        appBarTrailing: isContentCard
            ? null
            : context.iconButtonNoPadding(
                data: BaseUiKitButtonData(
                  onPressed: onHistoryTap,
                  iconInfo: BaseUiKitButtonIconData(iconData: ShuffleUiKitIcons.history),
                ),
              ),
        customTitle: isContentCard
            ? Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    context.userAvatar(
                      size: UserAvatarSize.x40x40,
                      type: UserTileType.ordinary,
                      userName: '',
                      imageUrl: contentImage,
                    ),
                    SpacingFoundation.horizontalSpace4,
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            contentTitle ?? S.of(context).NothingFound,
                            style: uiKitTheme?.regularTextTheme.caption1,
                            maxLines: 1,
                          ),
                          UiKitTagWidget(
                            title: uiKitTag?.title ?? S.of(context).NothingFound,
                            icon: uiKitTag?.icon,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Expanded(
                child: Text(
                  S.current.Spend,
                  style: context.uiKitTheme?.boldTextTheme.title1,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
        childrenPadding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        children: [
          SpacingFoundation.verticalSpace16,
          Row(
            children: [
              Text(
                S.of(context).Balance,
                style: uiKitTheme?.regularTextTheme.caption1.copyWith(
                  color: uiKitTheme.colorScheme.darkNeutral900,
                ),
              ),
              const Spacer(),
              Text(
                '${stringWithSpace(balance ?? 0)} ${S.of(context).PointsCount(2650)}',
                style: uiKitTheme?.boldTextTheme.subHeadline,
              ),
            ],
          ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          SpacingFoundation.verticalSpace24,
          SizedBox(
            height: 0.75.sh,
            child: PagingListener(
              controller: pagingController,
              builder: (context, state, fetchNextPage) => PagedListView<int, UiModelDiscounts>(
                  padding: EdgeInsets.all(EdgeInsetsFoundation.zero),
                  state: state,
                  fetchNextPage: fetchNextPage,
                  builderDelegate: PagedChildBuilderDelegate(
                    noItemsFoundIndicatorBuilder: (_) => Center(
                      child: Text(
                        S.of(context).NothingFound,
                        style: context.uiKitTheme?.boldTextTheme.body,
                      ),
                    ),
                    itemBuilder: (context, item, index) {
                      return UiKitCardWrapper(
                        child: Column(
                          children: [
                            OfferContentCard(
                              imageUrl: item.contentShortUiModel.imageUrl,
                              title: item.contentShortUiModel.title,
                              contentTitle: item.contentShortUiModel.contentTitle,
                              periodFrom: item.contentShortUiModel.periodFrom,
                              periodTo: item.contentShortUiModel.periodTo,
                            ),
                            SpacingFoundation.verticalSpace12,
                            context.gradientButton(
                              data: BaseUiKitButtonData(
                                fit: ButtonFit.fitWidth,
                                text: item.buttonTitle,
                                onPressed: () async {
                                  onDiscountTap?.call(item);
                                },
                              ),
                            )
                          ],
                        ).paddingAll(EdgeInsetsFoundation.all16),
                      ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical8);
                    },
                  )),
            ),
          )
        ],
      ),
    );
  }
}
