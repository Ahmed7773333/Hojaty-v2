import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class DailyStoryAppBarWidget extends StatelessWidget {
  const DailyStoryAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDarkBackground,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.white,
                size: 20.r,
              ),
            ),
            8.hor,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.strings.dailyStoryTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18.sp,
                    ),
                  ),
                  2.ver,
                  Text(
                    context.strings.dailyStorySubtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.greenDarkTextSecondary,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

