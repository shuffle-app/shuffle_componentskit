import 'package:flutter/cupertino.dart';
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
  final bool isPromotion;

  const UniversalFormForNotOfferRem({
    super.key,
    required this.animatedListKey,
    this.nameForEmptyList,
    this.itemList,
    this.onEditItem,
    this.onRemoveItem,
    this.onCreateItem,
    this.title,
    this.whatCreate,
    this.isPromotion = false,
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
      customTitle: Flexible(
          child: AutoSizeText(
        title ?? S.of(context).NothingFound,
        style: theme?.boldTextTheme.title1,
        textAlign: TextAlign.center,
        maxLines: 1,
      )),
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
            return isPromotion
                ? PromotionItemWidget().paddingOnly(
                    bottom: itemList?[index] != itemList?.last ? SpacingFoundation.verticalSpacing16 : 0,
                    top: itemList?[index] != itemList?.first ? 0 : SpacingFoundation.verticalSpacing16,
                  )
                : UniversalNotOfferRemItemWidget(
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

class PromotionItemWidget extends StatefulWidget {
  final UniversalNotOfferRemUiModel? universalNotOfferRemUiModel;

  const PromotionItemWidget({
    super.key,
    this.universalNotOfferRemUiModel,
  });

  @override
  State<PromotionItemWidget> createState() => _PromotionItemWidgetState();
}

class _PromotionItemWidgetState extends State<PromotionItemWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return UiKitCardWrapper(
      color: theme?.colorScheme.surface1,
      child: Row(
        children: [
          context
              .userAvatar(
                size: UserAvatarSize.x40x40,
                type: UserTileType.ordinary,
                userName: '',
                imageUrl: widget.universalNotOfferRemUiModel?.imagePath,
              )
              .paddingOnly(right: SpacingFoundation.horizontalSpacing8),
          SpacingFoundation.horizontalSpace4,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.universalNotOfferRemUiModel?.title ?? S.of(context).NothingFound,
                  style: theme?.boldTextTheme.caption1Bold,
                ),
                SpacingFoundation.verticalSpace2,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.universalNotOfferRemUiModel?.selectedDates.toString() ?? S.of(context).NothingFound,
                        style: theme?.boldTextTheme.caption1Medium.copyWith(color: ColorsFoundation.mutedText),
                      ),
                    ),
                    SpacingFoundation.horizontalSpace12,
                    ImageWidget(
                      height: 10.h,
                      fit: BoxFit.fill,
                      color: ColorsFoundation.mutedText,
                      link: widget.universalNotOfferRemUiModel?.isLaunched ?? true
                          ? GraphicsFoundation.instance.svg.playOutline.path
                          : GraphicsFoundation.instance.svg.stopOutline.path,
                    ),
                    SpacingFoundation.horizontalSpace2,
                    Text(
                      widget.universalNotOfferRemUiModel?.isLaunched ?? true
                          ? S.of(context).Launched
                          : S.of(context).Expired,
                      style: theme?.boldTextTheme.caption1Medium.copyWith(color: ColorsFoundation.mutedText),
                    ),
                  ],
                )
              ],
            ),
          ),
          SpacingFoundation.horizontalSpace24,
          ImageWidget(
            iconData: ShuffleUiKitIcons.chevrondown,
          ),
        ],
      ).paddingAll(EdgeInsetsFoundation.all12),
    );
  }
}
