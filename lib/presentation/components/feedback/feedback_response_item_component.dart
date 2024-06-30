import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/feedback_response_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedbackResponseItemComponent extends StatelessWidget {
  const FeedbackResponseItemComponent({super.key, required this.feedBacks, this.onHelpfulTap});

  final List<FeedbackResponseUiModel> feedBacks;
  final ValueChanged<int>? onHelpfulTap;

  @override
  Widget build(BuildContext context) {
    const divider = Divider(
      height: 2,
      thickness: 3,
      color: ColorsFoundation.surface2,
    );
    return UiKitCardWrapper(
      padding: EdgeInsets.zero,
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final e = feedBacks[index];
          return UiKitFeedbackCard(
              text: e.message,
              onLike: e.senderIsMe ? null : () => onHelpfulTap?.call(e.id),
              title: e.senderName,
              avatarUrl: e.senderImagePath,
              helpfulCount: e.helpfulCount,
              datePosted: e.timeSent,
              maxLines: 15,
              userTileType: e.userTileType);
        },
        separatorBuilder: (BuildContext context, int index) =>
            divider.paddingSymmetric(vertical: EdgeInsetsFoundation.vertical16),
        itemCount: feedBacks.length,
      ),
    );
  }
}
