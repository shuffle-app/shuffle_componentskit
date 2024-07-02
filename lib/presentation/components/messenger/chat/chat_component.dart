import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

//ignore_for_file: no-empty-block

class ChatComponent extends StatelessWidget {
  final TextEditingController messageController;
  final PagingController<int, ChatMessageUiModel> pagingController;
  final ScrollController scrollController;
  final ValueChanged<int>? onChatHeaderTapped;
  final ValueChanged<int>? onAcceptInvitationTap;
  final ValueChanged<int>? onDenyInvitationTap;
  final VoidCallback? onMessageSent;
  final VoidCallback? onAddMorePeople;
  final VoidCallback? onLeaveChat;
  final VoidCallback? onInviteToAnotherPlace;
  final ChatItemUiModel chatItemUiModel;

  const ChatComponent({
    super.key,
    required this.messageController,
    required this.pagingController,
    required this.scrollController,
    required this.chatItemUiModel,
    this.onInviteToAnotherPlace,
    this.onLeaveChat,
    this.onChatHeaderTapped,
    this.onAddMorePeople,
    this.onAcceptInvitationTap,
    this.onDenyInvitationTap,
    this.onMessageSent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return BlurredAppPageWithPagination(
      paginationController: pagingController,
      customToolbarBaseHeight: 100,
      autoImplyLeading: true,
      canFoldAppBar: false,
      reverse: true,
      appBarTrailing: chatItemUiModel.isGroupChat
          ? chatItemUiModel.userIsOwner
              ? context.smallGradientButton(
                  data: BaseUiKitButtonData(
                    iconInfo: BaseUiKitButtonIconData(
                      iconData: ShuffleUiKitIcons.profileplus,
                    ),
                    onPressed: onAddMorePeople,
                  ),
                )
              : context.smallOutlinedButton(
                  data: BaseUiKitButtonData(
                    iconInfo: BaseUiKitButtonIconData(
                      iconData: ShuffleUiKitIcons.logout,
                    ),
                    onPressed: onLeaveChat,
                  ),
                )
          : context.smallGradientButton(
              data: BaseUiKitButtonData(
                iconInfo: BaseUiKitButtonIconData(
                  iconData: ShuffleUiKitIcons.profileplus,
                ),
                onPressed: onInviteToAnotherPlace,
              ),
            ),
      customTitle: Expanded(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            context.userAvatar(
              size: UserAvatarSize.x40x40,
              type: chatItemUiModel.userType,
              userName: chatItemUiModel.chatTitle,
            ),
            SpacingFoundation.horizontalSpace12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          chatItemUiModel.chatTitle,
                          style: theme?.boldTextTheme.caption1Bold.copyWith(overflow: TextOverflow.ellipsis),
                        ),
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
                  if (chatItemUiModel.subtitle != null)
                    Text(
                      chatItemUiModel.subtitle!,
                      style: theme?.boldTextTheme.caption1Medium,
                    ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical2),
                  if (chatItemUiModel.tag != null)
                    UiKitTagWidget(
                      title: chatItemUiModel.tag!.title,
                      icon: chatItemUiModel.tag!.icon,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bodyBottomSpace: kBottomNavigationBarHeight + SpacingFoundation.verticalSpacing40,
      padding: EdgeInsets.only(top: EdgeInsetsFoundation.vertical24),
      builderDelegate: PagedChildBuilderDelegate<ChatMessageUiModel>(
        firstPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
        newPageProgressIndicatorBuilder: (context) => UiKitShimmerProgressIndicator(
          gradient: GradientFoundation.greyGradient,
          child: UiKitChatOutCard(
            id: -1,
            timeOfDay: DateTime.now(),
            sentByMe: true,
            text: ' ',
          ),
        ),
        noItemsFoundIndicatorBuilder: (context) => UiKitEmptyListPlaceHolder(
          message: S.of(context).NoMessagesYet,
        ),
        itemBuilder: (context, item, index) {
          if (item.messageType == MessageType.info) {
            return UiKitInfoText(
              text: item.message!,
              title: item.infoMessageTitle,
            ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal20);
          } else if (item.senderIsMe) {
            if (item.isInvitation && item.invitationData != null) {
              return UiKitChatOutCard(
                timeOfDay: item.timeSent,
                sentByMe: item.senderIsMe,
                id: item.messageId,
                child: UiKitInviteMessageContent(
                  username: 'item.invitationData!.username',
                  placeName: 'item.invitationData!.placeName',
                  placeImagePath: 'item.invitationData!.placeImagePath',
                  invitedPeopleAvatarPaths: ['item.invitationData!.invitedPeopleAvatarPaths'],
                  userType: UserTileType.ordinary,
                  onPlaceTap: () {},
                  canDenyInvitation: true,
                  onAcceptTap: () {},
                  onDenyTap: () {},
                  tags: [
                    // item.invitationData!.tags,
                  ],
                ),
              );
            }

            return UiKitChatOutCard(
              id: item.messageId,
              timeOfDay: item.timeSent,
              text: item.message,
              sentByMe: item.senderIsMe,
            );
          } else {
            return UiKitChatInCard(
              id: item.messageId,
              timeOfDay: item.timeSent,
              text: item.message,
            );
          }
        },
      ),
    );
  }
}
