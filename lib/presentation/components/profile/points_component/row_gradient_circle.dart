import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/profile/points_component/gradient_circle_with_segment_ring_pinter.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class RowGradientCircle extends StatelessWidget {
  final int level;

  const RowGradientCircle({
    super.key,
    this.level = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: level - 3 >= 0
                ? [
                    BoxShadow(
                      color: theme!.colorScheme.inversePrimary.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 5,
                    )
                  ]
                : null,
          ),
          child: CustomPaint(
            size: const Size(8, 8),
            painter: GradientCircleWithSegmentedRingPainter(
              theme: theme,
              customGradietn: GradientFoundation.bronzeGradient,
              level: level,
            ),
          ),
        ),
        SpacingFoundation.horizontalSpace20,
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: level - 6 >= 0
                ? [
                    BoxShadow(
                      color: theme!.colorScheme.inversePrimary.withOpacity(0.8),
                      blurRadius: 10,
                      spreadRadius: 5,
                    )
                  ]
                : null,
          ),
          child: CustomPaint(
            size: const Size(8, 8),
            painter: GradientCircleWithSegmentedRingPainter(
              theme: theme,
              customGradietn: GradientFoundation.silverGradient,
              level: level - 3,
            ),
          ),
        ),
        SpacingFoundation.horizontalSpace20,
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: level - 9 >= 0
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      blurRadius: 10,
                      spreadRadius: 5,
                    )
                  ]
                : null,
          ),
          child: CustomPaint(
            size: const Size(8, 8),
            painter: GradientCircleWithSegmentedRingPainter(
              theme: theme,
              customGradietn: GradientFoundation.goldGradient,
              level: level - 6,
            ),
          ),
        ),
      ],
    );
  }
}
