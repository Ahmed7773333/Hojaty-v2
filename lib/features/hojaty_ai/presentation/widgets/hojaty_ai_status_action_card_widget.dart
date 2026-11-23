import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hojaty_ai/data/datasources/hojaty_tool_registry.dart';
import 'package:hojaty/features/hojaty_ai/data/models/ai_tool_call_model.dart';

class HojatyAiStatusActionCardWidget extends StatelessWidget {
  final AiToolActionResultModel action;

  const HojatyAiStatusActionCardWidget({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final text = action.displayText ??
        (action.isSuccess ? 'تم تنفيذ الإجراء بنجاح.' : 'تعذر تنفيذ الإجراء.');

    IconData iconData = Icons.check_circle_outline_rounded;
    String buttonText = 'عرض';
    String? targetRoute;

    switch (action.toolName) {
      case HojatyToolRegistry.toolControlSebhaCounter:
        iconData = Icons.touch_app_outlined;
        buttonText = 'السبحة';
        targetRoute = AppRoutes.sebha;
        break;
      case HojatyToolRegistry.toolOpenQiblaCompass:
        iconData = Icons.explore_outlined;
        buttonText = 'القبلة';
        targetRoute = AppRoutes.qibla;
        break;
      case HojatyToolRegistry.toolOpenAthkarCategory:
        iconData = Icons.auto_stories_outlined;
        buttonText = 'الأذكار';
        targetRoute = AppRoutes.athkarDetail;
        break;
      case HojatyToolRegistry.toolConfigurePrayerAlerts:
        iconData = Icons.notifications_active_outlined;
        buttonText = 'الإعدادات';
        targetRoute = AppRoutes.notifications;
        break;
      case HojatyToolRegistry.toolUpdateAppPreferences:
        iconData = Icons.palette_outlined;
        buttonText = 'المظهر';
        targetRoute = AppRoutes.themeSettings;
        break;
      case HojatyToolRegistry.toolOpenHadithReader:
        iconData = Icons.library_books_outlined;
        buttonText = 'المكتبة';
        targetRoute = AppRoutes.books;
        break;
      default:
        iconData = Icons.check_circle_outline_rounded;
        buttonText = 'عرض';
        targetRoute = null;
    }

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardUnselected
            : AppColors.lightCardUnselected,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: action.isSuccess
              ? AppColors.accentGold.withValues(alpha: 0.25)
              : context.colors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: action.isSuccess
                ? (isDark
                    ? AppColors.accentGoldLight
                    : AppColors.accentGoldDark)
                : context.colors.error,
            size: 20.r,
          ),
          10.hor,
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (targetRoute != null) ...[
            8.hor,
            GestureDetector(
              onTap: () => context.pushNamed(targetRoute!),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  buttonText,
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.accentGoldLight
                        : AppColors.accentGoldDark,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

