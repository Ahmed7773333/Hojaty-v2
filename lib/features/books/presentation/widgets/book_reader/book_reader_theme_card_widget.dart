import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class BookReaderThemeCardWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color previewColor;
  final Color textColor;
  final bool isSelected;
  final VoidCallback onTap;

  const BookReaderThemeCardWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.previewColor,
    required this.textColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: previewColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? AppColors.accentGold
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.accentGold : textColor,
              size: 20.sp,
            ),
            6.ver,
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
