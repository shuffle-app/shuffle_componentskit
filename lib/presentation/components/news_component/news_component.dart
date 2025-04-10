import 'package:flutter/cupertino.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/influencer_models/influencer_feed_item.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class NewsComponent extends StatelessWidget {
  final List<PostFeedItem>? itemList;
  final ValueChanged<int>? onRemoveItem;
  final VoidCallback? onCreateItem;
  final GlobalKey<SliverAnimatedListState> animatedListKey;

  const NewsComponent({
    super.key,
    this.itemList,
    this.onRemoveItem,
    this.onCreateItem,
    required this.animatedListKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return BlurredAppBarPage(
      animatedListKey: animatedListKey,
      centerTitle: true,
      autoImplyLeading: true,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      title: S.of(context).News,
      childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
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
                    S.of(context).ThereIsNothingYetCreateYourFirstNews,
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
          if (index < itemList!.length) {
            final item = itemList![index];

            return Dismissible(
              key: ValueKey(item.id),
              direction: DismissDirection.endToStart,
              dismissThresholds: const {DismissDirection.endToStart: 0.6},
              background: UiKitBackgroundDismissible(),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  return false;
                } else if (direction == DismissDirection.endToStart) {
                  return true;
                }
                return false;
              },
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  onRemoveItem?.call(item.id);
                }
              },
              child: UiKitPostCard(
                isFeed: false,
                key: item.key,
                authorName: item.name,
                authorUsername: item.username,
                authorAvatarUrl: item.avatarUrl,
                authorSpeciality: item.speciality,
                authorUserType: item.userType,
                heartEyesCount: item.heartEyesReactionsCount,
                likesCount: item.likeReactionsCount,
                sunglassesCount: item.sunglassesReactionsCount,
                firesCount: item.fireReactionsCount,
                smileyCount: item.smileyReactionsCount,
                text: item.text,
                viewShareDate: item.viewShareDate,
                hasNewMark: item.newMark,
                showTranslateButton: item.showTranslateButton,
                createAt: item.createAt,
              ),
            ).paddingOnly(
              top: SpacingFoundation.verticalSpacing16,
              bottom: SpacingFoundation.verticalSpacing8,
            );
          } else {
            return SizedBox.shrink();
          }
        }
      },
    );
  }
}
