import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../domain/data_uimodels/hint_card_ui_model.dart';

class HowItWorksWidget extends StatelessWidget {
  final String title;
  final Widget? customTitle;
  final String subtitle;
  final List<HintCardUiModel> hintTiles;

  // final
  final VoidCallback? onPop;

  const HowItWorksWidget({
    super.key,
    required this.subtitle,
    required this.title,
    required this.hintTiles,
    this.customTitle,
    this.onPop,
  });

  _howItWorksDialog(_, textStyle) => UiKitHintDialog(
        title: title,
        customTitle: customTitle,
        subtitle: subtitle,
        textStyle: textStyle,
        dismissText: S.current.OkayCool.toUpperCase(),
        onDismiss: () {
          onPop?.call();

          return Navigator.pop(_);
        },
        hintTiles: hintTiles
            .map<UiKitIconHintCard>(
              (e) => UiKitIconHintCard(
                hint: e.title,
                icon: ImageWidget(
                  link: e.imageUrl,
                  height: 60.h,
                  fit: BoxFit.fitHeight,
                ),
              ),
            )
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pi * -10 / 180,
      child: RotatableWidget(
        animDuration: const Duration(milliseconds: 150),
        endAngle: pi * 20 / 180,
        alignment: Alignment.center,
        applyReverseOnEnd: true,
        startDelay: Duration(seconds: Random().nextInt(8) + 2),
        child: UiKitBlurredQuestionChip(
          label: S.of(context).HowItWorks,
          onTap: () => showUiKitFullScreenAlertDialog(
            context,
            child: _howItWorksDialog,
            paddingAll: EdgeInsetsFoundation.all12,
          ),
        ),
      ),
    );
  }
}
