import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CornerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10.w
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double cornerRadius = 20.w;
    double lineLength = 50.w;

    /// Upper left corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cornerRadius, cornerRadius), radius: cornerRadius),
      -3.14,
      1.57,
      false,
      paint,
    );
    canvas.drawLine(Offset(cornerRadius, 0), Offset(lineLength, 0), paint);
    canvas.drawLine(Offset(0, cornerRadius), Offset(0, lineLength), paint);

    /// Upper right corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width - cornerRadius, cornerRadius), radius: cornerRadius),
      -1.57,
      1.57,
      false,
      paint,
    );
    canvas.drawLine(Offset(size.width - cornerRadius, 0), Offset(size.width - lineLength, 0), paint);
    canvas.drawLine(Offset(size.width, cornerRadius), Offset(size.width, lineLength), paint);

    /// Lower left corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cornerRadius, size.height - cornerRadius), radius: cornerRadius),
      3.14,
      -1.57,
      false,
      paint,
    );
    canvas.drawLine(Offset(0, size.height - cornerRadius), Offset(0, size.height - lineLength), paint);
    canvas.drawLine(Offset(cornerRadius, size.height), Offset(lineLength, size.height), paint);

    /// Lower right corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width - cornerRadius, size.height - cornerRadius), radius: cornerRadius),
      0,
      1.57,
      false,
      paint,
    );
    canvas.drawLine(
        Offset(size.width - cornerRadius, size.height), Offset(size.width - lineLength, size.height), paint);
    canvas.drawLine(
        Offset(size.width, size.height - cornerRadius), Offset(size.width, size.height - lineLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
