import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class HiddenChatMockedComponent extends StatelessWidget {
  final VoidCallback? onJoinChatRequest;

  const HiddenChatMockedComponent({super.key, this.onJoinChatRequest});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final theme = context.uiKitTheme;

    final List<Widget> dialogChildren = [
      Text(
        onJoinChatRequest == null ? S.of(context).YouAskedToBeAddedToTheChat : S.of(context).PrivateChatApply,
        style: theme?.boldTextTheme.title2,
      ),
      SpacingFoundation.verticalSpace14,
      if (onJoinChatRequest != null)
        context.midSizeOutlinedButton(
          data: BaseUiKitButtonData(
            iconWidget: ImageWidget(
              svgAsset: GraphicsFoundation.instance.svg.login,
            ),
            onPressed: onJoinChatRequest,
          ),
        )
      else
        Text(
          S.of(context).WaitAdminResponse,
          style: theme?.boldTextTheme.body,
        ),
    ];

    return SizedBox(
        height: 0.7.sh,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                child: Column(
                  children: List.generate(
                      6,
                      (index) => UiKitChatOutCard(
                            id: index,
                            timeOfDay: today,
                            text:
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer ut est ac massa commodo semper.',
                            sentByMe: index.isEven,
                          )),
                )),
            UiKitCardWrapper(
                border: BorderSide(color: Colors.white, width: 1.0),
                borderRadius: BorderRadiusFoundation.all24,
                padding: EdgeInsets.all(EdgeInsetsFoundation.all24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: dialogChildren,
                ))
          ],
        ));
  }
}
