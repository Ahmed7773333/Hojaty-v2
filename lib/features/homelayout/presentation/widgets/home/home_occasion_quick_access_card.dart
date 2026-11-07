import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../../data/mocks/occasions_mock_data.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_state.dart';

class HomeOccasionQuickAccessCard extends StatelessWidget {
  const HomeOccasionQuickAccessCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      buildWhen: (prev, curr) => prev.nextOccasion != curr.nextOccasion,
      builder: (context, state) {
        final occasion = state.nextOccasion ?? OccasionsMockData.nextOccasion;

        return InkWell(
          onTap: () {
            context.pushNamed(
              AppRoutes.occasionDetail,
              extra: occasion,
            );
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
                      child: SvgPicture.asset(
                        Assets.crescentIcon,
                        width: 18.w,
                        height: 18.h,
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
                        context.strings.daysRemainingUnit(
                          occasion.daysRemaining,
                        ),
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
                  context.strings.upcomingOccasion,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                4.ver,
                Text(
                  occasion.title,
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
                4.ver,
                Text(
                  occasion.hijriDate,
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
        );
      },
    );
  }
}
