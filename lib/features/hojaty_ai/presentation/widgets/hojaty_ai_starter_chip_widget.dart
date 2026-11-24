import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hojaty_ai/data/models/hojaty_starter_prompt_model.dart';

class HojatyAiStarterChipWidget extends StatelessWidget {
  final HojatyStarterPromptModel item;
  final ValueChanged<String> onTap;

  const HojatyAiStarterChipWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final accentColor =
        isDark ? AppColors.accentGoldLight : AppColors.accentGoldDark;

    return Material(
      color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: () => onTap(item.prompt),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 14.w,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: item.isAction
                  ? AppColors.accentGold.withValues(alpha: 0.35)
                  : (isDark
                        ? AppColors.darkBorderUnselected
                        : AppColors.lightBorderUnselected),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  item.icon,
                  color: accentColor,
                  size: 16.r,
                ),
              ),
              12.hor,
              Expanded(
                child: Text(
                  item.label,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.r,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
