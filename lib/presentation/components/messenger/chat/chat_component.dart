import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'hidden_chat_mocked_component.dart';

//ignore_for_file: no-empty-block

class ChatComponent extends StatelessWidget {
  final TextEditingController messageController;
  final PagingController<int, ChatMessageUiModel> pagingController;
  final ScrollController scrollController;
  final Function(int, Type)? onInvitationPlaceTap;
  final Function(int, Type)? onChatHeaderTapped;
  final ValueChanged<int>? onAcceptInvitationTap;
  final ValueChanged<int>? onDenyInvitationTap;
  final VoidCallback? onAddMorePeople;
  final VoidCallback? onLeaveChat;
  final VoidCallback? onInviteToAnotherPlace;
  final ValueChanged<int>? onReplyMessageTap;
  final ChatItemUiModel chatData;
  final ValueChanged<int>? onMessageVisible;
  final ValueChanged<int>? onReplyMessage;
  final bool chatOwnerIsMe;
  final bool isMultipleChat;
  final ChatMessageUiModel? pinnedMessage;
  final VoidCallback? onPinnedMessageTap;
  final void Function(int userId, UserTileType userType)? onProfileTapped;
  final double keyboardPadding;
  final bool isGuestView;
  final VoidCallback? onRequestToJoinChat;
  final VoidCallback? onShareChat;

