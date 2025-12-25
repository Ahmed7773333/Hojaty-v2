import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

class QuraanBottomBar extends StatelessWidget {
  final bool isVisible;
  final String juzText;
  final String hizbText;
  final String pageText;
  final VoidCallback onHomeTap;
  final VoidCallback onJuzTap;

  const QuraanBottomBar({
    super.key,
    required this.isVisible,
    required this.juzText,
    required this.hizbText,
    required this.pageText,
    required this.onHomeTap,
    required this.onJuzTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      bottom: isVisible ? 0 : -100,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 8,
          top: 12,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  juzText,
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(hizbText, style: context.textTheme.bodySmall),
              ],
            ),
            Text(pageText, style: context.textTheme.bodyMedium),
            Row(
              children: [
                IconButton(
                  onPressed: onJuzTap,
                  icon: const Icon(Icons.format_list_numbered_rtl),
                  tooltip: context.strings.quranJuzs,
                ),
                IconButton(
                  onPressed: onHomeTap,
                  icon: const Icon(Icons.home),
                  tooltip: context.strings.home,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
