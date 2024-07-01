import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../../shuffle_components_kit.dart';

class AllVideoReactionsComponent extends StatelessWidget {
  final PagingController<int, VideoReactionUiModel> videoReactionsPagingController;
  final ValueChanged<VideoReactionUiModel> onReactionTapped;

  const AllVideoReactionsComponent({
    super.key,
    required this.videoReactionsPagingController,
    required this.onReactionTapped,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          S.current.MyReactions,
          style: boldTextTheme?.title1,
        ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        SpacingFoundation.verticalSpace16,
        SizedBox(
          height: 0.75.sh,
          child: PagedGridView(
            padding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
            pagingController: videoReactionsPagingController,
            builderDelegate: PagedChildBuilderDelegate<VideoReactionUiModel>(
              itemBuilder: (context, item, index) {
                return UiKitReactionPreview(
                  viewed: item.isViewed,
                  imagePath: item.previewImageUrl,
                  onTap: () => onReactionTapped(item),
                );
              },
              newPageProgressIndicatorBuilder: (c) => UiKitShimmerProgressIndicator(
                gradient: GradientFoundation.greyGradient,
                child: UiKitReactionPreview(
                  imagePath: GraphicsFoundation.instance.png.place.path,
                ).paddingOnly(left: EdgeInsetsFoundation.horizontal16),
              ),
              firstPageProgressIndicatorBuilder: (c) => const Center(child: LoadingWidget()),
              noItemsFoundIndicatorBuilder: (c) => Center(
                child: Text(
                  S.current.NoVideoReactionsYet,
                  style: boldTextTheme?.subHeadline,
                ),
              ),
              firstPageErrorIndicatorBuilder: (context) => const SizedBox(),
              newPageErrorIndicatorBuilder: (context) => const SizedBox(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: SpacingFoundation.verticalSpacing8,
              mainAxisSpacing: SpacingFoundation.horizontalSpacing8,
              childAspectRatio: 88 / 148,
            ),
          ),
        ),
      ],
    );
  }
}
