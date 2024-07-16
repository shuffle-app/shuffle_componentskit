import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class GradientCircleWithSegmentedRingPainter extends CustomPainter {
  final Gradient? customGradietn;
  final int level;

  GradientCircleWithSegmentedRingPainter({
    super.repaint,
    this.customGradietn,
    this.level = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 1.5;

    // Background circle
    final backgroundPaint = Paint()
      ..color = ColorsFoundation.surface1
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius + 5, backgroundPaint);

    // Gradient circle
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = customGradietn ?? GradientFoundation.bronzeGradient;

    final gradientPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    // Circle with segment
    final ringPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5; // Толщина кольца

    final transparentRingPaint = Paint()
      ..color = ColorsFoundation.surface5
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
