import 'dart:math';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class HowItWorksWidget extends StatelessWidget {
  final ContentBaseModel element;
  final Offset? customOffset;

  // final
  final VoidCallback? onPop;

  const HowItWorksWidget({super.key, required this.element, this.onPop, this.customOffset});

  _howItWorksDialog(_, textStyle) => UiKitHintDialog(
        title: element.title?[ContentItemType.text]?.properties?.keys.first ?? 'Depending on...',
        subtitle: element.body?[ContentItemType.text]?.properties?.keys.first ?? 'you get exactly what you need',
        textStyle: textStyle,
        dismissText: 'OKAY, COOL!',
        onDismiss: () {
          onPop?.call();

          return Navigator.pop(_);
        },
        hintTiles: () {
          final list = element.properties?.entries.map((e) {
                return UiKitIconHintCard(
                  icon: ImageWidget(
                    height: 74.h,
                    fit: BoxFit.fitHeight,
                    link: e.value.imageLink,
                  ),
                  hint: e.key,
                );
              }).toList() ??
              [];

          list.sort((a, b) =>
              (element.properties?[a.hint]?.sortNumber ?? 0).compareTo(element.properties?[b.hint]?.sortNumber ?? 0));

          return list;
        }(),
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            label: 'How it\nworks',
            onTap: () => showUiKitFullScreenAlertDialog(context,
                child: _howItWorksDialog, paddingAll: EdgeInsetsFoundation.all12),
          ),
        ),
      ),
    );
  }
}
