import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ChatComponent extends StatelessWidget {
  final TextEditingController messageController;
  final PagingController<int, ChatMessageUiModel> pagingController;
  final ScrollController scrollController;
  final ValueChanged<int>? onPlaceTap;
  final ValueChanged<int>? onAcceptInvitationTap;
  final ValueChanged<int>? onDenyInvitationTap;
  final VoidCallback? onMessageSent;

  const ChatComponent({
    Key? key,
    required this.messageController,
    required this.pagingController,
    required this.scrollController,
    this.onPlaceTap,
    this.onAcceptInvitationTap,
    this.onDenyInvitationTap,
    this.onMessageSent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalConfiguration().appConfig.content['chat_page'];
    final model = ComponentModel.fromJson(config);
    final horizontalMargin = model.positionModel?.horizontalMargin?.toDouble() ?? 0;
    final verticalMargin = model.positionModel?.verticalMargin?.toDouble() ?? 0;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PagedListView<int, ChatMessageUiModel>.separated(
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) {
                  if (item.senderIsMe) {
                    if (item.isInvitation) {
                      return UiKitChatOutCard(
                        timeOfDay: item.timeSent,
                        sentByMe: item.senderIsMe,
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
                      timeOfDay: item.timeSent,
                      text: item.message,
                      sentByMe: item.senderIsMe,
                    );
                  } else {
                    return UiKitChatInCard(
                      timeOfDay: item.timeSent,
                      text: item.message,
                    );
                  }
                },
              ),
              separatorBuilder: (context, index) => SpacingFoundation.verticalSpace8,
            ),
          ),
          UiKitCardWrapper(
            child: UiKitInputFieldRightIcon(
              fillColor: context.uiKitTheme?.colorScheme.surface3,
              controller: messageController,
              hintText: 'TYPE HERE',
              icon: GestureDetector(
                onTap: onMessageSent,
                child: GradientableWidget(
                  gradient: GradientFoundation.defaultRadialGradient,
                  child: ImageWidget(
                    svgAsset: GraphicsFoundation.instance.svg.send,

                    /// color has to be provided to make GradientableWidget work
                    color: Colors.white,
                  ),
                ),
              ),
            ).paddingOnly(
              left: horizontalMargin,
              right: horizontalMargin,
              top: verticalMargin,
              bottom: EdgeInsetsFoundation.vertical24,
            ),
          ),
        ],
      ),
    );
  }
}
