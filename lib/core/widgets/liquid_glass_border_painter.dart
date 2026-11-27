import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/liquid_glass_border_edges.dart';

/// Paints a crisp 135-degree vector specular border rim on top of the
/// GPU fragment-shader Liquid Glass surface.
class LiquidGlassBorderPainter extends CustomPainter {
  static const List<double> _rimStops = <double>[0.0, 0.48, 1.0];

  final BorderRadius borderRadius;
  final List<Color> gradientColors;
  final double strokeWidth;
  final LiquidGlassBorderEdges edges;

  const LiquidGlassBorderPainter({
    required this.borderRadius,
    required this.gradientColors,
    this.strokeWidth = 1.1,
    this.edges = LiquidGlassBorderEdges.all,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || gradientColors.length < 2) return;

    final rect = Offset.zero & size;
    final fullRRect = borderRadius.toRRect(rect);

    // Subtle single-pass diagonal liquid sheen across the top-left crest
    final sheenPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          gradientColors.first.withValues(alpha: 0.14),
          gradientColors.first.withValues(alpha: 0.0),
        ],
        stops: const <double>[0.0, 0.55],
      ).createShader(rect);
    canvas.drawRRect(fullRRect, sheenPaint);

    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
        stops: gradientColors.length == 3 ? _rimStops : null,
      ).createShader(rect);

    final halfStroke = strokeWidth / 2;
    final deflatedRect = rect.deflate(halfStroke);

    switch (edges) {
      case LiquidGlassBorderEdges.all:
        canvas.drawRRect(borderRadius.toRRect(deflatedRect), rimPaint);
      case LiquidGlassBorderEdges.topOnly:
        if (borderRadius == BorderRadius.zero) {
          canvas.drawLine(
            Offset(0, halfStroke),
            Offset(size.width, halfStroke),
            rimPaint,
          );
        } else {
          final rrect = borderRadius.toRRect(deflatedRect);
          final maxArc = (rrect.tlRadiusY > rrect.trRadiusY
                  ? rrect.tlRadiusY
                  : rrect.trRadiusY)
              .clamp(0.0, size.height);
          canvas.save();
          canvas.clipRect(
            Rect.fromLTWH(0, 0, size.width, maxArc + strokeWidth),
          );
          canvas.drawRRect(rrect, rimPaint);
          canvas.restore();
        }
      case LiquidGlassBorderEdges.bottomOnly:
        if (borderRadius == BorderRadius.zero) {
          final y = size.height - halfStroke;
          canvas.drawLine(Offset(0, y), Offset(size.width, y), rimPaint);
        } else {
          final rrect = borderRadius.toRRect(deflatedRect);
          final maxArc = (rrect.blRadiusY > rrect.brRadiusY
                  ? rrect.blRadiusY
                  : rrect.brRadiusY)
              .clamp(0.0, size.height);
          canvas.save();
          canvas.clipRect(
            Rect.fromLTWH(
              0,
              size.height - maxArc - strokeWidth,
              size.width,
              maxArc + strokeWidth,
            ),
          );
          canvas.drawRRect(rrect, rimPaint);
          canvas.restore();
        }
    }
  }

  @override
  bool shouldRepaint(covariant LiquidGlassBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.edges != edges ||
        !listEquals(oldDelegate.gradientColors, gradientColors);
  }
}
