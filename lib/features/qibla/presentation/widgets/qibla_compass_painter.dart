import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

class QiblaCompassPainter extends CustomPainter {
  final double qiblaBearing;
  final bool isAligned;
  final bool isDark;
  final String northLabel;
  final String eastLabel;
  final String southLabel;
  final String westLabel;

  const QiblaCompassPainter({
    required this.qiblaBearing,
    required this.isAligned,
    required this.isDark,
    required this.northLabel,
    required this.eastLabel,
    required this.southLabel,
    required this.westLabel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Dial background circle
    final bgPaint = Paint()
      ..color = isDark
          ? AppColors.primaryDarkSurface.withValues(alpha: 0.5)
          : AppColors.lightSurface
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 4, bgPaint);

    // 2. Outer decorative ring
    final outerRingPaint = Paint()
      ..color = isAligned
          ? AppColors.accentGold
          : (isDark ? AppColors.primaryDarkBorder : AppColors.lightBorderUnselected)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isAligned ? 3.0 : 1.5;
    canvas.drawCircle(center, radius - 6, outerRingPaint);

    // Subtle inner track
    final innerTrackPaint = Paint()
      ..color = AppColors.accentGold.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius - 26, innerTrackPaint);

    // 3. Compass tick marks & degree labels around 360 degrees
    final tickPaint = Paint()
      ..color = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted
      ..strokeCap = StrokeCap.round;

    final majorTickPaint = Paint()
      ..color = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    for (int deg = 0; deg < 360; deg += 5) {
      final rad = deg * (math.pi / 180.0) - (math.pi / 2);
      final isMajor = deg % 30 == 0;
      final isCardinal = deg % 90 == 0;

      final double outerR = radius - 8;
      final double innerR = isCardinal
          ? radius - 22
          : isMajor
              ? radius - 18
              : radius - 13;

      final p1 = Offset(
        center.dx + outerR * math.cos(rad),
        center.dy + outerR * math.sin(rad),
      );
      final p2 = Offset(
        center.dx + innerR * math.cos(rad),
        center.dy + innerR * math.sin(rad),
      );

      canvas.drawLine(p1, p2, isMajor ? majorTickPaint : tickPaint);
    }

    // 4. Cardinal direction labels (North, East, South, West)
    _drawCardinalLabel(canvas, center, radius - 36, 0, northLabel, isNorth: true);
    _drawCardinalLabel(canvas, center, radius - 36, 90, eastLabel);
    _drawCardinalLabel(canvas, center, radius - 36, 180, southLabel);
    _drawCardinalLabel(canvas, center, radius - 36, 270, westLabel);

    // 5. Target Qibla Bearing Indicator on the dial
    final qiblaRad = qiblaBearing * (math.pi / 180.0) - (math.pi / 2);
    final qiblaMarkerRadius = radius - 16;
    final qiblaMarkerOffset = Offset(
      center.dx + qiblaMarkerRadius * math.cos(qiblaRad),
      center.dy + qiblaMarkerRadius * math.sin(qiblaRad),
    );

    // Glowing dot at Qibla bearing
    final qiblaGlowPaint = Paint()
      ..color = AppColors.accentGold.withValues(alpha: isAligned ? 0.6 : 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(qiblaMarkerOffset, 12, qiblaGlowPaint);

    final qiblaDotPaint = Paint()
      ..color = AppColors.accentGold
      ..style = PaintingStyle.fill;
    canvas.drawCircle(qiblaMarkerOffset, 6, qiblaDotPaint);

    // Line from center towards Qibla marker
    final qiblaLinePaint = Paint()
      ..color = AppColors.accentGold.withValues(alpha: isAligned ? 0.8 : 0.35)
      ..strokeWidth = isAligned ? 2.5 : 1.5
      ..strokeCap = StrokeCap.round;

    final lineStart = Offset(
      center.dx + (radius * 0.25) * math.cos(qiblaRad),
      center.dy + (radius * 0.25) * math.sin(qiblaRad),
    );
    final lineEnd = Offset(
      center.dx + (radius - 28) * math.cos(qiblaRad),
      center.dy + (radius - 28) * math.sin(qiblaRad),
    );
    canvas.drawLine(lineStart, lineEnd, qiblaLinePaint);
  }

  void _drawCardinalLabel(
    Canvas canvas,
    Offset center,
    double distFromCenter,
    int degree,
    String text, {
    bool isNorth = false,
  }) {
    final rad = degree * (math.pi / 180.0) - (math.pi / 2);
    final pos = Offset(
      center.dx + distFromCenter * math.cos(rad),
      center.dy + distFromCenter * math.sin(rad),
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: isNorth
              ? AppColors.accentGoldLight
              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          fontSize: isNorth ? 16 : 13,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final textOffset = Offset(
      pos.dx - textPainter.width / 2,
      pos.dy - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant QiblaCompassPainter oldDelegate) {
    return oldDelegate.qiblaBearing != qiblaBearing ||
        oldDelegate.isAligned != isAligned ||
        oldDelegate.isDark != isDark;
  }
}

