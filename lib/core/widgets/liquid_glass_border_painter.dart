import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/liquid_glass_border_edges.dart';

/// Paints Apple iOS 26 Liquid Glass optical layers:
/// 1. 3-stop diagonal surface specular sheen (glossy top-left crest -> clear waist -> subtle bounce)
/// 2. Inner top crest highlight + subtle inner depth lip
/// 3. 3-stop 135° refractive specular border rim
class LiquidGlassBorderPainter extends CustomPainter {
  static const List<double> _sheenStops = <double>[0.0, 0.42, 1.0];
  static const List<double> _rimStops = <double>[0.0, 0.48, 1.0];

  final BorderRadius borderRadius;
  final List<Color> sheenColors;
  final Color innerHighlightColor;
  final Color innerShadowColor;
  final List<Color> gradientColors;
  final double strokeWidth;
  final LiquidGlassBorderEdges edges;

  const LiquidGlassBorderPainter({
    required this.borderRadius,
    required this.sheenColors,
    required this.innerHighlightColor,
    required this.innerShadowColor,
    required this.gradientColors,
    this.strokeWidth = 1.2,
    this.edges = LiquidGlassBorderEdges.all,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final rect = Offset.zero & size;
    final fullRRect = borderRadius.toRRect(rect);

    // 1. Diagonal surface specular sheen (painted over base tintColor)
    if (sheenColors.length >= 2) {
      final sheenPaint = Paint()
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
          begin: const Alignment(-0.85, -1.0),
          end: const Alignment(0.85, 1.0),
          colors: sheenColors,
          stops: sheenColors.length == 3 ? _sheenStops : null,
        ).createShader(rect);
      canvas.drawRRect(fullRRect, sheenPaint);
    }

    // 2. Inner depth shadow + top crest refraction highlight (for full-framed surfaces)
    if (edges == LiquidGlassBorderEdges.all && size.height > 8) {
      final innerRect = rect.deflate(strokeWidth + 0.6);
      if (!innerRect.isEmpty) {
        final innerRRect = borderRadius.toRRect(innerRect);

        // Subtle inner depth shadow at bottom-right
        final depthPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.9
          ..isAntiAlias = true
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [innerShadowColor.withValues(alpha: 0.0), innerShadowColor],
          ).createShader(innerRect);
        canvas.drawRRect(innerRRect, depthPaint);

        // Crisp top-lip internal specular catchlight (inset 0 1px)
        final crestHeight = (innerRRect.tlRadiusY > innerRRect.trRadiusY
                ? innerRRect.tlRadiusY
                : innerRRect.trRadiusY)
            .clamp(4.0, size.height * 0.35);
        canvas.save();
        canvas.clipRect(Rect.fromLTWH(0, 0, size.width, crestHeight));
        final crestPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.9
          ..isAntiAlias = true
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              innerHighlightColor,
              innerHighlightColor.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, crestHeight));
        canvas.drawRRect(innerRRect, crestPaint);
        canvas.restore();
      }
    }

    // 3. Outer 135° specular rim stroke
    if (gradientColors.length < 2) return;

    final rimShader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: gradientColors,
      stops: gradientColors.length == 3 ? _rimStops : null,
    ).createShader(rect);

    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = rimShader
      ..isAntiAlias = true;

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
                  ? rrect.brRadiusY
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
        oldDelegate.innerHighlightColor != innerHighlightColor ||
        oldDelegate.innerShadowColor != innerShadowColor ||
        !listEquals(oldDelegate.sheenColors, sheenColors) ||
        !listEquals(oldDelegate.gradientColors, gradientColors);
  }
}
