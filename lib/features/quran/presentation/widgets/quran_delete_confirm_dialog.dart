import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/liquid_glass_style.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';
import 'package:hojaty/features/quran/domain/entities/qirat_type.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_delete_confirm_dialog_actions_widget.dart';

class QuranDeleteConfirmDialog extends StatelessWidget {
  final QiratType qirat;

  const QuranDeleteConfirmDialog({super.key, required this.qirat});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isGlass = context.isLiquidGlassEnabled;
    final errorColor = Theme.of(context).colorScheme.error;

    return Dialog(
      backgroundColor: isGlass
          ? AppColors.transparent
          : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
      elevation: isGlass ? 0 : null,
      surfaceTintColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: isGlass
            ? BorderSide.none
            : BorderSide(
                color: isDark
                    ? AppColors.darkBorderUnselected
                    : AppColors.lightBorderUnselected,
              ),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(20.r),
        blurSigma: LiquidGlassStyle.maxBlurSigma,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                color: errorColor.withValues(alpha: isDark ? 0.2 : 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: errorColor,
                size: 28.r,
              ),
            ),
            16.ver,
            Text(
              context.strings.deleteQiratConfirmTitle,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.center,
            ),
            8.ver,
            Text(
              context.strings.deleteQiratConfirmDesc(qirat.label(context)),
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            24.ver,
            const QuranDeleteConfirmDialogActionsWidget(),
          ],
        ),
      ),
    );
  }
}
