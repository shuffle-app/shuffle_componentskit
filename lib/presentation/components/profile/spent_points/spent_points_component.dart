import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

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
            S.current.SpentMyPoints,
            style: context.uiKitTheme?.boldTextTheme.title1,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        customToolbarBaseHeight: 0.13.sh,
        childrenPadding:
            EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        children: [
          SpacingFoundation.verticalSpace16,
          Text(
            S.current.Balance,
            style: uiKitTheme?.regularTextTheme.caption1.copyWith(
                color: ColorsFoundation.mutedText,
                fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
          SpacingFoundation.verticalSpace2,
          Text('${balance ?? 0} ${S.current.Points}',
              style: uiKitTheme?.boldTextTheme.title2,
              textAlign: TextAlign.center),
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
