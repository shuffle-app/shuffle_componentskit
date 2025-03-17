import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:shuffle_uikit/foundation/colors_foundation.dart';

class SpeedometerPainter extends CustomPainter {
  final double currentValue;
  static const int _rectCount = 17;

  const SpeedometerPainter({required this.currentValue});

  @override
  void paint(Canvas canvas, Size size) {
    const double startAngle = -math.pi;
    const double sweepAngle = math.pi;
    const double rectWidth = 6;
    const double rectHeight = 13;
    const double radius = 70;

    final Offset center = Offset(size.width / 2, size.height);
    final double activeSegments = currentValue / 10 * _rectCount;

    for (int i = 0; i < _rectCount; i++) {
      Color color = _getSegmentColor(i, activeSegments);

      final Paint paint = Paint()..color = color;
      final double angle = startAngle + (i / (_rectCount - 1)) * sweepAngle;

      final double x = center.dx + radius * math.cos(angle);
      final double y = center.dy + radius * math.sin(angle);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + math.pi / 2);
      canvas.drawRect(Rect.fromLTWH(-rectWidth / 2, 0, rectWidth, rectHeight), paint);
      canvas.restore();
    }
  }

  Color _getSegmentColor(int index, double activeSegments) {
    if (index > activeSegments) return ColorsFoundation.neutral48;

    final int splitIndex = (_rectCount * 0.5).floor();
    Color color;

    if (index < splitIndex) {
      color = Color.lerp(
        Colors.red,
        Colors.yellow,
        index / splitIndex,
      )!;
    } else {
      color = Color.lerp(
        Colors.yellow,
        Colors.green,
        (index - splitIndex) / (_rectCount - splitIndex - 1),
      )!;
    }

    return color.withValues(alpha: 0.7);
  }

  @override
  bool shouldRepaint(covariant SpeedometerPainter oldDelegate) => oldDelegate.currentValue != currentValue;
}
