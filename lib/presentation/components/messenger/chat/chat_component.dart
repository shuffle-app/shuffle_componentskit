import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ChatComponent extends StatelessWidget {
  final TextEditingController messageController;
  final PagingController<int, ChatMessageUiModel> pagingController;

  const ChatComponent({
    Key? key,
    required this.messageController,
    required this.pagingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.red,
          ),
        ),
        UiKitCardWrapper(
          child: UiKitInputFieldRightIcon(
            controller: messageController,
            hintText: '',
          ),
        ),
      ],
    );
  }
}
