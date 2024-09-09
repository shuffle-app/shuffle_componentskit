import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class RemindersComponent extends StatelessWidget {
  final String? placeOrEventName;
  final List<UniversalNotOfferRemUiModel?>? listReminders;
  final ValueChanged<int?>? onEditReminder;
  final ValueChanged<int?>? onRemoveReminder;
  final VoidCallback? onCreateReminder;
  late final GlobalKey<SliverAnimatedListState> _listKey;

  RemindersComponent({
    super.key,
    this.placeOrEventName,
    this.listReminders,
    this.onEditReminder,
    this.onRemoveReminder,
    this.onCreateReminder,
  }) {
    _listKey = GlobalKey<SliverAnimatedListState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UniversalFormForNotOfferRem(
        animatedListKey: _listKey,
        title: S.of(context).Reminders,
        itemList: listReminders,
        nameForEmptyList: placeOrEventName,
        onCreateItem: onCreateReminder,
        onEditItem: onEditReminder,
        onRemoveItem: (index) {
          onRemoveReminder?.call(index);

          if (index != null) {
            _listKey.currentState?.removeItem(
              index,
              (context, animation) => SizeTransition(sizeFactor: animation),
            );
          }
        },
        whatCreate: S.of(context).Reminder.toLowerCase(),
      ),
    );
  }
}
