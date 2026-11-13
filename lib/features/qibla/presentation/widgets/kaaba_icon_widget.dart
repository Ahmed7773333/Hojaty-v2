import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

class KaabaIconWidget extends StatelessWidget {
  final double size;

  const KaabaIconWidget({
    super.key,
    this.size = 28.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _KaabaPainter(),
    );
  }
}

class _KaabaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Kaaba main body
    final bodyPaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.fill;

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.16, w * 0.76, h * 0.74),
      Radius.circular(w * 0.1),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    // Golden Kiswa embroidery belt
    final beltPaint = Paint()
      ..color = AppColors.accentGold
      ..style = PaintingStyle.fill;

    final beltRect = Rect.fromLTWH(w * 0.12, h * 0.32, w * 0.76, h * 0.12);
    canvas.drawRect(beltRect, beltPaint);

    // Golden door (Bab al-Kaaba)
    final doorPaint = Paint()
      ..color = AppColors.accentGoldLight
      ..style = PaintingStyle.fill;

    final doorRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.52, h * 0.52, w * 0.24, h * 0.38),
      Radius.circular(w * 0.04),
    );
    canvas.drawRRect(doorRect, doorPaint);

    // Subtle golden roof trim
    final roofTrimPaint = Paint()
      ..color = AppColors.accentGold.withValues(alpha: 0.6)
      ..strokeWidth = w * 0.04
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(w * 0.16, h * 0.18),
      Offset(w * 0.84, h * 0.18),
      roofTrimPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

