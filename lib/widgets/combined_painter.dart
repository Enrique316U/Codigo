import 'package:flutter/material.dart';
import 'dart:math';

class CombinedPainter extends CustomPainter {
  final Color color;

  CombinedPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Dibuja el primer círculo lleno
    canvas.drawCircle(Offset(size.width * 0.9, -size.height * 0.0),
        size.width * 0.6, fillPaint);

    // Dibuja el círculo con borde
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.05),
        size.width * 0.6, strokePaint);

    // Dibuja el primer cuadrado con borde
    final rect1 = Rect.fromLTWH(-size.width * 0.1, size.height * 0.8,
        size.width * 0.5, size.width * 0.7);
    canvas.drawRect(rect1, strokePaint);

    canvas.save();

    canvas.translate(size.width * 0.0, size.height * 0.85);
    canvas.rotate(pi / 6);

    final rect2 = Rect.fromLTWH(-size.width * 0.15, -size.width * 0.15,
        size.width * 0.9, size.width * 0.9);
    canvas.drawRect(rect2, strokePaint);

    // Restaura el estado del canvas
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
