import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../../data/mocks/athkar_mock_data.dart';
import '../../../data/datasources/local/athkar_local_data_source.dart';
import '../../../data/models/athkar_category_model.dart';
import '../../../data/models/athkar_detail_args.dart';
import '../../../data/models/prayer_time_model.dart';
import '../../../data/models/thikr_item_model.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_state.dart';

class HomeAthkarQuickAccessCard extends StatelessWidget {
  const HomeAthkarQuickAccessCard({super.key});

  void _onTapCard(
    BuildContext context, {
    required AthkarCategoryType type,
    required String title,
    required int categoryId,
  }) async {
    List<ThikrItemModel> items;
    switch (type) {
      case AthkarCategoryType.evening:
        items = await const AthkarLocalDataSource().getEveningAthkar();
        if (items.isEmpty) items = AthkarMockData.eveningAthkar;
        break;
      case AthkarCategoryType.sleep:
        items = await const AthkarLocalDataSource().getSleepAthkar();
        if (items.isEmpty) items = AthkarMockData.sleepAthkar;
        break;
      case AthkarCategoryType.morning:
      default:
        items = await const AthkarLocalDataSource().getMorningAthkar();
        if (items.isEmpty) items = AthkarMockData.morningAthkar;
        break;
    }

    if (!context.mounted) return;

    context.pushNamed(
      AppRoutes.athkarDetail,
      extra: AthkarDetailArgs(
        title: title,
        items: items,
        categoryType: type,
        categoryId: categoryId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      buildWhen: (prev, curr) => prev.nextPrayerType != curr.nextPrayerType,
      builder: (context, state) {
        final nextPrayer = state.nextPrayerType;
        final AthkarCategoryType athkarType;
        final String title;
        final String iconAsset;
        final int categoryId;

        if (nextPrayer != null) {
          switch (nextPrayer) {
            case PrayerType.maghrib:
            case PrayerType.isha:
              athkarType = AthkarCategoryType.evening;
              title = context.strings.eveningAthkar;
              iconAsset = Assets.eveningAzkharIcon;
              categoryId = 133;
              break;
            case PrayerType.fajr:
              athkarType = AthkarCategoryType.sleep;
              title = context.strings.sleepAthkar;
              iconAsset = Assets.beforeSleepAzkharIcon;
              categoryId = 2;
              break;
            case PrayerType.dhuhr:
            case PrayerType.asr:
            default:
              athkarType = AthkarCategoryType.morning;
              title = context.strings.morningAthkar;
              iconAsset = Assets.morningAzkharIcon;
              categoryId = 1;
              break;
          }
        } else {
          final hour = DateTime.now().hour;
          if (hour >= 17 && hour < 23) {
            athkarType = AthkarCategoryType.evening;
            title = context.strings.eveningAthkar;
            iconAsset = Assets.eveningAzkharIcon;
            categoryId = 133;
          } else if (hour >= 23 || hour < 4) {
            athkarType = AthkarCategoryType.sleep;
            title = context.strings.sleepAthkar;
            iconAsset = Assets.beforeSleepAzkharIcon;
            categoryId = 2;
          } else {
            athkarType = AthkarCategoryType.morning;
            title = context.strings.morningAthkar;
            iconAsset = Assets.morningAzkharIcon;
            categoryId = 1;
          }
        }

        return InkWell(
          onTap: () => _onTapCard(
            context,
            type: athkarType,
            title: title,
            categoryId: categoryId,
          ),
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
                  color: AppColors.black.withValues(
                    alpha: isDark ? 0.2 : 0.04,
                  ),
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
                        iconAsset,
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
                        color: AppColors.primaryDarkSurface.withValues(
                          alpha: isDark ? 0.4 : 0.1,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorderUnselected
                              : AppColors.lightBorderUnselected,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.strings.athkar,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w700,
                              fontSize: 10.sp,
                            ),
                          ),
                          2.hor,
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 9.r,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                10.ver,
                Text(
                  context.strings.athkar,
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
                  title,
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
                  context.strings.athkarSubtitle,
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
