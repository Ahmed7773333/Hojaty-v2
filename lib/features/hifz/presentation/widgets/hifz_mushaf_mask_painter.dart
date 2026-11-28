import 'package:material_ui/material_ui.dart';

/// Paints opaque/tinted masking rectangles over hidden Mushaf ayahs during self-testing.
class HifzMushafMaskPainter extends CustomPainter {
  final List<List<List<double>>> maskedBounds;
  final Color maskColor;

  const HifzMushafMaskPainter({
    required this.maskedBounds,
    required this.maskColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (maskedBounds.isEmpty || size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..color = maskColor
      ..style = PaintingStyle.fill;

    for (final verseRects in maskedBounds) {
      for (final rect in verseRects) {
        if (rect.length < 4) continue;
        final rrect = RRect.fromRectAndRadius(
          Rect.fromLTRB(
            rect[0] * size.width,
            rect[1] * size.height,
            rect[2] * size.width,
            rect[3] * size.height,
          ),
          const Radius.circular(6),
        );
        canvas.drawRRect(rrect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HifzMushafMaskPainter oldDelegate) {
    return oldDelegate.maskedBounds != maskedBounds ||
        oldDelegate.maskColor != maskColor;
  }
}

