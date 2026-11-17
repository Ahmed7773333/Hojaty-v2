import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/features/books/data/models/book_info_model.dart';
import 'package:hojaty/features/books/data/models/book_page_model.dart';
import 'package:hojaty/features/books/data/models/hadith_item_model.dart';
import 'package:hojaty/features/books/domain/utils/book_pdf_exporter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class BookReaderShareSheet extends StatefulWidget {
  final BookInfoModel book;
  final BookPageModel currentPage;
  final List<HadithItemModel> chapterHadiths;

  const BookReaderShareSheet({
    super.key,
    required this.book,
    required this.currentPage,
    required this.chapterHadiths,
  });

  @override
  State<BookReaderShareSheet> createState() => _BookReaderShareSheetState();
}

class _BookReaderShareSheetState extends State<BookReaderShareSheet> {
  bool _isExporting = false;

  void _sharePageText() {
    final buffer = StringBuffer();
    buffer.writeln(
      '${widget.book.titleAr} - ${widget.currentPage.chapterTitle}',
    );
    buffer.writeln('--------------------');
    for (final h in widget.currentPage.hadiths) {
      buffer.writeln('« حديث رقم ${h.idInBook > 0 ? h.idInBook : h.id} »');
      buffer.writeln(h.arabic);
      if (h.englishText.isNotEmpty) {
        buffer.writeln();
        buffer.writeln(h.englishText);
      }
      buffer.writeln();
    }
    buffer.writeln('تطبيق حجتي');

    final box = context.findRenderObject() as RenderBox?;
    final sharePositionOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    Navigator.of(context).pop();
    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }

  Future<void> _exportChapterPdf() async {
    setState(() => _isExporting = true);
    try {
      final box = context.findRenderObject() as RenderBox?;
      final sharePositionOrigin = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : null;

      await BookPdfExporter.exportAndShareChapterPdf(
        book: widget.book,
        chapterTitle: widget.currentPage.chapterTitle,
        hadiths: widget.chapterHadiths.isNotEmpty
            ? widget.chapterHadiths
            : widget.currentPage.hadiths,
        sharePositionOrigin: sharePositionOrigin,
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e, stack) {
      if (mounted) {
        setState(() => _isExporting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.pdfExportFailed)),
        );
      }
      log('PDF Export Error: $e\n$stack');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkBorderUnselected
                    : AppColors.lightBorderUnselected,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.strings.sharePdf,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          16.ver,
          if (_isExporting) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Column(
                children: [
                  const CircularProgressIndicator(color: AppColors.accentGold),
                  16.ver,
                  Text(
                    context.strings.exportingPdf,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDarkSurface
                      : AppColors.lightCardSelected,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.text_snippet_rounded,
                  color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                ),
              ),
              title: Text(
                context.strings.shareCurrentPage,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'مشاركة نص الأحاديث المعروضة في الصفحة الحالية',
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              onTap: _sharePageText,
            ),
            12.ver,
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDarkSurface
                      : AppColors.lightCardSelected,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.picture_as_pdf_rounded,
                  color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                ),
              ),
              title: Text(
                context.strings.shareCurrentChapterPdf,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'تصدير أحاديث الباب الحالي كملف PDF بتنسيق كتاب فاخر',
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              onTap: _exportChapterPdf,
            ),
          ],
          16.ver,
        ],
      ),
    );
  }
}
