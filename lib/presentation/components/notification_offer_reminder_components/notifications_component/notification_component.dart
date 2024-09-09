import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class NotificationComponent extends StatelessWidget {
  final String? placeOrEventName;
  final List<UniversalNotOfferRemUiModel?>? listNotification;
  final ValueChanged<int?>? onEditNotification;
  final ValueChanged<int?>? onRemoveNotification;
  final VoidCallback? onCreateNotification;
  late final GlobalKey<SliverAnimatedListState> _listKey;

  NotificationComponent({
    super.key,
    this.placeOrEventName,
    this.listNotification,
    this.onEditNotification,
    this.onRemoveNotification,
    this.onCreateNotification,
  }) {
    _listKey = GlobalKey<SliverAnimatedListState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UniversalFormForNotOfferRem(
        animatedListKey: _listKey,
        title: S.of(context).Notifications,
        itemList: listNotification,
        nameForEmptyList: placeOrEventName,
        onCreateItem: onCreateNotification,
        onEditItem: onEditNotification,
        onRemoveItem: (index) {
          onRemoveNotification?.call(index);

          if (index != null) {
            _listKey.currentState?.removeItem(
              index,
              (context, animation) => SizeTransition(sizeFactor: animation),
            );
          }
        },
        whatCreate: S.of(context).Notification.toLowerCase(),
      ),
    );
  }
}
