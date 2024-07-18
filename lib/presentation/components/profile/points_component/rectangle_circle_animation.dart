import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:shuffle_uikit/shuffle_uikit.dart';

class TriangleAnimation extends StatefulWidget {
  const TriangleAnimation({super.key});

  @override
  TriangleAnimationState createState() => TriangleAnimationState();
}

class TriangleAnimationState extends State<TriangleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final double sizeOfTriangle = 40.h;
  final double radius = 1.sw <= 380 ? 20.0 : 25.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: TrianglePainter(
            _animation.value,
            sizeOfTriangle,
            radius,
          ),
          size: Size(sizeOfTriangle, sizeOfTriangle),
        );
      },
    );
  }
}

class TrianglePainter extends CustomPainter {
  final double progress;
  final double size;
  final double radius;
  final Paint circlePaint1;
  final Paint circlePaint2;
  final Paint circlePaint3;

  TrianglePainter(
    this.progress,
    this.size,
    this.radius,
  )   : circlePaint1 = Paint()..color = ColorsFoundation.pink.withOpacity(0.8),
        circlePaint2 = Paint()..color = ColorsFoundation.info.withOpacity(0.8),
        circlePaint3 = Paint()
          ..color = ColorsFoundation.yellow.withOpacity(0.8);

  @override
  void paint(Canvas canvas, Size size) {
    final double halfSize = this.size / 2;
    final Offset p1 = Offset(halfSize, 40);
    final Offset p2 = Offset(-10, this.size);
    final Offset p3 = Offset(this.size + 10, this.size);

    final List<Offset> points = [p1, p2, p3];
    final List<Paint> paints = [circlePaint1, circlePaint2, circlePaint3];

    // Draw a triangle
    final Path path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.transparent);

    // We define the current points for each circle
    final int segmentCount = points.length;
    for (int i = 0; i < segmentCount; i++) {
      final int currentSegment = (((progress * 3) + i) % 3).toInt();
      final double localProgress = (progress * 3 + i) % 1;

      final Offset start = points[currentSegment];
      final Offset end = points[(currentSegment + 1) % 3];

      // Calculating the current position of the circle
      final double dx = start.dx + (end.dx - start.dx) * localProgress;
      final double dy = start.dy + (end.dy - start.dy) * localProgress;

      canvas.drawCircle(
        Offset(dx, dy),
        radius,
        paints[i]
          ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 35),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
