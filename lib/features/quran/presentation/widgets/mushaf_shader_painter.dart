import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Paints a scanned Mushaf page through the three-layer night-mode fragment shader.
class MushafShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final ui.Image image;
  final Color textColor;
  final Color accentColor;
  final Color bgColor;

  const MushafShaderPainter({
    required this.shader,
    required this.image,
    required this.textColor,
    required this.accentColor,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, textColor.r)
      ..setFloat(3, textColor.g)
      ..setFloat(4, textColor.b)
      ..setFloat(5, accentColor.r)
      ..setFloat(6, accentColor.g)
      ..setFloat(7, accentColor.b)
      ..setFloat(8, bgColor.r)
      ..setFloat(9, bgColor.g)
      ..setFloat(10, bgColor.b)
      ..setImageSampler(0, image, filterQuality: FilterQuality.medium);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant MushafShaderPainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.shader != shader ||
        oldDelegate.textColor != textColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.bgColor != bgColor;
  }
}

