import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/page_data_model.dart';
import '../widgets/quran_tafseer_ayah_card_widget.dart';

class QuranTafseerPage extends StatelessWidget {
  final PageDataModel? pageData;
  final int pageNum;
  final int? highlightVerse;

  const QuranTafseerPage({
    super.key,
    required this.pageData,
    required this.pageNum,
    this.highlightVerse,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final tafseers = pageData?.tafseer ?? [];
    final versesContent = pageData?.versesContentEmaly ?? pageData?.versesContent ?? [];
    final versesNumbers = pageData?.versesNumbers ?? [];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          '${context.strings.quranTafseer} — ${context.strings.quranPageLabel} $pageNum',
          style: context.textTheme.titleLarge?.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 18.sp,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            size: 20.sp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: tafseers.isEmpty
            ? Center(
                child: Text(
                  context.strings.quranNoResults,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                itemCount: tafseers.length,
                itemBuilder: (context, index) {
                  final verseText = (index < versesContent.length) ? versesContent[index] : '';
                  final verseNum = (index < versesNumbers.length) ? versesNumbers[index] : (index + 1);
                  final tafseerText = tafseers[index];

                  return QuranTafseerAyahCardWidget(
                    verseNumber: verseNum,
                    verseText: verseText,
                    tafseerText: tafseerText,
                  );
                },
              ),
      ),
    );
  }
}
