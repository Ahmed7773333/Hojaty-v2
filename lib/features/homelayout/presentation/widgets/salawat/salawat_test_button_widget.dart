import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/local_notification_service.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class SalawatTestButtonWidget extends StatelessWidget {
  const SalawatTestButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final lang = Localizations.localeOf(context).languageCode;
          LocalNotificationService.showTestSalawatNotification(language: lang);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.strings.salawatTestNotificationSent),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.white.withValues(alpha: 0.06)
                : AppColors.primaryDark.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.primaryDark.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_outline_rounded,
                size: 20.r,
                color: isDark ? AppColors.accentGold : AppColors.primaryDark,
              ),
              8.hor,
              Text(
                context.strings.salawatTestButton,
                style: context.textTheme.labelMedium?.copyWith(
                  color: isDark ? AppColors.white : AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