  const ChatComponent({
    super.key,
    required this.messageController,
    required this.pagingController,
    required this.scrollController,
    required this.chatData,
    this.onInviteToAnotherPlace,
    this.onLeaveChat,
    this.onChatHeaderTapped,
    this.onAddMorePeople,
    this.onAcceptInvitationTap,
    this.onDenyInvitationTap,
    this.onMessageVisible,
    this.onReplyMessage,
    this.chatOwnerIsMe = false,
    this.isMultipleChat = false,
    this.onInvitationPlaceTap,
    this.onPinnedMessageTap,
    this.pinnedMessage,
    this.onReplyMessageTap,
    this.onProfileTapped,
    this.keyboardPadding = 0,
    this.isGuestView = false,
    this.onRequestToJoinChat,
    this.onShareChat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final isLightThemeOn = theme?.themeMode == ThemeMode.light;

    late final Widget? trailingWidget;
    if (isGuestView) {
      if (chatData.joinRequested != null && chatData.joinRequested!) {
        //leave null
        trailingWidget = null;
      } else {
        trailingWidget = context.midSizeOutlinedButton(
          data: BaseUiKitButtonData(
            iconWidget: ImageWidget(
              svgAsset: GraphicsFoundation.instance.svg.login,
            ),
            onPressed: onRequestToJoinChat,
          ),
        );
      }
    } else if ((chatData.members?.isEmpty ?? false) ||
        chatData.readOnlyChat ||
        (chatData.hasAcceptedInvite && !chatData.isGroupChat)) {
      trailingWidget = context.midSizeOutlinedButton(
        data: BaseUiKitButtonData(
          iconInfo: BaseUiKitButtonIconData(
            iconData: ShuffleUiKitIcons.logout,
          ),
          onPressed: onLeaveChat,
        ),
      );
    } else if (chatData.isGroupChat && !chatData.userIsOwner) {
      trailingWidget = UiKitPopUpMenuButton.optionWithIcon(options: [
        UiKitPopUpMenuButtonOption(
          title: S.of(context).Share,
          icon: ShuffleUiKitIcons.share,
          value: 'share',
          onTap: onShareChat,
        ),
        UiKitPopUpMenuButtonOption(
          title: S.of(context).Edit,
          icon: ShuffleUiKitIcons.logout,
          value: 'leave',
          onTap: onLeaveChat,
        ),
      ]);
    } else {
      trailingWidget = SizedBox.fromSize(
        size: Size(0.125.sw, 0.125.sw),
        child: context.smallGradientButton(
          data: BaseUiKitButtonData(
            iconInfo: BaseUiKitButtonIconData(
              iconData: ShuffleUiKitIcons.profileplus,
            ),
            onPressed: onInviteToAnotherPlace,
          ),
        ),
      );
    }

    return BlurredAppPageWithPagination<ChatMessageUiModel>(
      paginationController: pagingController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      autoImplyLeading: true,
      canFoldAppBar: false,
      reverse: true,
      physics: const NeverScrollableScrollPhysics(),
      pagingPhysics: isGuestView ? const NeverScrollableScrollPhysics() : null,
      keyboardPadding: isGuestView ? 0 : keyboardPadding,
      topFixedAddition: pinnedMessage != null
          ? GestureDetector(
              onTap: onPinnedMessageTap,
              child: UiKitInfoText(
                chatName: pinnedMessage!.chatName,
                text: pinnedMessage!.message!,
                title: pinnedMessage!.infoMessageTitle,
                centerText: !pinnedMessage!.messageId.isNegative,
              ).paddingOnly(
                top: EdgeInsetsFoundation.vertical16,
                bottom: EdgeInsetsFoundation.zero,
                left: EdgeInsetsFoundation.horizontal20,
                right: EdgeInsetsFoundation.horizontal20,
              ),
            )
          : null,
      scrollController: scrollController,
      appBarTrailing: trailingWidget,
      customTitle: Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (chatData.isGroupChat && chatData.contentId != null && chatData.contentType != null) {
              onChatHeaderTapped?.call(chatData.contentId!, chatData.contentType!);
            } else if (!chatData.isGroupChat) {
              final owner = chatData.owner;
              if (owner == null) return;

              if (!chatData.userIsOwner) {
                onProfileTapped?.call(owner.id, owner.userType);
              } else {
                final member = chatData.members?.firstWhere((member) => member.id != owner.id);
                if (member == null) return;

                onProfileTapped?.call(member.id, member.userType);
              }
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              context.userAvatar(
                size: UserAvatarSize.x40x40,
                type: chatData.userType,
                userName: chatData.chatTitle,
                imageUrl: chatData.avatarUrl,
              ),
              SpacingFoundation.horizontalSpace12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            chatData.chatTitle,
                            style: theme?.boldTextTheme.caption1Bold.copyWith(overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        SpacingFoundation.horizontalSpace6,
                        if (chatData.userType == UserTileType.influencer) InfluencerAccountMark(),
                        if (chatData.userType == UserTileType.premium) PremiumAccountMark(),
                        if (chatData.userType == UserTileType.pro) ProAccountMark(),
                      ],
                    ),
                    if (chatData.subtitle != null)
                      Text(
                        chatData.subtitle!,
                        maxLines: 1,
                        style: theme?.boldTextTheme.caption1Medium.copyWith(overflow: TextOverflow.ellipsis),
                      ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical2),
                    if (chatData.tag != null)
                      UiKitTagWidget(
                        title: chatData.tag!.title,
                        icon: chatData.tag!.icon,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheetHeight: isGuestView ? 0 : (1.sw * 0.275 - (1.sw <= 380 ? SpacingFoundation.verticalSpacing8 : 0)),
      bodyBottomSpace: (kBottomNavigationBarHeight +
          (chatData.isGroupChat ? SpacingFoundation.verticalSpacing16 : SpacingFoundation.verticalSpacing4)),
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
        noItemsFoundIndicatorBuilder: (context) => isGuestView
            ? Center(
                child: HiddenChatMockedComponent(
                  onJoinChatRequest: chatData.joinRequested == true ? null : onRequestToJoinChat,
                ),
              )
            : UiKitEmptyListPlaceHolder(
                message: S.of(context).NoMessagesYet,
              ),
        itemBuilder: (context, item, index) {
          if (item.messageType == MessageType.info) {
            return VisibilityDetector(
              key: Key(item.messageId.toString()),
              onVisibilityChanged: (info) {
                if (info.visibleFraction > 0.5) onMessageVisible?.call(item.messageId);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.isLastMessageToDate) UiKitDateBadge(date: item.timeSent),
                  UiKitInfoText(
                    text: item.message!,
                    title: item.infoMessageTitle,
                    gradientText: item.gradientableText,
                    additionalText: item.additionalText,
                    centerText: !item.messageId.isNegative,
                    textGradient: item.gradientableText != null ? GradientFoundation.defaultLinearGradient : null,
                  ).paddingOnly(
                    left: EdgeInsetsFoundation.horizontal20,
                    right: EdgeInsetsFoundation.horizontal20,
                    top: EdgeInsetsFoundation.vertical4,
                  ),
                ],
              ),
            );
          } else if (item.messageType == MessageType.joinRequest) {
            return VisibilityDetector(
              key: Key(item.messageId.toString()),
              onVisibilityChanged: (info) {
                if (info.visibleFraction > 0.5) onMessageVisible?.call(item.messageId);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.message!,
                    // '${item.senderName} ${S.of(context).WantToJoin}',
                    style: theme?.boldTextTheme.caption3Medium,
                  ),
                  SpacingFoundation.verticalSpace4,
                  context.createSmallOutlinedButton(
                      gradient: GradientFoundation.defaultLinearGradient,
                      data: BaseUiKitButtonData(text: S.of(context).Allow, onPressed: onRequestToJoinChat,),
                      )
                ],
              ),
            );
          } else if (item.senderIsMe) {
            if (item.isInvitation && item.invitationData != null) {
              return VisibilityDetector(
                key: Key(item.messageId.toString()),
                onVisibilityChanged: (info) {
                  if (info.visibleFraction > 0.5) onMessageVisible?.call(item.messageId);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.isLastMessageToDate) UiKitDateBadge(date: item.timeSent),
                    UiKitChatOutCard(
                      onReplyMessage: onReplyMessage,
                      timeOfDay: item.timeSent,
                      sentByMe: item.senderIsMe,
                      id: item.messageId,
                      brightness: isLightThemeOn ? Brightness.dark : Brightness.light,
                      child: UiKitInviteMessageContent(
                        hasAcceptedInvite: chatData.isGroupChat ? false : item.invitationData!.hasAcceptedInvite,
                        brightness: isLightThemeOn ? Brightness.dark : Brightness.light,
                        showGang: item.invitationData!.invitedPeopleAvatarPaths.isNotEmpty && chatData.isGroupChat,
                        onInvitePeopleTap: onAddMorePeople,
                        username: item.invitationData!.senderUserName,
                        placeName: item.invitationData!.contentName,
                        placeImagePath: item.invitationData!.contentImagePath,
                        invitedUsersData: item.invitationData!.invitedPeopleAvatarPaths,
                        userType: item.invitationData!.senderUserType,
                        onPlaceTap: () => onInvitationPlaceTap?.call(
                          item.invitationData!.contentId,
                          item.invitationData!.contentType,
                        ),
                        canDenyInvitation: false,
                        canAddMorePeople: chatData.readOnlyChat ? false : chatOwnerIsMe && isMultipleChat,
                        onAcceptTap: () {
                          onAcceptInvitationTap?.call(item.connectId ?? item.invitationData!.connectId);
                        },
                        onDenyTap: () {
                          onDenyInvitationTap?.call(item.connectId ?? item.invitationData!.connectId);
                        },
                        tags: item.invitationData?.tags ?? [],
                        customMessageData: chatData.isGroupChat
                            ? null
                            : InviteCustomMessageData(
                                senderUserName: item.invitationData!.senderUserName,
                                receiverUserName: item.invitationData!.receiverUserName,
                                senderUserType: item.invitationData!.senderUserType,
                                receiverUserType: item.invitationData!.receiverUserType,
                              ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return VisibilityDetector(
              key: Key(item.messageId.toString()),
              onVisibilityChanged: (info) {
                if (info.visibleFraction > 0.5) onMessageVisible?.call(item.messageId);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.isLastMessageToDate) UiKitDateBadge(date: item.timeSent),
                  item.replyMessageModel == null
                      ? UiKitChatOutCard(
                          onReplyMessage: onReplyMessage,
                          id: item.messageId,
                          timeOfDay: item.timeSent,
                          text: item.message,
                          sentByMe: item.senderIsMe,
                        )
                      : UiKitChatCardWithReplyOut(
                          id: item.messageId,
                          onReplyMessage: onReplyMessage,
                          replyMessageId: item.replyMessageModel!.messageId,
                          onReplyMassageTap: onReplyMessageTap,
                          text: item.message,
                          sentByMe: item.senderIsMe,
                          replyText: item.replyMessageModel!.message!,
                          timeOfDay: item.timeSent,
                          replyUserAvatar: item.replyMessageModel!.senderAvatar!,
                          replySenderName: item.replyMessageModel!.senderName!,
                          replyUserType: item.replyMessageModel!.senderProfileType!,
                        ),
                ],
              ),
            );
          } else {
            if (item.isInvitation && item.invitationData != null) {
              return VisibilityDetector(
                key: Key(item.messageId.toString()),
                onVisibilityChanged: (info) {
                  if (info.visibleFraction > 0.5) onMessageVisible?.call(item.messageId);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.isLastMessageToDate) UiKitDateBadge(date: item.timeSent),
                    UiKitChatInCard(
                      onUsernameTapped: () => onProfileTapped?.call(
                        item.senderId,
                        item.senderProfileType ?? UserTileType.ordinary,
                      ),
                      showAvatar: chatData.isGroupChat,
                      avatarUrl: item.senderAvatar,
                      senderName: item.senderName,
                      senderType: item.senderProfileType,
                      senderNickname: item.senderNickname ?? '',
                      onReplyMessage: onReplyMessage,
                      timeOfDay: item.timeSent,
                      id: item.messageId,
                      hasInvitation: true,
                      child: UiKitInviteMessageContent(
                        hasAcceptedInvite: chatData.isGroupChat ? false : item.invitationData!.hasAcceptedInvite,
                        brightness: isLightThemeOn ? Brightness.light : Brightness.dark,
                        showGang: item.invitationData!.invitedPeopleAvatarPaths.isNotEmpty && chatData.isGroupChat,
                        username: item.invitationData!.senderUserName,
                        placeName: item.invitationData!.contentName,
                        placeImagePath: item.invitationData!.contentImagePath,
                        invitedUsersData: item.invitationData!.invitedPeopleAvatarPaths,
                        userType: item.invitationData!.senderUserType,
                        onInvitePeopleTap: onAddMorePeople,
                        onPlaceTap: () => onInvitationPlaceTap?.call(
                          item.invitationData!.contentId,
                          item.invitationData!.contentType,
                        ),
                        canDenyInvitation: chatData.readOnlyChat
                            ? false
                            : chatData.isGroupChat
                                ? !item.invitationData!.hasAcceptedInvite
                                : !chatData.hasAcceptedInvite,
                        canAddMorePeople: chatData.readOnlyChat ? false : chatOwnerIsMe && isMultipleChat,
                        onAcceptTap: () {
                          onAcceptInvitationTap?.call(item.connectId ?? item.invitationData!.connectId);
                        },
                        onDenyTap: () {
                          onDenyInvitationTap?.call(item.connectId ?? item.invitationData!.connectId);
                        },
                        tags: item.invitationData?.tags ?? [],
                        customMessageData: chatData.isGroupChat
                            ? null
                            : InviteCustomMessageData(
                                senderUserName: item.invitationData!.senderUserName,
                                receiverUserName: item.invitationData!.receiverUserName,
                                senderUserType: item.invitationData!.senderUserType,
                                receiverUserType: item.invitationData!.receiverUserType,
                              ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return VisibilityDetector(
              key: Key(item.messageId.toString()),
              onVisibilityChanged: (info) {
                if (info.visibleFraction > 0.5) onMessageVisible?.call(item.messageId);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.isLastMessageToDate) UiKitDateBadge(date: item.timeSent),
                  item.replyMessageModel == null
                      ? UiKitChatInCard(
                          onUsernameTapped: () => onProfileTapped?.call(
                            item.senderId,
                            item.senderProfileType ?? UserTileType.ordinary,
                          ),
                          hasInvitation: false,
                          showAvatar: chatData.isGroupChat,
                          avatarUrl: item.senderAvatar,
                          senderName: item.senderName,
                          senderType: item.senderProfileType,
                          onReplyMessage: onReplyMessage,
                          id: item.messageId,
                          timeOfDay: item.timeSent,
                          text: item.message,
                          senderNickname: item.senderNickname ?? '',
                        )
                      : UiKitChatCardWithReplyIn(
                          onUsernameTapped: () => onProfileTapped?.call(
                            item.senderId,
                            item.senderProfileType ?? UserTileType.ordinary,
                          ),
                          showAvatar: chatData.isGroupChat,
                          id: item.messageId,
                          onReplyMessage: onReplyMessage,
                          onReplyMassageTap: onReplyMessageTap,
                          text: item.message,
                          timeOfDay: item.timeSent,
                          replyMessageId: item.replyMessageModel!.messageId,
                          replyText: item.replyMessageModel!.message!,
                          replyUserAvatar: item.replyMessageModel!.senderAvatar!,
                          replyUserType: item.replyMessageModel!.senderProfileType!,
                          replySenderName: item.replyMessageModel!.senderName!,
                          senderNickname: item.senderNickname ?? '',
                          senderName: item.senderName,
                          senderType: item.senderProfileType,
                          avatarUrl: item.senderAvatar,
                        ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
