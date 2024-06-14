import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'ui_model_view_history_accrual.dart';

class ViewHistoryAccrualComponent extends StatelessWidget {
  const ViewHistoryAccrualComponent({
    super.key,
    this.accrualList,
  });

  final List<UiModelViewHistoryAccrual>? accrualList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: EdgeInsetsFoundation.vertical16),
      child: Column(
        children: List.generate(
          accrualList?.length ?? 0,
          (index) {
            return UiKitViewHistoryTile(
              isLast: index == accrualList!.length - 1,
              title: accrualList?[index].title ?? '',
              points: accrualList?[index].points ?? 0,
              dateTime: accrualList?[index].date ?? DateTime.now(),
            );
          },
        ),
      ),
    );
  }
}
