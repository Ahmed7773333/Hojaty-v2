import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../constants/quran_constants.dart';
import '../../constants/quran_text_helper.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_state.dart';

class QuranQuarterCardWidget extends StatelessWidget {
  final String title;
  final int surah;
  final int verse;
  final ValueChanged<int> onTap;

  const QuranQuarterCardWidget({
    super.key,
    required this.title,
    required this.surah,
    required this.verse,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final pageNum = QuranTextHelper.getPageNumber(surah, verse);
    final surahName = QuranConstants.surahMap[surah]?.name ?? '';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: () => onTap(pageNum),
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.primaryDarkSurface : AppColors.lightCardSelected,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      '${context.strings.safha} $pageNum',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.accentGoldLight : AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ],
              ),
              6.ver,
              BlocBuilder<QuranBloc, QuranState>(
                builder: (context, state) {
                  final pageData = state.quranPages[pageNum];
                  String verseContent = '';
                  if (pageData != null && pageData.versesNumbers != null) {
                    final idx = pageData.versesNumbers!.indexOf(verse);
                    if (idx != -1 && pageData.versesContentEmaly != null && idx < pageData.versesContentEmaly!.length) {
                      verseContent = pageData.versesContentEmaly![idx];
                    }
                  }

                  return Text(
                    verseContent.isNotEmpty
                        ? '$surahName - $verseContent'
                        : '$surahName: ${context.strings.ayahNumber(verse)}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontSize: 12.sp,
                      height: 1.4,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
