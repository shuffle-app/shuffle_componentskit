import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/domain.dart';
import 'package:shuffle_components_kit/presentation/components/notification_offer_reminder_components/offer_content_card.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ViewHistoryActivationWidget extends StatelessWidget {
  const ViewHistoryActivationWidget({super.key, this.activationModel, required this.onTap});

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
              child: OfferContentCard(
                imageUrl: activationModel?.imageUrl,
                title: activationModel?.title,
                contentTitle: activationModel?.contentTitle,
              ),
            ),
            SpacingFoundation.horizontalSpace8,
            context.iconButtonNoPadding(
              data: BaseUiKitButtonData(
                onPressed: onTap,
                iconInfo: BaseUiKitButtonIconData(iconData: ShuffleUiKitIcons.barcode),
              ),
            )
          ],
        ),
        SpacingFoundation.verticalSpace16,
        Divider(color: uiKitTheme?.colorScheme.surface2, thickness: 2)
      ],
    );
  }
}
