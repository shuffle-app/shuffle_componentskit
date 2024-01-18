import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class HallOfFameComponent extends StatelessWidget {
  final List<UiKitAchievementsModel> items;

  const HallOfFameComponent({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return BlurredAppBarPage(title: S.of(context).HallOfFame, autoImplyLeading: true, centerTitle: true, children: [
      SpacingFoundation.verticalSpace16,
      GridView.count(
        crossAxisCount: 3,
        clipBehavior: Clip.hardEdge,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
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
      ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16)
    ]);
  }
}
