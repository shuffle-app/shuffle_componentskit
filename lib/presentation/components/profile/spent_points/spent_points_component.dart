import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:intl/intl.dart';

import '../../components.dart';

class SpentPointsComponent extends StatelessWidget {
  const SpentPointsComponent({
    super.key,
    this.onHistoryTap,
    this.balance,
    this.discountsList,
    this.onDiscountTap,
  });

  final int? balance;
  final VoidCallback? onHistoryTap;
  final List<UiModelDiscounts>? discountsList;
  final ValueChanged<UiModelDiscounts>? onDiscountTap;

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
        appBarTrailing: context.iconButtonNoPadding(
          data: BaseUiKitButtonData(
            onPressed: onHistoryTap,
            iconInfo:
                BaseUiKitButtonIconData(iconData: ShuffleUiKitIcons.history),
          ),
        ),
        customTitle: Expanded(
          child: Text(
            S.current.Spend,
            style: context.uiKitTheme?.boldTextTheme.title1,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        // customToolbarBaseHeight: 0.13.sh,
        childrenPadding:
            EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
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
          ...List.generate(
            discountsList?.length ?? 0,
            (index) {
              return UiKitCardWrapper(
                child: Column(
                  children: [
                    UiKitExtendedInfluencerFeedbackCardWithoutBottom(
                      imageUrl:
                          discountsList?[index].contentShortUiModel.imageUrl,
                      title: discountsList?[index].contentShortUiModel.title,
                      tags: discountsList?[index].contentShortUiModel.tags,
                    ),
                    SpacingFoundation.verticalSpace12,
                    context.gradientButton(
                      data: BaseUiKitButtonData(
                        fit: ButtonFit.fitWidth,
                        text: discountsList?[index].buttonTitle,
                        onPressed: () async {
                          onDiscountTap?.call(discountsList![index]);
                        },
                      ),
                    )
                  ],
                ).paddingAll(EdgeInsetsFoundation.all16),
              ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical8);
            },
          )
        ],
      ),
    );
  }
}
