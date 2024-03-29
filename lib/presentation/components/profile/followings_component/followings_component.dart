import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FollowingsComponent extends StatelessWidget {
  final PositionModel? screenParams;
  final List<UiOwnerModel>? followings;
  final List<UiOwnerModel>? followers;
  final VoidCallback? onMessage;
  final VoidCallback? onFollow;

  const FollowingsComponent({
    super.key,
    this.screenParams,
    this.followings,
    this.followers,
    this.onMessage,
    this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    final bodyAlignment = screenParams?.bodyAlignment;

    bool showFollowings = true;

    return BlurredAppBarPage(
      autoImplyLeading: true,
      centerTitle: true,
      title: S.of(context).Followings,
      children: [
        StatefulBuilder(
          builder: (context, setState) => Column(
            crossAxisAlignment: bodyAlignment.crossAxisAlignment,
            mainAxisAlignment: bodyAlignment.mainAxisAlignment,
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
                    UiKitCustomTab(title: S.of(context).Followings.toUpperCase()),
                    UiKitCustomTab(title: S.of(context).Followers.toUpperCase()),
                  ],
                ),
                SpacingFoundation.verticalSpace24,
              ],
              if ((followings?.isEmpty ?? false) || (followers?.isEmpty ?? false))
                const UiKitEmptyListPlaceHolder().paddingOnly(top: 0.35.sh),
              if (showFollowings)
                ...(followings
                        ?.map((e) => e
                            .buildMenuItem(onMessageTap: onMessage, onFollowTap: onFollow)
                            .paddingSymmetric(vertical: SpacingFoundation.verticalSpacing12))
                        .toList() ??
                    [
                      Text(S.of(context).NothingFound.toUpperCase(), style: context.uiKitTheme?.boldTextTheme.caption1Bold),
                    ])
              else
                ...(followers
                        ?.map((e) => e
                            .buildMenuItem(onMessageTap: onMessage, onFollowTap: onFollow)
                            .paddingSymmetric(vertical: SpacingFoundation.verticalSpacing12))
                        .toList() ??
                    [
                      Text(S.of(context).NothingFound.toUpperCase(), style: context.uiKitTheme?.boldTextTheme.caption1Bold),
                    ]),
            ],
          ),
        ).paddingSymmetric(
          horizontal: screenParams?.horizontalMargin?.toDouble() ?? 0,
        ),
      ],
    );
  }
}
