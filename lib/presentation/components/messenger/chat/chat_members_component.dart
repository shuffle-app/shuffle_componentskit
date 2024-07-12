import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_uikit/ui_kit/molecules/tiles/user/ui_kit_chat_member_tile.dart';

class ChatMembersComponent extends StatelessWidget {
  final List<ChatMemberModel> members;
  final ValueChanged<ChatMemberModel>? onDelete;
  final bool canDeleteUsers;

  const ChatMembersComponent({
    Key? key,
    required this.members,
    required this.canDeleteUsers,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: ImageWidget(
            iconData: ShuffleUiKitIcons.cross,
            color: colorScheme?.inverseSurface,
            height: 19.h,
            fit: BoxFit.fitHeight,
          ),
        ),
        SpacingFoundation.verticalSpace16,
        UiKitCardWrapper(
          padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
          borderRadius: BorderRadiusFoundation.all24,
          color: colorScheme?.inverseSurface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                S.current.InvitedPeople,
                style: boldTextTheme?.title2.copyWith(color: colorScheme?.surface),
              ),
              SpacingFoundation.verticalSpace16,
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 0.25.sh,
                  maxHeight: 0.5.sh,
                ),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final member = members.elementAt(index);

                    return UiKitChatMemberUserTile(
                      name: member.name,
                      invertThemeColors: true,
                      nickname: member.username,
                      userType: member.userType,
                      acceptedInvite: member.inviteAccepted ?? false,
                      canDelete: canDeleteUsers,
                      onDelete: () => onDelete?.call(member),
                    );
                  },
                  separatorBuilder: (context, index) => SpacingFoundation.verticalSpace8,
                  itemCount: members.length,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
