import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../quran/constants/quran_text_helper.dart';
import '../../../../quran/presentation/bloc/quran_bloc.dart';
import '../../../../quran/presentation/bloc/quran_state.dart';

class HomeQuranQuickAccessCard extends StatelessWidget {
  const HomeQuranQuickAccessCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<QuranBloc, QuranState>(
      buildWhen: (prev, curr) =>
          prev.selectedQirat != curr.selectedQirat ||
          prev.currentPage != curr.currentPage ||
          prev.qiratLastPages != curr.qiratLastPages,
      builder: (context, state) {
        final selectedQirat = state.selectedQirat;
        final lastPage =
            state.qiratLastPages[selectedQirat] ?? state.currentPage;
        final surah = QuranTextHelper.getSurahByPage(lastPage);
        final isAr = Localizations.localeOf(context).languageCode == 'ar';
        final surahDisplayName = surah != null
            ? (isAr ? 'سورة ${surah.name}' : 'Surah ${surah.englishName}')
            : context.strings.quranKareem;

        return RepaintBoundary(
          child: InkWell(
            onTap: () {
              context.pushNamed(AppRoutes.quranReader, extra: lastPage);
            },
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              padding: EdgeInsets.all(16.r),
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
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44.w,
                        height: 44.h,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: AppColors.accentGold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: SvgPicture.asset(
                          Assets.quranQuickAccessIcon,
                          width: 22.w,
                          height: 22.h,
                        ),
                      ),
                      12.hor,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.strings.quranKareem,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            3.ver,
                            Text(
                              surahDisplayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.titleMedium?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentGold.withValues(
                            alpha: isDark ? 0.2 : 0.12,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.accentGold.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          selectedQirat.label(context),
                          style: context.textTheme.labelSmall?.copyWith(
                            color: isDark
                                ? AppColors.accentGoldLight
                                : AppColors.accentGoldDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  14.ver,
                  Row(
                    children: [
                      Icon(
                        Icons.auto_stories_outlined,
                        size: 16.r,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      6.hor,
                      Text(
                        '${context.strings.safha} $lastPage',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                      ),
                      4.hor,
                      Text(
                        '/ 604',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                          fontSize: 11.sp,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.primaryDarkSurface
                              : AppColors.primaryDark,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.strings.continueReading,
                              style: context.textTheme.labelSmall?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 11.sp,
                              ),
                            ),
                            4.hor,
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 13.r,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

