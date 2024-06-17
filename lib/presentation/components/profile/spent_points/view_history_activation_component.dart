import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/domain.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../components.dart';

class ViewHistoryActivationComponent extends StatelessWidget {
  const ViewHistoryActivationComponent(
      {super.key, this.activationModel, required this.onTap});

  final ContentShortUiModel? activationModel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final uiKitTheme = context.uiKitTheme;
    return Column(
      children: [
        SpacingFoundation.verticalSpace16,
        Row(
          children: [
            Expanded(
              child: UiKitExtendedInfluencerFeedbackCardWithoutBottom(
                imageUrl: activationModel?.imageUrl,
                title: activationModel?.title,
                tags: activationModel?.tags,
              ),
            ),
            SpacingFoundation.horizontalSpace8,
            context.iconButtonNoPadding(
              data: BaseUiKitButtonData(
                  onPressed: onTap,
                  iconInfo: BaseUiKitButtonIconData(
                      iconData: ShuffleUiKitIcons.barcode)),
            )
          ],
        ),
        SpacingFoundation.verticalSpace16,
        Divider(color: uiKitTheme?.colorScheme.surface2, thickness: 2)
      ],
    );
  }
}
