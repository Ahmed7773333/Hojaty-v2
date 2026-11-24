import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/assets.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';
import 'package:hojaty/data/mocks/athkar_mock_data.dart';
import 'package:hojaty/features/homelayout/data/datasources/local/athkar_local_data_source.dart';
import 'package:hojaty/features/homelayout/data/models/athkar_category_model.dart';
import 'package:hojaty/features/homelayout/data/models/athkar_detail_args.dart';
import 'package:hojaty/features/homelayout/data/models/thikr_item_model.dart';
import 'package:hojaty/features/homelayout/domain/usecases/resolve_active_adhkar_usecase.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_bloc.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_state.dart';

class HomeAthkarQuickAccessCard extends StatelessWidget {
  const HomeAthkarQuickAccessCard({super.key});

  Future<void> _onTapCard(
    BuildContext context, {
    required AthkarCategoryType type,
    required String title,
    required int categoryId,
  }) async {
    final List<ThikrItemModel> items;
    switch (type) {
      case AthkarCategoryType.evening:
        final loaded = await const AthkarLocalDataSource().getEveningAthkar();
        items = loaded.isNotEmpty ? loaded : AthkarMockData.eveningAthkar;
      case AthkarCategoryType.sleep:
        final loaded = await const AthkarLocalDataSource().getSleepAthkar();
        items = loaded.isNotEmpty ? loaded : AthkarMockData.sleepAthkar;
      case AthkarCategoryType.afterPrayer:
        final loaded =
            await const AthkarLocalDataSource().getAfterPrayerAthkar();
        items = loaded.isNotEmpty ? loaded : AthkarMockData.afterPrayerAthkar;
      case AthkarCategoryType.morning:
      default:
        final loaded = await const AthkarLocalDataSource().getMorningAthkar();
        items = loaded.isNotEmpty ? loaded : AthkarMockData.morningAthkar;
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

  (String title, String iconAsset, int categoryId) _resolveDisplay(
    BuildContext context,
    AthkarCategoryType type,
  ) {
    switch (type) {
      case AthkarCategoryType.afterPrayer:
        return (
          context.strings.afterPrayerAthkar,
          Assets.afterPrayerAzkharIcon,
          27,
        );
      case AthkarCategoryType.evening:
        return (
          context.strings.eveningAthkar,
          Assets.eveningAzkharIcon,
          133,
        );
      case AthkarCategoryType.sleep:
        return (
          context.strings.sleepAthkar,
          Assets.beforeSleepAzkharIcon,
          2,
        );
      case AthkarCategoryType.morning:
      default:
        return (
          context.strings.morningAthkar,
          Assets.morningAzkharIcon,
          1,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      buildWhen: (prev, curr) =>
          prev.activeAdhkar != curr.activeAdhkar ||
          prev.currentLanguage != curr.currentLanguage,
      builder: (context, state) {
        final activeWindow =
            state.activeAdhkar ??
            const ResolveActiveAdhkarUseCase()(
              now: DateTime.now(),
              coordinates: UserHiveHelper.getCachedCoordinates(),
              parameters: UserHiveHelper.getPrayerCalculationParameters(
                UserHiveHelper.getCachedCoordinates(),
              ),
            );

        final athkarType = activeWindow.categoryType;
        final (title, iconAsset, categoryId) = _resolveDisplay(
          context,
          athkarType,
        );

        return LiquidGlassContainer(
          variant: LiquidGlassSurfaceVariant.card,
          borderRadius: BorderRadius.circular(20.r),
          fallbackDecoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCardUnselected
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: () => _onTapCard(
                context,
                type: athkarType,
                title: title,
                categoryId: categoryId,
              ),
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
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
            ),
          ),
        );
      },
    );
  }
}
