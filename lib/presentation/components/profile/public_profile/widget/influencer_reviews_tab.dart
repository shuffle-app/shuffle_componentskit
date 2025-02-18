import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/video_reaction_ui_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_uikit/ui_models/profile/profile_place.dart';

class InfluencerReviewsTab extends StatelessWidget {
  final PagingController<int, VideoReactionUiModel>? storiesPagingController;
  final ValueChanged<VideoReactionUiModel>? onReactionTapped;
  final ValueNotifier<double>? tiltNotifier;
  final List<ProfilePlace>? profilePlaces;
  final double? horizontalMargin;
  final Function(int? placeId, int? eventId)? onItemTap;

  final VoidCallback? onExpand;

  const InfluencerReviewsTab({
    super.key,
    this.storiesPagingController,
    this.onReactionTapped,
    this.tiltNotifier,
    this.profilePlaces,
    this.horizontalMargin,
    this.onItemTap,
    this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (storiesPagingController != null)
          DecoratedBox(
            decoration: BoxDecoration(color: theme?.colorScheme.surface1),
            child: UiKitTiltWrapper(
              tiltNotifier: tiltNotifier,
              child: SizedBox(
                height: 0.285.sw * 1.7,
                width: 1.sw,
                child: PagedListView<int, VideoReactionUiModel>.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  builderDelegate: PagedChildBuilderDelegate(
                    firstPageProgressIndicatorBuilder: (c) => Align(
                      alignment: Alignment.centerLeft,
                      child: UiKitShimmerProgressIndicator(
                        gradient: GradientFoundation.greyGradient,
                        child: UiKitReactionPreview(
                          customHeight: 0.285.sw * 1.7,
                          customWidth: 0.285.sw,
                          imagePath: GraphicsFoundation.instance.png.place.path,
                        ).paddingOnly(left: horizontalMargin ?? SpacingFoundation.horizontalSpacing16),
                      ),
                    ),
                    newPageProgressIndicatorBuilder: (c) => Align(
                      alignment: Alignment.centerLeft,
                      child: UiKitShimmerProgressIndicator(
                        gradient: GradientFoundation.greyGradient,
                        child: UiKitReactionPreview(
                          customHeight: 0.285.sw * 1.7,
                          customWidth: 0.285.sw,
                          imagePath: GraphicsFoundation.instance.png.place.path,
                        ),
                      ),
                    ),
                    itemBuilder: (_, item, index) {
                      double leftPadding = 0;
                      if (index == 0) leftPadding = horizontalMargin ?? SpacingFoundation.horizontalSpacing16;

                      return UiKitReactionPreview(
                        customHeight: 0.285.sw * 1.7,
                        customWidth: 0.285.sw,
                        imagePath: item.previewImageUrl ?? '',
                        viewed: item.isViewed,
                        onTap: () => onReactionTapped?.call(item),
                      ).paddingOnly(left: leftPadding);
                    },
                  ),
                  separatorBuilder: (_, i) => SpacingFoundation.horizontalSpace12,
                  pagingController: storiesPagingController!,
                ),
              ),
            ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing16),
          ),
        if (profilePlaces != null && profilePlaces!.isNotEmpty)
          ProfilePostsPlaces(
            onExpand: onExpand,
            onItemTap: onItemTap,
            horizontalMargin: EdgeInsetsFoundation.horizontal16,
            places: profilePlaces!,
          ).paddingOnly(top: SpacingFoundation.verticalSpacing16)
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(S.current.NothingFound)],
          ).paddingOnly(top: SpacingFoundation.verticalSpacing24)
      ],
    );
  }
}
