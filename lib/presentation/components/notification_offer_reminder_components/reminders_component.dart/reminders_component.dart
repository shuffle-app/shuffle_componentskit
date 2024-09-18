import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class RemindersComponent extends StatelessWidget {
  final String? placeOrEventName;
  final List<UniversalNotOfferRemUiModel?>? listReminders;
  final ValueChanged<int?>? onEditReminder;
  final ValueChanged<int?>? onRemoveReminder;
  final VoidCallback? onCreateReminder;
  final GlobalKey<SliverAnimatedListState> listKey;

  const RemindersComponent({
    super.key,
    required this.listKey,
    this.placeOrEventName,
    this.listReminders,
    this.onEditReminder,
    this.onRemoveReminder,
    this.onCreateReminder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UniversalFormForNotOfferRem(
        animatedListKey: listKey,
        title: S.of(context).Reminders,
        itemList: listReminders,
        nameForEmptyList: placeOrEventName,
        onCreateItem: onCreateReminder,
        onEditItem: onEditReminder,
        onRemoveItem: onRemoveReminder,
        whatCreate: S.of(context).Reminder.toLowerCase(),
      ),
    );
  }
}
