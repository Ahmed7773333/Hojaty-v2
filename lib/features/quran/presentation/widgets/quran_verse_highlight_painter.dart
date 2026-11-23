import 'package:material_ui/material_ui.dart';

class QuranVerseHighlightPainter extends CustomPainter {
  final List<List<double>> rects;
  final Color highlightColor;

  const QuranVerseHighlightPainter({
    required this.rects,
    this.highlightColor = const Color(0x52CCA142),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (rects.isEmpty || size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.fill;

    for (final rect in rects) {
      if (rect.length < 4) continue;
      final left = rect[0] * size.width;
      final top = rect[1] * size.height;
      final right = rect[2] * size.width;
      final bottom = rect[3] * size.height;

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTRB(left, top, right, bottom),
        const Radius.circular(4),
      );
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant QuranVerseHighlightPainter oldDelegate) {
    return oldDelegate.rects != rects ||
        oldDelegate.highlightColor != highlightColor;
  }
}

