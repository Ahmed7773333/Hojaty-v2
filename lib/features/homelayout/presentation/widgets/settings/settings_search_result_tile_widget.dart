import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/domain/entities/setting_search_item.dart';

class SettingsSearchResultTileWidget extends StatelessWidget {
  final SettingSearchItem item;
  final VoidCallback onTap;

  const SettingsSearchResultTileWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final lang = Localizations.localeOf(context).languageCode;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        child: Row(
          children: [
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(9.r),
              ),
              child: Icon(
                Icons.tune_rounded,
                size: 16.r,
                color: AppColors.accentGold,
              ),
            ),
            12.hor,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.localizedTitle(lang),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5.sp,
                    ),
                  ),
                  2.ver,
                  Text(
                    item.localizedBreadcrumb(lang),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            8.hor,
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13.r,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ],
        ),
      ),
    );
  }
}
