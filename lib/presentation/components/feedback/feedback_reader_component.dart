import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class FeedbackReaderComponent extends StatelessWidget {
  const FeedbackReaderComponent({super.key, required this.reviews, this.onHelpfulTap});

  final List<FeedbackUiModel> reviews;
  final ValueChanged<int>? onHelpfulTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    const divider = Divider(
      height: 2,
      thickness: 3,
      color: ColorsFoundation.surface2,
    );
    return UiKitCardWrapper(
      padding: EdgeInsets.zero,
      color: theme?.colorScheme.surface,
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final e = reviews[index];
          return UiKitFeedbackCard(
              text: e.feedbackText,
              onLike: () => onHelpfulTap?.call(e.id),
              title: e.feedbackAuthorName,
              avatarUrl: e.feedbackAuthorPhoto,
              helpfulCount: e.helpfulCount,
              datePosted: e.feedbackDateTime,
              maxLines: 100,
              rating: e.feedbackRating,
              customBackgroundColor: theme?.colorScheme.surface,
              userTileType: e.feedbackAuthorType);
        },
        separatorBuilder: (BuildContext context, int index) =>
            divider.paddingSymmetric(vertical: EdgeInsetsFoundation.vertical16),
        itemCount: reviews.length,
      ),
    ).paddingOnly(top: EdgeInsetsFoundation.vertical16, bottom: EdgeInsetsFoundation.vertical24);
  }
}
