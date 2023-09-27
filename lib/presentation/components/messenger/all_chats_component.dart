import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AllChatsComponent extends StatelessWidget {
  final PagingController<int, ChatItemUiModel> controller;
  final ValueChanged<int> onChatSelected;

  const AllChatsComponent({
    Key? key,
    required this.controller,
    required this.onChatSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;

    final model = ComponentModel.fromJson(config['chats']);
    final horizontalMargin = model.positionModel?.horizontalMargin?.toDouble() ?? EdgeInsetsFoundation.horizontal16;
    final verticalMargin = model.positionModel?.verticalMargin?.toDouble() ?? EdgeInsetsFoundation.vertical16;

    return PagedListView<int, ChatItemUiModel>.separated(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
        vertical: verticalMargin,
      ),
      pagingController: controller,
      separatorBuilder: (context, index) => SpacingFoundation.verticalSpace16,
      builderDelegate: PagedChildBuilderDelegate<ChatItemUiModel>(
        itemBuilder: (context, item, index) {
          return UiKitMessageCard(
            name: item.username,
            username: item.nickname,
            lastMessage: item.lastMessage,
            lastMessageTime: item.lastMessageTimeFormatted,
            avatarPath: item.avatarUrl ?? '',
            userType: item.userType,
            onTap: () => onChatSelected.call(item.id),
            unreadMessageCount: item.unreadMessageCount,
          );
        },
      ),
    );
  }
}
