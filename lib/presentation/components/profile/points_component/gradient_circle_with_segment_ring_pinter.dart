import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class GradientCircleWithSegmentedRingPainter extends CustomPainter {
  final Gradient? customGradient;
  final int level;
  final UiKitThemeData? theme;

  GradientCircleWithSegmentedRingPainter({
    super.repaint,
    this.customGradient,
    this.level = 0,
    this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 1.sw <= 380 ? (size.width / 2) : (size.width / 1.5); //small

    // Background circle
    final backgroundPaint = Paint()
      ..color = theme?.colorScheme.surface1 ?? ColorsFoundation.surface1
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius + 5, backgroundPaint);

    // Gradient circle
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = customGradient ?? GradientFoundation.bronzeGradient;

    final gradientPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    // Circle with segment
    final ringPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5; // Толщина кольца

    final transparentRingPaint = Paint()
      ..color = theme?.colorScheme.surface5 ?? ColorsFoundation.surface5
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Distance from the circle
    final ringRadius = radius + 4.5;

    // The angle of each segment
    const segmentAngle = 2 * pi / 3;
    //The angle of the gap between the segments
    const gapAngle = 0.4; //
    //Angle of rotation
    const rotationAngle = 4.5;

    for (int i = 0; i < 3; i++) {
      final startAngle = i * segmentAngle - rotationAngle;
      final endAngle = startAngle + segmentAngle - gapAngle;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: ringRadius),
        startAngle,
        endAngle - startAngle,
        false,
        i >= level ? transparentRingPaint : ringPaint,
      );

      if (i <= level - 3) {
        canvas.drawCircle(center, radius, gradientPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
