import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class DailyStoryCategoryChipItemWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const DailyStoryCategoryChipItemWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final colors = context.colors;
    final borderRadius = BorderRadius.circular(20.r);

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary
                : (isDark ? AppColors.darkCardUnselected : AppColors.lightSurface),
            borderRadius: borderRadius,
            border: Border.all(
              color: isSelected
                  ? colors.primary
                  : (isDark
                      ? AppColors.darkBorderUnselected
                      : AppColors.lightBorderUnselected),
            ),
          ),
          child: Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(
              color: isSelected ? colors.onPrimary : colors.onSurface,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }
}

