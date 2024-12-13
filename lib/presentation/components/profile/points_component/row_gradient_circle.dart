import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/profile/points_component/gradient_circle_with_segment_ring_pinter.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class RowGradientCircle extends StatelessWidget {
  final int level;
  final int progressInCircle;

  const RowGradientCircle({
    super.key,
    this.level = 0,
    this.progressInCircle = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: level >= 1
                ? [
                    BoxShadow(
                      color: theme!.colorScheme.inversePrimary.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 8,
                    )
                  ]
                : null,
          ),
          child: CustomPaint(
            size: const Size(8, 8),
            painter: GradientCircleWithSegmentedRingPainter(
              theme: theme,
              customGradient: GradientFoundation.bronzeGradient,
              level: level >= 1 ? 4 : progressInCircle,
            ),
          ),
        ),
        SpacingFoundation.horizontalSpace20,
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: level >= 2
                ? [
                    BoxShadow(
                      color: theme!.colorScheme.inversePrimary.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 8,
                    )
                  ]
                : null,
          ),
          child: CustomPaint(
            size: const Size(8, 8),
            painter: GradientCircleWithSegmentedRingPainter(
              theme: theme,
              customGradient: GradientFoundation.silverGradient,
              level: level < 1
                  ? 0
                  : level >= 2
                      ? 4
                      : progressInCircle - 400,
            ),
          ),
        ),
        SpacingFoundation.horizontalSpace20,
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: level > 2
                ? [
                    BoxShadow(
                      color: theme!.colorScheme.inversePrimary.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 8,
                    )
                  ]
                : null,
          ),
          child: CustomPaint(
            size: const Size(8, 8),
            painter: GradientCircleWithSegmentedRingPainter(
              theme: theme,
              customGradient: GradientFoundation.goldGradient,
              level: level < 2
                  ? 0
                  : level >= 3
                      ? 4
                      : progressInCircle - 800,
            ),
          ),
        ),
      ],
    );
  }
}
