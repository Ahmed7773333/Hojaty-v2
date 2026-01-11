import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import 'quraan_bottom_sheet_selection.dart';
import 'quraan_bottom_bar_item.dart';

class QuraanBottomBar extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onHomeTap;
  final VoidCallback onJuzTap;

  const QuraanBottomBar({
    super.key,
    required this.isVisible,
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
          left: 32,
          right: 32,
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Readings (Qira'at)
            QuraanBottomBarItem(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const QuraanBottomSheetSelection(),
                );
              },
              icon: Icons.book,
              label: context.strings.qiraat,
            ),

            // Home
            QuraanBottomBarItem(
              onTap: onHomeTap,
              icon: Icons.home,
              label: context.strings.home,
            ),

            // Index (Fehres)
            QuraanBottomBarItem(
              onTap: onJuzTap,
              icon: Icons.format_list_numbered_rtl,
              label: context.strings.surahs_list,
            ),
          ],
        ),
      ),
    );
  }
}
