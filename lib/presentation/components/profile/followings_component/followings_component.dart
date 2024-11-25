import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

AutoSizeGroup _group = AutoSizeGroup();

class FollowingsComponent extends StatelessWidget {
  final List<UiOwnerModel>? followings;
  final List<UiOwnerModel>? followers;
  final ValueChanged<int>? onMessage;
  final ValueChanged<int>? onFollow;
  final ValueChanged<int>? onUnfollow;
  final ValueChanged<int>? onBlock;

  const FollowingsComponent({
    super.key,
    this.followings,
    this.followers,
    this.onMessage,
    this.onFollow,
    this.onUnfollow,
    this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    bool showFollowings = true;

    return BlurredAppBarPage(
      autoImplyLeading: true,
      centerTitle: true,
      title: S.of(context).Followings,
      children: [
        StatefulBuilder(
          builder: (context, setState) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (followers != null && followers!.isNotEmpty) ...[
                UiKitCustomTabBar(
                  onTappedTab: (index) {
                    if (index == 0) {
                      setState(() {
                        showFollowings = true;
                      });
                    } else if (index == 1) {
                      setState(() {
                        showFollowings = false;
                      });
                    }
                  },
                  tabs: [
                    UiKitCustomTab(
                      title: S.of(context).Followings.toUpperCase(),
                      group: _group,
                    ),
                    UiKitCustomTab(
                      title: S.of(context).Followers.toUpperCase(),
                      group: _group,
                    ),
                  ],
                ),
                SpacingFoundation.verticalSpace24,
              ],
              if (((followings?.isEmpty ?? false) && showFollowings) ||
                  (followers != null && followers!.isEmpty && !showFollowings))
                const UiKitEmptyListPlaceHolder().paddingOnly(top: 0.35.sh),
              if (showFollowings)
                ...(followings
                        ?.map((e) => GestureDetector(
                            onTap: e.onTap,
                            child: e
                                .buildMenuItem(onMessageTap: onMessage, onUnFollowTap: onUnfollow)
                                .paddingSymmetric(vertical: SpacingFoundation.verticalSpacing12)))
                        .toList() ??
                    [
                      Text(S.of(context).NothingFound.toUpperCase(),
                          style: context.uiKitTheme?.boldTextTheme.caption1Bold),
                    ])
              else
                ...(followers
                        ?.map((e) => GestureDetector(
                            onTap: e.onTap,
                            child: e
                                .buildMenuItem(
                                    onMessageTap: onMessage,
                                    onFollowTap:
                                        [UserTileType.pro, UserTileType.influencer].contains(e.type) ? onFollow : null,
                                    onBlockTap: onBlock)
                                .paddingSymmetric(vertical: SpacingFoundation.verticalSpacing12)))
                        .toList() ??
                    [
                      Text(S.of(context).NothingFound.toUpperCase(),
                          style: context.uiKitTheme?.boldTextTheme.caption1Bold),
                    ]),
            ],
          ),
        ).paddingSymmetric(
          horizontal: SpacingFoundation.horizontalSpacing16,
          vertical: SpacingFoundation.verticalSpacing12,
        ),
      ],
    );
  }
}
