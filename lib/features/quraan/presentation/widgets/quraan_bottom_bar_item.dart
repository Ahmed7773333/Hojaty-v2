import 'package:flutter/material.dart';
import '../../../../config/theme/app_text_styles.dart';

class QuraanBottomBarItem extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;

  const QuraanBottomBarItem({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.notoKufiArabicBody13Medium),
        ],
      ),
    );
  }
}
