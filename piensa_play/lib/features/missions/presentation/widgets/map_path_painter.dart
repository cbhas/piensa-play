import 'package:flutter/material.dart';

class MapPathPainter extends CustomPainter {
  final List<Offset> points;
  final Color pathColor;

  MapPathPainter({
    required this.points,
    this.pathColor = const Color(0xFFD4C5A0),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = pathColor
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    // Create curved path through all points
    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];

      final controlPoint1 = Offset(
        current.dx + (next.dx - current.dx) / 3,
        current.dy,
      );
      final controlPoint2 = Offset(
        current.dx + 2 * (next.dx - current.dx) / 3,
        next.dy,
      );

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        next.dx,
        next.dy,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MapPathPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.pathColor != pathColor;
  }
}
