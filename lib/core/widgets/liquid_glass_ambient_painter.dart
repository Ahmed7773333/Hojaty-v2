import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';

/// Paints static ambient light pools in a single cached canvas pass,
/// avoiding stacked full-screen overdraw while giving Liquid Glass real depth.
class LiquidGlassAmbientPainter extends CustomPainter {
  final Color baseColor;
  final Color topOrbColor;
  final Color midOrbColor;
  final Color bottomOrbColor;

  const LiquidGlassAmbientPainter({
    required this.baseColor,
    required this.topOrbColor,
    required this.midOrbColor,
    required this.bottomOrbColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    canvas.drawColor(baseColor, BlendMode.src);

    final shortest = size.shortestSide;
    _drawOrb(
      canvas: canvas,
      center: Offset(size.width * 0.92, size.height * 0.22),
      radius: shortest * 0.85,
      color: topOrbColor,
    );
    _drawOrb(
      canvas: canvas,
      center: Offset(size.width * 0.05, size.height * 0.56),
      radius: shortest * 0.92,
      color: midOrbColor,
    );
    _drawOrb(
      canvas: canvas,
      center: Offset(size.width * 0.88, size.height * 0.92),
      radius: shortest * 0.85,
      color: bottomOrbColor,
    );
  }

  void _drawOrb({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required Color color,
  }) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, AppColors.transparent],
      ).createShader(rect);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant LiquidGlassAmbientPainter oldDelegate) {
    return oldDelegate.baseColor != baseColor ||
        oldDelegate.topOrbColor != topOrbColor ||
        oldDelegate.midOrbColor != midOrbColor ||
        oldDelegate.bottomOrbColor != bottomOrbColor;
  }
}

