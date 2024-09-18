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
      childrenPadding: EdgeInsets.only(
        left: SpacingFoundation.horizontalSpacing16,
        right: SpacingFoundation.horizontalSpacing16,
      ),
      customTitle: AutoSizeText(
        title ?? S.of(context).NothingFound,
        style: theme?.boldTextTheme.title1,
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
      autoImplyLeading: true,
      appBarTrailing: context.outlinedButton(
        padding: EdgeInsets.all(EdgeInsetsFoundation.all6),
        data: BaseUiKitButtonData(
          onPressed: onCreateItem,
          iconInfo: BaseUiKitButtonIconData(
            iconData: ShuffleUiKitIcons.plus,
          ),
        ),
      ),
      childrenCount: itemList == null || itemList!.isEmpty ? 1 : itemList!.length,
      childrenBuilder: (context, index) {
        if (itemList == null || itemList!.isEmpty) {
          return UiKitCardWrapper(
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
          ).paddingOnly(top: SpacingFoundation.verticalSpacing16);
        } else {
          if (index < itemList!.length) {
            return UniversalNotOfferRemItemWidget(
              universalNotOfferRemUiModel: itemList?[index],
              onDismissed: () => onRemoveItem?.call(itemList?[index]?.id),
              onTap: () => onEditItem?.call(itemList?[index]?.id),
            ).paddingOnly(
              bottom: itemList?[index] != itemList?.last ? SpacingFoundation.verticalSpacing16 : 0,
              top: itemList?[index] != itemList?.first ? 0 : SpacingFoundation.verticalSpacing16,
            );
          }
        }
        return null;
      },
    );
  }
}
