import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

class DailyStoryCardDividerWidget extends StatelessWidget {
  final Color color;
  final double unit;

  const DailyStoryCardDividerWidget({
    super.key,
    required this.color,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Container(height: unit, color: color.withValues(alpha: 0.5)),
    );

    return SizedBox(
      width: 120 * unit,
      child: Row(
        children: [
          line,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8 * unit),
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(width: 6 * unit, height: 6 * unit, color: color),
            ),
          ),
          line,
        ],
      ),
    );
  }
}

