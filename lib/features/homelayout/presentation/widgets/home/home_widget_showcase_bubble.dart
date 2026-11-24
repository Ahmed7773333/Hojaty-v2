import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class HomeWidgetShowcaseBubble extends StatelessWidget {
  final VoidCallback onDismiss;
  final String? title;
  final String? body;
  final IconData icon;

  const HomeWidgetShowcaseBubble({
    super.key,
    required this.onDismiss,
    this.title,
    this.body,
    this.icon = Icons.widgets_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTitle = title ?? context.strings.homeWidgetShowcaseTitle;
    final resolvedBody = body ?? context.strings.homeWidgetShowcaseBody;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 240.w,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.primaryDarkSurface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.accentGold.withValues(alpha: 0.6),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16.r,
                  color: AppColors.accentGoldLight,
                ),
                6.hor,
                Expanded(
                  child: Text(
                    resolvedTitle,
                    style: context.textTheme.labelLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
            6.ver,
            Text(
              resolvedBody,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.darkTextSecondary,
                fontSize: 12.sp,
                height: 1.4,
              ),
            ),
            10.ver,
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: GestureDetector(
                onTap: onDismiss,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    context.strings.homeWidgetShowcaseDismiss,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: AppColors.primaryDarkHeader,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

