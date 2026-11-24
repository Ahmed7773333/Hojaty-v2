import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// Subtle 8-point Islamic star lattice with a double ornamental frame.
class DailyStoryGeometricPainter extends CustomPainter {
  final Color patternColor;
  final Color frameColor;

  const DailyStoryGeometricPainter({
    required this.patternColor,
    required this.frameColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 360;
    _paintLattice(canvas, size, unit);
    _paintFrame(canvas, size, unit);
  }

  void _paintLattice(Canvas canvas, Size size, double unit) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9 * unit
      ..color = patternColor;
    final cell = 60 * unit;
    final radius = 17 * unit;

    var row = 0;
    for (var y = 0.0; y <= size.height + cell; y += cell, row++) {
      final offsetX = row.isOdd ? cell / 2 : 0.0;
      for (var x = -cell; x <= size.width + cell; x += cell) {
        canvas.drawPath(_starPath(Offset(x + offsetX, y), radius), paint);
      }
    }
  }

  /// Two overlapping squares rotated 45° (the classic Rub el Hizb star).
  Path _starPath(Offset center, double radius) {
    final path = Path();
    const points = 16;
    for (var i = 0; i < points; i++) {
      final angle = i * math.pi / 8 - math.pi / 2;
      final r = i.isEven ? radius : radius * 0.72;
      final point = center + Offset(math.cos(angle) * r, math.sin(angle) * r);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    return path..close();
  }

  void _paintFrame(Canvas canvas, Size size, double unit) {
    final outer = Rect.fromLTRB(
      18 * unit,
      18 * unit,
      size.width - 18 * unit,
      size.height - 18 * unit,
    );
    final inner = outer.deflate(6 * unit);

    canvas.drawRRect(
      RRect.fromRectAndRadius(outer, Radius.circular(12 * unit)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 * unit
        ..color = frameColor,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(inner, Radius.circular(8 * unit)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6 * unit
        ..color = frameColor,
    );

    final diamond = Paint()..color = frameColor;
    final half = 4 * unit;
    for (final corner in [
      outer.topLeft,
      outer.topRight,
      outer.bottomLeft,
      outer.bottomRight,
    ]) {
      canvas.drawPath(
        Path()
          ..moveTo(corner.dx, corner.dy - half)
          ..lineTo(corner.dx + half, corner.dy)
          ..lineTo(corner.dx, corner.dy + half)
          ..lineTo(corner.dx - half, corner.dy)
          ..close(),
        diamond,
      );
    }
  }

  @override
  bool shouldRepaint(DailyStoryGeometricPainter oldDelegate) =>
      oldDelegate.patternColor != patternColor ||
      oldDelegate.frameColor != frameColor;
}

