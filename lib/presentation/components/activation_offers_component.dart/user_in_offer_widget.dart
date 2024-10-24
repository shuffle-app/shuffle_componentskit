import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/notification_offer_reminder_components/users_of_offer.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UserInOfferWidget extends StatelessWidget {
  final UsersOfOffer? offerUser;
  final ValueChanged<UsersOfOffer>? onDetailsTap;

  const UserInOfferWidget({
    super.key,
    this.offerUser,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    return Row(
      children: [
        context.userAvatar(
          size: UserAvatarSize.x40x40,
          type: offerUser?.user?.userTileType ?? UserTileType.ordinary,
          userName: '',
          imageUrl: offerUser?.user?.avatarUrl,
        ),
        SpacingFoundation.horizontalSpace16,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offerUser?.user?.name ?? S.of(context).NothingFound,
              style: boldTextTheme?.caption1Medium,
            ),
            Text(
              offerUser?.user?.nickname ?? S.of(context).NothingFound,
              style: boldTextTheme?.caption1Bold.copyWith(color: ColorsFoundation.mutedText),
            ),
          ],
        ),
        const Spacer(),
        if (onDetailsTap != null)
          PopupMenuButton(
            icon: const ImageWidget(iconData: ShuffleUiKitIcons.morevert),
            splashRadius: 1,
            menuPadding: EdgeInsets.all(EdgeInsetsFoundation.all24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusFoundation.all16,
            ),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: offerUser,
                child: Text(
                  S.of(context).Details,
                  style: boldTextTheme?.caption2Medium.copyWith(color: Colors.black),
                ),
              ),
            ],
            onSelected: onDetailsTap,
          )
      ],
    );
  }
}
