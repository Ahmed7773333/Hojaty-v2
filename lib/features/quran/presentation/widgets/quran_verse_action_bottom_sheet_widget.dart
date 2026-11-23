import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/utils/snackbar_helper.dart';
import 'package:hojaty/features/quran/data/datasources/quran_checkpoint_local_data_source.dart';
import 'package:hojaty/features/quran/data/models/page_data_model.dart';
import 'package:hojaty/features/quran/data/models/quran_checkpoint_model.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_verse_action_bottom_sheet_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_verse_share_options_sheet_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_verse_sheet_actions_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_verse_sheet_ayah_card_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_verse_sheet_header_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_verse_sheet_tafseer_widget.dart';

class QuranVerseActionBottomSheetWidget extends StatefulWidget {
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
  State<QuranVerseActionBottomSheetWidget> createState() =>
      _QuranVerseActionBottomSheetWidgetState();
}

class _QuranVerseActionBottomSheetWidgetState
    extends State<QuranVerseActionBottomSheetWidget> {
  late bool _isBookmarked;
  final QuranCheckpointLocalDataSource _dataSource =
      injector<QuranCheckpointLocalDataSource>();

  @override
  void initState() {
    super.initState();
    _isBookmarked =
        _dataSource.isBookmarked(widget.pageNumber, widget.verseIndex);
  }

  Future<void> _toggleBookmark(
    String surahName,
    int verseNumber,
    String verseContent,
    String verseContentEmaly,
    String tafseerText,
  ) async {
    final checkpointId = '${widget.pageNumber}_${widget.verseIndex}';
    if (_isBookmarked) {
      await _dataSource.remove(checkpointId);
      if (!mounted) return;
      setState(() => _isBookmarked = false);
      SnackbarHelper.showSuccess(
        context,
        message: context.strings.bookmarkRemoved,
      );
    } else {
      final checkpoint = QuranCheckpointModel(
        surahName: surahName,
        verseNumber: verseNumber,
        verseContent: verseContent,
        verseContentEmaly: verseContentEmaly,
        pageNumber: widget.pageNumber,
        verseIndex: widget.verseIndex,
        createdAt: DateTime.now(),
        tafseer: tafseerText.isNotEmpty ? tafseerText : null,
      );
      await _dataSource.save(checkpoint);
      if (!mounted) return;
      setState(() => _isBookmarked = true);
      SnackbarHelper.showSuccess(
        context,
        message: context.strings.bookmarkSaved,
      );
    }
  }

  void _shareVerse(
    String surahName,
    int verseNumber,
    String verseText,
    String tafseerText,
  ) {
    if (tafseerText.isNotEmpty) {
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.transparent,
        builder: (_) => QuranVerseShareOptionsSheetWidget(
          onShareVerseOnly: () => _performShare(
            '﴿ $verseText ﴾\n[$surahName : $verseNumber]',
          ),
          onShareWithTafseer: () => _performShare(
            '﴿ $verseText ﴾\n[$surahName : $verseNumber]\n\n${context.strings.quranTafseer}:\n$tafseerText',
          ),
        ),
      );
    } else {
      _performShare('﴿ $verseText ﴾\n[$surahName : $verseNumber]');
    }
  }

  void _performShare(String text) {
    final box = context.findRenderObject() as RenderBox?;
    final sharePositionOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    SharePlus.instance.share(
      ShareParams(text: text, sharePositionOrigin: sharePositionOrigin),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final surahsNames = widget.pageData.surahsNames ?? [];
    final versesNumbers = widget.pageData.versesNumbers ?? [];
    final versesContentEmaly = widget.pageData.versesContentEmaly ?? [];
    final versesContent = widget.pageData.versesContent ?? [];
    final tafseers = widget.pageData.tafseer ?? [];

    final surahName = (widget.verseIndex < surahsNames.length)
        ? surahsNames[widget.verseIndex]
        : '';
    final verseNumber = (widget.verseIndex < versesNumbers.length)
        ? versesNumbers[widget.verseIndex]
        : (widget.verseIndex + 1);
    final verseText = (widget.verseIndex < versesContentEmaly.length)
        ? versesContentEmaly[widget.verseIndex]
        : ((widget.verseIndex < versesContent.length)
            ? versesContent[widget.verseIndex]
            : '');
    final smartVerseContent = (widget.verseIndex < versesContent.length)
        ? versesContent[widget.verseIndex]
        : verseText;
    final tafseerText =
        (widget.verseIndex < tafseers.length)
            ? tafseers[widget.verseIndex]
            : '';

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
                isBookmarked: _isBookmarked,
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
                      'pageData': widget.pageData,
                      'pageNum': widget.pageNumber,
                      'highlightVerse': verseNumber,
                    },
                  );
                },
                onShare: () => _shareVerse(
                  surahName,
                  verseNumber,
                  verseText,
                  tafseerText,
                ),
                onToggleBookmark: () => _toggleBookmark(
                  surahName,
                  verseNumber,
                  smartVerseContent,
                  verseText,
                  tafseerText,
                ),
              ),
              8.ver,
            ],
          ),
        ),
      ),
    );
  }
}
