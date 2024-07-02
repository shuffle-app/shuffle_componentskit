import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AllChatsComponent extends StatelessWidget {
  final PagingController<int, ChatItemUiModel> controller;
  final ValueChanged<int> onChatSelected;

  const AllChatsComponent({
    super.key,
    required this.controller,
    required this.onChatSelected,
  });

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;

    final model = ComponentModel.fromJson(config['chats']);
    final horizontalMargin = model.positionModel?.horizontalMargin?.toDouble() ?? EdgeInsetsFoundation.horizontal16;
    final verticalMargin = model.positionModel?.verticalMargin?.toDouble() ?? EdgeInsetsFoundation.vertical16;

    return BlurredAppPageWithPagination<ChatItemUiModel>(
      title: S.of(context).Messages,
      centerTitle: true,
      autoImplyLeading: true,
      paginationController: controller,
      padding: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: verticalMargin),
      builderDelegate: PagedChildBuilderDelegate<ChatItemUiModel>(
        firstPageProgressIndicatorBuilder: (context) => const LoadingWidget().paddingOnly(bottom: 0.2.sh),
        noItemsFoundIndicatorBuilder: (context) => UiKitEmptyListPlaceHolder(
          message: S.of(context).NoMessagesYet,
        ),
        newPageProgressIndicatorBuilder: (context) => UiKitShimmerProgressIndicator(
          gradient: GradientFoundation.greyGradient,
          child: UiKitMessageCard.empty(),
        ),
        itemBuilder: (context, item, index) => UiKitMessageCard(
          name: item.chatTitle,
          subtitle: item.subtitle ?? item.tag?.title ?? '',
          subtitleIconPath: item.tag?.icon,
          lastMessage: item.lastMessage,
          lastMessageTime: item.lastMessageTimeFormatted,
          avatarPath: item.avatarUrl ?? '',
          userType: item.userType,
          onTap: () => onChatSelected.call(item.id),
          unreadMessageCount: item.unreadMessageCount,
        ),
      ),
    );
  }
}
