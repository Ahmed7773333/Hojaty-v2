import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../core/local/user_hive_helper.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class HomeSebhaQuickAccessCard extends StatelessWidget {
  const HomeSebhaQuickAccessCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return ValueListenableBuilder(
      valueListenable: UserHiveHelper.prayersBox.listenable(
        keys: const ['free_sebha_counter'],
      ),
      builder: (context, _, __) {
        final counter = UserHiveHelper.getSebhaCounter();

        return InkWell(
          onTap: () {
            context.pushNamed(AppRoutes.sebha);
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCardUnselected
                  : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDark
                    ? AppColors.darkBorderUnselected
                    : AppColors.lightBorderUnselected,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.h,
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.fingerprint_rounded,
                        color: isDark
                            ? AppColors.accentGoldLight
                            : AppColors.accentGoldDark,
                        size: 20.r,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withValues(
                          alpha: isDark ? 0.2 : 0.12,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.accentGold.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Text(
                        '$counter',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppColors.accentGoldLight
                              : AppColors.accentGoldDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ),

                10.ver,
                Text(
                  context.strings.electronicSebha,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                4.ver,
                Text(
                  context.strings.countThikr(counter),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
