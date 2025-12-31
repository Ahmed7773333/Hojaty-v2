import 'package:flutter/material.dart';
import '../../../../config/theme/app_text_styles.dart';
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
            _TopBarItem(
              label: context.strings.quranSearch,
              icon: Icons.search,
              onTap: onSearchTap,
            ),
            // Juzs
            _TopBarItem(
              label: context.strings.quranJuzs,
              icon: Icons.list,
              onTap: onHezpsTap,
            ),
            // Tafseer
            _TopBarItem(
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

class _TopBarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _TopBarItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.notoKufiArabicBody13Medium),
          ],
        ),
      ),
    );
  }
}
