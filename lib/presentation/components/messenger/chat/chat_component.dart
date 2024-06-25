import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

//ignore_for_file: no-empty-block

class ChatComponent extends StatelessWidget {
  final TextEditingController messageController;
  final PagingController<int, ChatMessageUiModel> pagingController;
  final ScrollController scrollController;
  final ValueChanged<int>? onPlaceTap;
  final ValueChanged<int>? onAcceptInvitationTap;
  final ValueChanged<int>? onDenyInvitationTap;
  final VoidCallback? onMessageSent;
  final VoidCallback? onProfileTapped;
  final ChatItemUiModel chatItemUiModel;

  const ChatComponent({
    super.key,
    required this.messageController,
    required this.pagingController,
    required this.scrollController,
    required this.chatItemUiModel,
    this.onPlaceTap,
    this.onProfileTapped,
    this.onAcceptInvitationTap,
    this.onDenyInvitationTap,
    this.onMessageSent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return BlurredAppBarPage(
      customToolbarBaseHeight: 100,
      autoImplyLeading: true,
      canFoldAppBar: false,
      appBarTrailing: context.smallGradientButton(
        data: BaseUiKitButtonData(
          iconInfo: BaseUiKitButtonIconData(
            iconData: ShuffleUiKitIcons.profileplus,
          ),
          onPressed: onProfileTapped,
        ),
      ),
      customTitle: Expanded(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            BorderedUserCircleAvatar(
              imageUrl: chatItemUiModel.avatarUrl,
              size: 0.1375.sw,
            ),
            SpacingFoundation.horizontalSpace12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        chatItemUiModel.username,
                        style: theme?.boldTextTheme.caption1Bold,
                      ),
                      SpacingFoundation.horizontalSpace12,
                      if (chatItemUiModel.userType == UserTileType.influencer)
                        GradientableWidget(
                          gradient: GradientFoundation.defaultLinearGradient,
                          child: ImageWidget(
                            svgAsset: GraphicsFoundation.instance.svg.star2,
                            color: context.uiKitTheme?.colorScheme.inversePrimary,
                            height: 16.w,
                          ),
                        ),
                      if (chatItemUiModel.userType == UserTileType.premium)
                        ImageWidget(
                          svgAsset: GraphicsFoundation.instance.svg.star2,
                          color: context.uiKitTheme?.colorScheme.inversePrimary,
                          height: 16.w,
                        ),
                      if (chatItemUiModel.userType == UserTileType.pro)
                        GradientableWidget(
                          gradient: GradientFoundation.premiumLinearGradient,
                          child: Text(
                            'pro',
                            style: theme?.boldTextTheme.caption1Bold.copyWith(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  SpacingFoundation.verticalSpace2,
                  Text(
                    chatItemUiModel.nickname,
                    style: theme?.boldTextTheme.caption1Medium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      children: [
        PagedListView<int, ChatMessageUiModel>.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, item, index) {
              if (item.senderIsMe) {
                if (item.isInvitation) {
                  return UiKitChatOutCard(
                    timeOfDay: item.timeSent,
                    sentByMe: item.senderIsMe,
                    id: 0,
                    child: UiKitInviteMessageContent(
                      username: item.invitationData!.username,
                      placeName: item.invitationData!.placeName,
                      placeImagePath: item.invitationData!.placeImagePath,
                      invitedPeopleAvatarPaths: item.invitationData!.invitedPeopleAvatarPaths,
                      userType: UserTileType.ordinary,
                      onPlaceTap: () {},
                      canDenyInvitation: true,
                      onAcceptTap: () {},
                      onDenyTap: () {},
                      tags: item.invitationData!.tags,
                    ),
                  );
                }

                return UiKitChatOutCard(
                  id: 0,
                  timeOfDay: item.timeSent,
                  text: item.message,
                  sentByMe: item.senderIsMe,
                );
              } else {
                return UiKitChatInCard(
                  id: 0,
                  timeOfDay: item.timeSent,
                  text: item.message,
                );
              }
            },
          ),
          separatorBuilder: (context, index) => SpacingFoundation.verticalSpace8,
        ),
        SpacingFoundation.verticalSpace24,
        SpacingFoundation.verticalSpace12,
        SpacingFoundation.verticalSpace24,
      ],
    );
  }
}
