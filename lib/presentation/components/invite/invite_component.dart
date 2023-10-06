import 'package:flutter/cupertino.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class InviteComponent extends StatefulWidget {
  const InviteComponent({
    super.key,
    required this.scrollController,
    required this.initialList,
    required this.onPagination,
  });

  final ScrollController scrollController;
  final List<MyCustomModel> initialList;
  final List<MyCustomModel> Function(int lastElementIndex) onPagination;

  @override
  State<InviteComponent> createState() => _InviteComponentState();
}

class _InviteComponentState extends State<InviteComponent> {
  final int itemsPerPage = 5;
  int currentTile = 0;

  @override
  void initState() {
    super.initState();
    widget.onPagination.call(currentTile);
    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (widget.scrollController.offset >= widget.scrollController.position.maxScrollExtent &&
        !widget.scrollController.position.outOfRange) {
      setState(() => currentTile += 5);
      widget.onPagination.call(currentTile);
    }
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacingFoundation.verticalSpace16,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Invite people', style: boldTextTheme?.subHeadline),
            context.gradientButton(
              data: BaseUiKitButtonData(
                onPressed: () {},
                text: 'invite',
              ),
            ),
          ],
        ),
        ListView.separated(
          itemCount: widget.initialList.length,
          itemBuilder: (_, index) => UiKitUserTileWithCheckbox(
            title: 'Some Name',
            onTap: () {},
            rating: 4,
            avatarLink: GraphicsFoundation.instance.png.mockUserAvatar.path,
          ),
          separatorBuilder: (_, __) => SpacingFoundation.verticalSpace16,
        ),
      ],
    ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16);
  }
}

class MyCustomModel {
  MyCustomModel({
    required this.name,
    required this.surname,
  });

  String name;
  String surname;
}
