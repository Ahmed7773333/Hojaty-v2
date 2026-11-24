import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/local_notification_service.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class AdhanPermissionsCardWidget extends StatefulWidget {
  const AdhanPermissionsCardWidget({super.key});

  @override
  State<AdhanPermissionsCardWidget> createState() =>
      _AdhanPermissionsCardWidgetState();
}

class _AdhanPermissionsCardWidgetState
    extends State<AdhanPermissionsCardWidget> {
  bool _isChecking = false;

  Future<void> _checkPermissions() async {
    if (_isChecking) return;
    setState(() => _isChecking = true);
    final granted = await LocalNotificationService.requestPermission();
    if (!mounted) return;
    setState(() => _isChecking = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          granted
              ? context.strings.adhanPermissionsCheckedSuccess
              : context.strings.adhanPermissionsCheckedDenied,
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.battery_saver_rounded,
                  size: 20.r,
                  color: AppColors.accentGold,
                ),
              ),
              12.hor,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.strings.adhanPermissionsTitle,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                    2.ver,
                    Text(
                      context.strings.adhanPermissionsSubtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 11.5.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.ver,
          SizedBox(
            width: double.infinity,
            child: InkWell(
              onTap: _checkPermissions,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.accentGold.withValues(alpha: 0.45),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isChecking)
                      SizedBox(
                        width: 16.r,
                        height: 16.r,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Icon(
                        Icons.verified_user_outlined,
                        size: 18.r,
                        color: AppColors.accentGold,
                      ),
                    8.hor,
                    Text(
                      context.strings.adhanPermissionsAction,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
