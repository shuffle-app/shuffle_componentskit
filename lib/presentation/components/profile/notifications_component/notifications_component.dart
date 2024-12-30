import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NotificationsComponent extends StatelessWidget {
  final PositionModel? screenParams;
  final VoidCallback seeAllNotificationsCallback;
  final List<UiKitGradientSwitchTile>? params;
  final bool hasNotifications;

  const NotificationsComponent({
    super.key,
    this.screenParams,
    this.hasNotifications = false,
    required this.seeAllNotificationsCallback,
    this.params,
  });

  @override
  Widget build(BuildContext context) {
    return BlurredAppBarPage(
      physics: const NeverScrollableScrollPhysics(),
      customTitle: Flexible(
        child: AutoSizeText(
          S.of(context).Notifications,
          style: context.uiKitTheme?.boldTextTheme.title1,
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
      autoImplyLeading: true,
      centerTitle: true,
      childrenPadding: EdgeInsets.only(
        bottom: screenParams?.verticalMargin?.toDouble() ?? 0,
        left: screenParams?.horizontalMargin?.toDouble() ?? 0,
        right: screenParams?.horizontalMargin?.toDouble() ?? 0,
      ),
      children: [
        SpacingFoundation.zero.heightBox,
        if (hasNotifications)
          UiKitDecoratedActionCard(
            title: S.of(context).Notifications,
            action: context.smallButton(
              data: BaseUiKitButtonData(
                onPressed: seeAllNotificationsCallback,
                text: S.of(context).SeeAll.toUpperCase(),
              ),
            ),
            decorationIcons: [
              ActionCardDecorationIconData(
                iconLink: GraphicsFoundation.instance.svg.networking.path,
                // icon: ShuffleUiKitIcons.networking,
                position: DecorationIconPosition(
                  right: 42,
                  top: -5,
                ),
                iconSize: 92,
              ),
              ActionCardDecorationIconData(
                iconLink: GraphicsFoundation.instance.svg.bellNotification.path,
                // icon: ShuffleUiKitIcons.bellnotification,
                position: DecorationIconPosition(
                  right: 0,
                  top: 4,
                ),
                rotationAngle: 24,
              ),
            ],
          ),
        ...params ?? [],
      ],
    );
  }
}
