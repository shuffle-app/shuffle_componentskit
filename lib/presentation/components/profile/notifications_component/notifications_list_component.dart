import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class NotificationsListComponent extends StatelessWidget {
  final List<Widget> notifications;
  final Function(int) onDismissed;
  final GlobalKey<SliverAnimatedListState> listKey;
  final PositionModel? screenParams;

  const NotificationsListComponent(
      {super.key, required this.listKey, required this.notifications, required this.onDismissed, this.screenParams});

  @override
  Widget build(BuildContext context) {
    final horizontalMargin = screenParams?.horizontalMargin?.toDouble() ?? 0;

    // listKey.currentState.

    return Column(children: [
      Text(S.of(context).Notifications, style: context.uiKitTheme?.boldTextTheme.subHeadline)
          .paddingSymmetric(vertical: SpacingFoundation.verticalSpacing16),
      AnimatedList(
        key: listKey,
        physics: const NeverScrollableScrollPhysics(),
        initialItemCount: notifications.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index, Animation<double> animation) {
          return ScaleTransition(
              scale: animation,
              child: Dismissible(
                  key: ValueKey(notifications[index]),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => onDismissed.call(index),
                  child: notifications[index]
                      .paddingSymmetric(horizontal: horizontalMargin, vertical: SpacingFoundation.verticalSpacing8)));
        },
      )
    ]);
  }
}
