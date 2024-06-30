import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/feedback_response_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_components_kit/presentation/components/feedback/feedback_response_item_component.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedbackResponseComponent extends StatelessWidget {
  const FeedbackResponseComponent({
    super.key,
    required this.uiProfileModel,
    this.onMessageTap,
    required this.feedBacks,
    required this.rating,
  });

  final UiProfileModel uiProfileModel;
  final VoidCallback? onMessageTap;
  final int rating;
  final List<FeedbackResponseUiModel> feedBacks;

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        autoImplyLeading: true,
        centerTitle: true,
        wrapSliverBox: false,
        title: S.current.Feedback,
        childrenPadding: EdgeInsets.all(EdgeInsetsFoundation.all16),
        children: [
          UiKitCardWrapper(
            child: Row(
              children: [
                context.userAvatar(
                  size: UserAvatarSize.x40x40,
                  type: uiProfileModel.userTileType,
                  userName: uiProfileModel.name ?? 'Marry Alliance',
                  imageUrl: uiProfileModel.avatarUrl ??
                      GraphicsFoundation.instance.png.place.path,
                ),
                SpacingFoundation.horizontalSpace12,
                Expanded(
                  child: Text(
                    uiProfileModel.name ?? 'Marry Alliance',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: boldTextTheme?.caption1Bold,
                  ),
                ),
                UiKitRatingBadge(rating: rating),
              ],
            ).paddingAll(EdgeInsetsFoundation.all16),
          ),
          FeedbackResponseItemComponent(feedBacks: feedBacks),
        ],
      ),
      floatingActionButton: onMessageTap != null ? context.smallGradientButton(
        data: BaseUiKitButtonData(
          onPressed: onMessageTap,
          iconInfo: BaseUiKitButtonIconData(iconData: ShuffleUiKitIcons.message),
        ),
      ) : null,
    );
  }
}
