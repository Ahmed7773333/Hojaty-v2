import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';

class LanguageRadioCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageRadioCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final activeAccent = isDark ? AppColors.accentGold : AppColors.primaryDark;

    final bgColor = isSelected
        ? (isDark ? AppColors.darkCardSelected : AppColors.lightCardSelected)
        : (isDark ? AppColors.darkCardUnselected : AppColors.lightSurface);

    final borderColor = isSelected
        ? activeAccent
        : (isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected);

    return LiquidGlassContainer(
      variant: LiquidGlassSurfaceVariant.card,
      borderRadius: BorderRadius.circular(20.r),
      margin: EdgeInsets.only(bottom: 14.h),
      customTintColor: isSelected
          ? activeAccent.withValues(alpha: isDark ? 0.16 : 0.12)
          : null,
      customBorderColor: isSelected ? activeAccent : null,
      customBorderWidth: isSelected ? 1.8 : null,
      fallbackDecoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: borderColor, width: isSelected ? 1.8 : 1.0),
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                  4.ver,
                  Text(
                    subtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              Container(
                width: 22.r,
                height: 22.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? activeAccent : AppColors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? activeAccent
                        : (isDark
                              ? AppColors.darkBorderUnselected
                              : AppColors.lightBorderUnselected),
                    width: 2.0,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 14.r,
                        color: isDark ? AppColors.black : AppColors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
