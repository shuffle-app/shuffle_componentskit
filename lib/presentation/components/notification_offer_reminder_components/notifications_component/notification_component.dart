import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class NotificationComponent extends StatelessWidget {
  final String? placeOrEventName;
  final List<UniversalNotOfferRemUiModel?>? listNotification;
  final ValueChanged<int?>? onEditNotification;
  final ValueChanged<int?>? onRemoveNotification;
  final VoidCallback? onCreateNotification;

  const NotificationComponent({
    super.key,
    this.placeOrEventName,
    this.listNotification,
    this.onEditNotification,
    this.onRemoveNotification,
    this.onCreateNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UniversalFormForNotOfferRem(
        title: S.of(context).Notifications,
        itemList: listNotification,
        nameForEmptyList: placeOrEventName,
        onCreateItem: onCreateNotification,
        onEditItem: onEditNotification,
        onRemoveItem: onRemoveNotification,
        whatCreate: S.of(context).Notification.toLowerCase(),
      ),
    );
  }
}
