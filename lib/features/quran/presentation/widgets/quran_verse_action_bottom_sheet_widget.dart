import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/utils/snackbar_helper.dart';
import 'package:hojaty/features/quran/data/models/page_data_model.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_verse_sheet_actions_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_verse_sheet_ayah_card_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_verse_sheet_header_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_verse_sheet_tafseer_widget.dart';

class QuranVerseActionBottomSheetWidget extends StatelessWidget {
  final PageDataModel pageData;
  final int verseIndex;
  final int pageNumber;

  const QuranVerseActionBottomSheetWidget({
    super.key,
    required this.pageData,
    required this.verseIndex,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final surahsNames = pageData.surahsNames ?? [];
    final versesNumbers = pageData.versesNumbers ?? [];
    final versesContentEmaly = pageData.versesContentEmaly ?? [];
    final versesContent = pageData.versesContent ?? [];
    final tafseers = pageData.tafseer ?? [];

    final surahName = (verseIndex < surahsNames.length)
        ? surahsNames[verseIndex]
        : '';
    final verseNumber = (verseIndex < versesNumbers.length)
        ? versesNumbers[verseIndex]
        : (verseIndex + 1);
    final verseText = (verseIndex < versesContentEmaly.length)
        ? versesContentEmaly[verseIndex]
        : ((verseIndex < versesContent.length) ? versesContent[verseIndex] : '');
    final tafseerText =
        (verseIndex < tafseers.length) ? tafseers[verseIndex] : '';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBorderUnselected
                        : AppColors.lightBorderUnselected,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              12.ver,
              QuranVerseSheetHeaderWidget(
                surahName: surahName,
                verseNumber: verseNumber,
                onClose: () => Navigator.of(context).pop(),
              ),
              if (verseText.isNotEmpty) ...[
                12.ver,
                QuranVerseSheetAyahCardWidget(verseText: verseText),
              ],
              12.ver,
              QuranVerseSheetTafseerWidget(tafseerText: tafseerText),
              16.ver,
              QuranVerseSheetActionsWidget(
                onCopy: () {
                  Clipboard.setData(ClipboardData(text: verseText));
                  Navigator.of(context).pop();
                  SnackbarHelper.showSuccess(
                    context,
                    message: context.strings.hojatyAiTextCopied,
                  );
                },
                onOpenTafseer: () {
                  Navigator.of(context).pop();
                  context.pushNamed(
                    AppRoutes.quranTafseer,
                    extra: {
                      'pageData': pageData,
                      'pageNum': pageNumber,
                      'highlightVerse': verseNumber,
                    },
                  );
                },
              ),
              8.ver,
            ],
          ),
        ),
      ),
    );
  }
}

