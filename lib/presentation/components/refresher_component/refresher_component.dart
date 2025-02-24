import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/refresher_component/ui_model/refresher_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/refresher_component/widgets/refresher_item.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class RefresherComponent extends StatefulWidget {
  final List<RefresherUiModel?>? itemList;
  final GlobalKey<SliverAnimatedListState> listKey;
  final VoidCallback? onCreateRefresher;
  final ValueChanged<int?>? onEditRefresher;
  final ValueChanged<int?>? onRemoveRefresher;

  const RefresherComponent({
    super.key,
    required this.listKey,
    this.onCreateRefresher,
    this.itemList,
    this.onEditRefresher,
    this.onRemoveRefresher,
  });

  @override
  State<RefresherComponent> createState() => _RefresherComponentState();
}

class _RefresherComponentState extends State<RefresherComponent> {
  int? editingItemId;

  void _onLongPress(int? itemId) {
    if (editingItemId == itemId) {
      editingItemId = null;
    } else {
      editingItemId = itemId;
    }
    setState(() {});
  }

  void _onTapOutside() {
    editingItemId = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return GestureDetector(
      onTap: () {
        _onTapOutside();
      },
      child: BlurredAppBarPage(
        autoImplyLeading: true,
        title: S.of(context).Refresher,
        animatedListKey: widget.listKey,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        appBarTrailing: context.outlinedButton(
          padding: EdgeInsets.all(EdgeInsetsFoundation.all6),
          data: BaseUiKitButtonData(
            onPressed: widget.onCreateRefresher,
            iconInfo: BaseUiKitButtonIconData(iconData: ShuffleUiKitIcons.plus),
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
                      S.of(context).SetUpNewRefresher,
                      style: theme?.boldTextTheme.body,
                    ),
                  ),
                  Flexible(
                    child: ImageWidget(
                      height: 60.h,
                      fit: BoxFit.fitHeight,
                      rasterAsset: GraphicsFoundation.instance.png.victoryHands,
                    ),
                  )
                ],
              ).paddingAll(EdgeInsetsFoundation.all16),
            ).paddingOnly(top: SpacingFoundation.verticalSpacing16);
          } else {
            if (index < widget.itemList!.length) {
              final item = widget.itemList![index];
              final isItemEditing = editingItemId == item?.id;

              return TapRegion(
                onTapOutside: (_) {
                  if (isItemEditing) {
                    _onTapOutside();
                  }
                },
                child: RefresherItem(
                  item: item,
                  isEditingMode: isItemEditing,
                  onDismissed: () => widget.onRemoveRefresher?.call(item?.id),
                  onEdit: () {
                    widget.onEditRefresher?.call(item?.id);
                    editingItemId = null;
                  },
                  onLongPress: () => _onLongPress(item?.id),
                ).paddingOnly(
                  top: index == 0 ? SpacingFoundation.verticalSpacing16 : 0.0,
                  bottom: SpacingFoundation.verticalSpacing16,
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }
        },
      ),
    );
  }
}
