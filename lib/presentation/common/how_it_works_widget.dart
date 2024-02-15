import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../domain/data_uimodels/hint_card_ui_model.dart';

class HowItWorksWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<HintCardUiModel> hintTiles;
  final Offset? customOffset;

  // final
  final VoidCallback? onPop;

  const HowItWorksWidget({
    super.key,
    required this.subtitle,
    required this.title,
    required this.hintTiles,
    this.onPop,
    this.customOffset,
  });

  _howItWorksDialog(_, textStyle) => UiKitHintDialog(
        title: title,
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
                  height: 74.h,
                  fit: BoxFit.fitHeight,
                ),
              ),
            )
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // final model

    // final

    return Transform.translate(
      offset: customOffset ?? Offset(size.width / 1.7, 35),
      child: Transform.rotate(
        angle: pi * -20 / 180,
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
      ),
    );
  }
}
