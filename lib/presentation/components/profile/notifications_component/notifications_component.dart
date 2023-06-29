import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:flutter/material.dart';

class NotificationsComponent extends StatelessWidget {
  final PositionModel? screenParams;
  final VoidCallback seeAllNotificationsCallback;
  final List<UiKitGradientSwitchTile>? params;
  final bool hasNotifications;

  const NotificationsComponent(
      {super.key,
      this.screenParams,
        this.hasNotifications = false,
      required this.seeAllNotificationsCallback,
      this.params});

  @override
  Widget build(BuildContext context) {
    final bodyAlignment = screenParams?.bodyAlignment;

    return BlurredAppBarPage(
        physics: const NeverScrollableScrollPhysics(),
        title: 'Notifications',
        autoImplyLeading: true,
        centerTitle: true,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: bodyAlignment.crossAxisAlignment,
            children: [
              if(hasNotifications)
              UiKitDecoratedActionCard(
                title: 'Notifications',
                action: context.smallButton(
                  data: BaseUiKitButtonData(
                    onPressed: seeAllNotificationsCallback,
                    text: 'SEE ALL',
                  ),
                ),
                decorationIcons: [
                  ActionCardDecorationIconData(
                    iconLink: GraphicsFoundation.instance.svg.networking.path,
                    position: DecorationIconPosition(
                      right: 42,
                      top: -5,
                    ),
                    iconSize: 92,
                  ),
                  ActionCardDecorationIconData(
                    iconLink:
                        GraphicsFoundation.instance.svg.bellNotification.path,
                    position: DecorationIconPosition(
                      right: 0,
                      top: 4,
                    ),
                    rotationAngle: 24,
                  ),
                ],
              ),
              ...?params
            ]).paddingSymmetric(
          vertical: screenParams?.verticalMargin?.toDouble() ?? 0,
          horizontal: screenParams?.horizontalMargin?.toDouble() ?? 0,
        ));
  }
}
