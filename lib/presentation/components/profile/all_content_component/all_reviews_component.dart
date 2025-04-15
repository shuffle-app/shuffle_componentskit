import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AllReviewsComponent extends StatelessWidget {
  final PagingController<int, FeedbackUiModel> feedbacksPagingController;
  final ValueChanged<FeedbackUiModel> onFeedbackTapped;

  const AllReviewsComponent({
    super.key,
    required this.feedbacksPagingController,
    required this.onFeedbackTapped,
  });

  double get feedbackCardWidth => 1.sw - EdgeInsetsFoundation.horizontal32;

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          S.current.MyFeedback,
          style: boldTextTheme?.title1,
        ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        SpacingFoundation.verticalSpace16,
        SizedBox(
          height: 0.75.sh,
          child: PagingListener(
              controller: feedbacksPagingController,
              builder: (context, state, fetchNextPage) => PagedListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                    state: state,
                    fetchNextPage: fetchNextPage,
                    separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
                    builderDelegate: PagedChildBuilderDelegate<FeedbackUiModel>(
                      noItemsFoundIndicatorBuilder: (c) => Center(
                        child: Text(
                          S.current.NoFeedbacksYet,
                          style: boldTextTheme?.subHeadline,
                        ),
                      ),
                      newPageProgressIndicatorBuilder: (c) => UiKitShimmerProgressIndicator(
                        gradient: GradientFoundation.greyGradient,
                        child: SizedBox(
                          width: feedbackCardWidth,
                          child: UiKitFeedbackCard(),
                        ),
                      ),
                      firstPageProgressIndicatorBuilder: (c) => const Center(child: LoadingWidget()),
                      firstPageErrorIndicatorBuilder: (context) => const SizedBox(),
                      newPageErrorIndicatorBuilder: (context) => const SizedBox(),
                      itemBuilder: (context, feedback, index) {
                        return SizedBox(
                          width: feedbackCardWidth,
                          child: UiKitFeedbackCard(
                            showTranslateButton: feedback.showTranslateButton,
                            onTranslateTap: feedback.onTranslateText,
                            userTileType: feedback.feedbackAuthorType,
                            title: feedback.feedbackAuthorName,
                            avatarUrl: feedback.feedbackAuthorPhoto,
                            datePosted: feedback.feedbackDateTime,
                            companyAnswered: false,
                            text: feedback.feedbackText,
                            media: feedback.media,
                            helpfulCount: feedback.helpfulCount == 0 ? null : feedback.helpfulCount,
                            onPressed: () => onFeedbackTapped.call(feedback),
                          ),
                        );
                      },
                    ),
                  )),
        ),
      ],
    );
  }
}
