import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UniversalFormForNotOfferRem extends StatelessWidget {
  final String? nameForEmptyList;
  final String? title;
  final String? whatCreate;
  final List<dynamic>? itemList;
  final ValueChanged<int?>? onEditItem;
  final ValueChanged<int?>? onRemoveItem;
  final VoidCallback? onCreateItem;
  final GlobalKey<SliverAnimatedListState> animatedListKey;

  const UniversalFormForNotOfferRem({
    super.key,
    this.nameForEmptyList,
    this.itemList,
    this.onEditItem,
    this.onRemoveItem,
    this.onCreateItem,
    this.title,
    this.whatCreate,
    required this.animatedListKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return BlurredAppBarPage(
      animatedListKey: animatedListKey,
      childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
      customTitle: AutoSizeText(
        title ?? S.of(context).NothingFound,
        style: theme?.boldTextTheme.title1,
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
      autoImplyLeading: true,
      centerTitle: true,
      appBarTrailing: context.outlinedButton(
        padding: EdgeInsets.all(EdgeInsetsFoundation.all6),
        data: BaseUiKitButtonData(
          onPressed: onCreateItem,
          iconInfo: BaseUiKitButtonIconData(
            iconData: ShuffleUiKitIcons.plus,
          ),
        ),
      ),
      children: [
        SpacingFoundation.verticalSpace16,
        if (itemList == null || itemList!.isEmpty)
          UiKitCardWrapper(
            borderRadius: BorderRadiusFoundation.all24r,
            child: Row(
              children: [
                Flexible(
                  flex: 3,
                  child: Text(
                    S.of(context).CreateNewXForYourY(
                          whatCreate ?? S.of(context).Offer.toLowerCase(),
                          nameForEmptyList ?? S.of(context).Place.toLowerCase(),
                        ),
                    style: theme?.boldTextTheme.body,
                  ),
                ),
                Flexible(
                  child: ImageWidget(
                    height: 60.h,
                    fit: BoxFit.fitHeight,
                    link: GraphicsFoundation.instance.svg.indexFingerHands.path,
                  ),
                )
              ],
            ).paddingAll(EdgeInsetsFoundation.all16),
          )
        else
          ...itemList!.map((item) {
            double padding = SpacingFoundation.verticalSpacing16;
            if (item == itemList!.last) padding = 0;

            return UniversalNotOfferRemItemWidget(
              universalNotOfferRemUiModel: item,
              onDismissed: () => onRemoveItem?.call(item?.id),
              onTap: () => onEditItem?.call(item?.id),
            ).paddingOnly(bottom: padding);
          }),
      ],
    );
  }
}
