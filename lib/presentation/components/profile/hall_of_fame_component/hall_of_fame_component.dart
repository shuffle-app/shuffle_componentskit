import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class HallOfFameComponent extends StatelessWidget {
  final List<UiKitAchievementsModel> items;

  const HallOfFameComponent({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return BlurredAppBarPage(title: S.of(context).HallOfFame, autoImplyLeading: true, centerTitle: true, children: [
      GridView.count(
        crossAxisCount: 3,
        addAutomaticKeepAlives: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
            horizontal: SpacingFoundation.horizontalSpacing16, vertical: SpacingFoundation.verticalSpacing16),
        childAspectRatio: 0.56.sp,
        crossAxisSpacing: SpacingFoundation.verticalSpacing8,
        children: items
            .map((e) => GridTitledItemWidget(
                  title: e.title,
                  child: UiKitFameItem(
                    asset: e.asset,
                  ),
                ))
            .toList(),
      ),
      kBottomNavigationBarHeight.heightBox
    ]);
  }
}
