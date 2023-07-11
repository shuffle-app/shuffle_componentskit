import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:flutter/material.dart';

class FollowingsComponent extends StatelessWidget {
  final PositionModel? screenParams;
  final List<UiOwnerModel>? followings;
  final List<UiOwnerModel>? followers;
  final onMessage;
  final onFollow;

  const FollowingsComponent(
      {super.key, this.screenParams, this.followings, this.followers, this.onMessage, this.onFollow});

  @override
  Widget build(BuildContext context) {
    final bodyAlignment = screenParams?.bodyAlignment;

    bool _followings = true;

    return BlurredAppBarPage(
        autoImplyLeading: true,
        centerTitle: true,
        title: 'Followings',
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: screenParams?.horizontalMargin?.toDouble() ?? 0,
                vertical: screenParams?.verticalMargin?.toDouble() ?? 0),
            child: StatefulBuilder(
                builder: (context, setState) =>
                    Column(
                        crossAxisAlignment: bodyAlignment.crossAxisAlignment,
                        mainAxisAlignment: bodyAlignment.mainAxisAlignment,
                        children: [
                          SpacingFoundation.verticalSpace24,
                          if (followers != null && followers!.isNotEmpty) ...[
                            UiKitCustomTabBar(
                              onTappedTab: (index) {
                                if (index == 0) {
                                  setState(() {
                                    _followings = true;
                                  });
                                } else if (index == 1) {
                                  setState(() {
                                    _followings = false;
                                  });
                                }
                              },
                              tabs: [
                                UiKitAttitudeTab(
                                    title: 'Followings'.toUpperCase()),
                                UiKitAttitudeTab(
                                    title: 'Followers'.toUpperCase()),
                              ],
                            ),
                            SpacingFoundation.verticalSpace24,
                          ],
                          if (_followings)
                            ...(followings
                                ?.map((e) =>
                                e.buildMenuItem(onMessageTap: onMessage,
                                    onFollowTap: onFollow).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing12))
                                .toList() ??
                                [
                                  Text('nothing found'.toUpperCase(),
                                      style: context.uiKitTheme?.boldTextTheme
                                          .caption1Bold),
                                ])
                          else
                            ...(followers
                                ?.map((e) =>
                                e.buildMenuItem(onMessageTap: onMessage,
                                    onFollowTap: onFollow).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing12))
                                .toList() ??
                                [
                                  Text('nothing found'.toUpperCase(),
                                      style: context.uiKitTheme?.boldTextTheme
                                          .caption1Bold),
                                ]),
                        ]))));
  }
}
