import 'package:flutter/material.dart';
import 'package:hojaty/features/quraan/presentation/widgets/quraan_bottom_bar_item.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

class QuraanTopBar extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTafseerTap;
  final VoidCallback onHezpsTap;
  final VoidCallback onSearchTap;

  const QuraanTopBar({
    super.key,
    required this.isVisible,
    required this.onTafseerTap,
    required this.onHezpsTap,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: isVisible ? 0 : -200,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          bottom: 12,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Search
            QuraanBottomBarItem(
              label: context.strings.quranSearch,
              icon: Icons.search,
              onTap: onSearchTap,
            ),
            // Juzs
            QuraanBottomBarItem(
              label: context.strings.quranJuzs,
              icon: Icons.list,
              onTap: onHezpsTap,
            ),
            // Tafseer
            QuraanBottomBarItem(
              label: context.strings.quranTafseer,
              icon: Icons.menu_book,
              onTap: onTafseerTap,
            ),
          ],
        ),
      ),
    );
  }
}

