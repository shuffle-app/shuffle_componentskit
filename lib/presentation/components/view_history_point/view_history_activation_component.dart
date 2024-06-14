import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../components.dart';

class ViewHistoryActivationComponent extends StatelessWidget {
  const ViewHistoryActivationComponent({super.key, this.activationList, required this.onTap});
  final List<UiModelFavoritesMergeComponent>? activationList;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final uiKitTheme = context.uiKitTheme;
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          activationList?.length ?? 0,
          (index) {
            return Column(
              children: [
                SpacingFoundation.verticalSpace16,
                Row(
                  children: [
                    Expanded(
                      child: UiKitExtendedInfluencerFeedbackCardWithoutBottom(
                        imageUrl: activationList?[index].imageUrl,
                        title: activationList?[index].title,
                        tags: activationList?[index].tags,
                      ),
                    ),
                    SpacingFoundation.horizontalSpace8,
                    context.iconButtonNoPadding(
                      data: BaseUiKitButtonData(
                        onPressed: onTap,
                        iconInfo: BaseUiKitButtonIconData(
                          iconData: ShuffleUiKitIcons.barcode
                        )
                      ),
                    )
                  ],
                ),
                SpacingFoundation.verticalSpace16,
                if (index != activationList!.length - 1)
                  Divider(color: uiKitTheme?.colorScheme.surface2, thickness: 2)
              ],
            );
          },
        ),
      ),
    );
  }
}
