import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UniversalFormForNotOfferRem extends StatefulWidget {
  final String? nameForEmptyList;
  final String? title;
  final String? whatCreate;
  final String? customWhatCreate;
  final List<UniversalNotOfferRemUiModel>? itemList;
  final ValueChanged<int>? onEditItem;
  final ValueChanged<int>? onRemoveItem;
  final VoidCallback? onCreateItem;
  final ValueChanged<int>? onActivateTap;
  final ValueChanged<int>? onPayTap;
  final GlobalKey<SliverAnimatedListState> animatedListKey;
  final bool showPopOver;

  const UniversalFormForNotOfferRem({
    super.key,
    this.nameForEmptyList,
    this.itemList,
    this.onEditItem,
    this.onRemoveItem,
    this.onCreateItem,
    this.onPayTap,
    this.onActivateTap,
    this.title,
    this.whatCreate,
    this.customWhatCreate,
    required this.animatedListKey,
    this.showPopOver = true,
  });

  @override
  State<UniversalFormForNotOfferRem> createState() => _UniversalFormForNotOfferRemState();
}

class _UniversalFormForNotOfferRemState extends State<UniversalFormForNotOfferRem> {
  int? editingItemId;

  void _onLongPress(int? itemId) {
    setState(() {
      if (editingItemId == itemId) {
        editingItemId = null;
      } else {
        editingItemId = itemId;
      }
    });
  }

  void _onTapOutside() {
    setState(() {
      editingItemId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return GestureDetector(
      onTap: () {
        _onTapOutside();
      },
      child: BlurredAppBarPage(
        animatedListKey: widget.animatedListKey,
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        customTitle: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: AutoSizeText(
                  widget.title ?? S.of(context).NothingFound,
                  style: theme?.boldTextTheme.title1,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
              if (widget.showPopOver) ...[
                SpacingFoundation.horizontalSpace8,
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () => showUiKitPopover(
                      context,
                      customMinHeight: 30.h,
                      showButton: false,
                      title: Text(
                        S.of(context).LongTapCardEdit,
                        style: theme?.regularTextTheme.body.copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    child: ImageWidget(
                      iconData: ShuffleUiKitIcons.info,
                      width: 16.w,
                      color: theme?.colorScheme.darkNeutral900,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        autoImplyLeading: true,
        appBarTrailing: context.outlinedButton(
          padding: EdgeInsets.all(EdgeInsetsFoundation.all6),
          data: BaseUiKitButtonData(
            onPressed: widget.onCreateItem,
            iconInfo: BaseUiKitButtonIconData(
              iconData: ShuffleUiKitIcons.plus,
            ),
          ),
        ),
        childrenCount: widget.itemList == null || widget.itemList!.isEmpty ? 1 : widget.itemList!.length,
        childrenBuilder: (context, index) {
          if (widget.itemList == null || widget.itemList!.isEmpty) {
            return UiKitCardWrapper(
              borderRadius: BorderRadiusFoundation.all24r,
              child: Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: Text(
                      widget.customWhatCreate ??
                          S.of(context).CreateNewXForYourY(
                                widget.whatCreate ?? S.of(context).Offer.toLowerCase(),
                                widget.nameForEmptyList ?? S.of(context).Place.toLowerCase(),
                              ),
                      style: theme?.boldTextTheme.body,
                    ),
                  ),
                  Flexible(
                    child: ImageWidget(
                      height: 60.h,
                      fit: BoxFit.fitHeight,
                      link: GraphicsFoundation.instance.png.indexFingerHands.path,
                    ),
                  )
                ],
              ).paddingAll(EdgeInsetsFoundation.all16),
            ).paddingOnly(top: SpacingFoundation.verticalSpacing16);
          } else {
            if (index < widget.itemList!.length) {
              final offer = widget.itemList![index];
              final isItemEditing = editingItemId == offer.id;

              return GestureDetector(
                onTap: () {
                  _onTapOutside();
                },
                onLongPress: () {
                  _onLongPress(offer.id);
                },
                child: TapRegion(
                  onTapOutside: (_) {
                    if (isItemEditing) {
                      _onTapOutside();
                    }
                  },
                  child: UniversalNotOfferRemItemWidget(
                    model: offer,
                    onDismissed: () => widget.onRemoveItem?.call(offer.id),
                    onEdit: () {
                      widget.onEditItem?.call(offer.id);
                      editingItemId = null;
                    },
                    onLongPress: () => _onLongPress(offer.id),
                    onActivateTap: () => widget.onActivateTap?.call(offer.id),
                    onPayTap: () => widget.onPayTap?.call(offer.id),
                    isEditingMode: isItemEditing,
                  ).paddingOnly(
                    bottom: offer != widget.itemList?.last ? SpacingFoundation.verticalSpacing16 : 0,
                    top: offer != widget.itemList?.first ? 0 : SpacingFoundation.verticalSpacing16,
                  ),
                ),
              );
            }
          }
          return null;
        },
      ),
    );
  }
}
