import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:hojaty/features/books/data/models/book_info_model.dart';
import 'package:hojaty/features/books/data/models/hadith_item_model.dart';

class BookPdfExporter {
  static Future<String> exportAndShareChapterPdf({
    required BookInfoModel book,
    required String chapterTitle,
    required List<HadithItemModel> hadiths,
    Rect? sharePositionOrigin,
  }) async {
    final pdf = pw.Document();

    final regularFontData = await rootBundle.load(
      'assets/fonts/NotoKufiArabic-Regular.ttf',
    );
    final boldFontData = await rootBundle.load(
      'assets/fonts/NotoKufiArabic-Bold.ttf',
    );
    final ttfRegular = pw.Font.ttf(regularFontData);
    final ttfBold = pw.Font.ttf(boldFontData);

    final theme = pw.ThemeData.withFont(base: ttfRegular, bold: ttfBold);

    final goldColor = PdfColor.fromHex('#C5A059');
    final darkPrimaryColor = PdfColor.fromHex('#1B3B2B');
    final darkTextColor = PdfColor.fromHex('#212121');
    final mutedTextColor = PdfColor.fromHex('#616161');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 28),
        theme: theme,
        textDirection: pw.TextDirection.rtl,
        header: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 8),
            margin: const pw.EdgeInsets.only(bottom: 12),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: goldColor, width: 0.8),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  book.titleAr,
                  style: pw.TextStyle(
                    font: ttfBold,
                    fontSize: 11,
                    color: darkPrimaryColor,
                  ),
                ),
                pw.Text(
                  chapterTitle.isNotEmpty ? chapterTitle : book.authorAr,
                  style: pw.TextStyle(
                    font: ttfRegular,
                    fontSize: 10,
                    color: mutedTextColor,
                  ),
                ),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(top: 10),
            padding: const pw.EdgeInsets.only(top: 6),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(
                  color: PdfColor.fromHex('#E8E4D8'),
                  width: 0.6,
                ),
              ),
            ),
            alignment: pw.Alignment.center,
            child: pw.Text(
              '— ${context.pageNumber} / ${context.pagesCount} —',
              style: pw.TextStyle(
                font: ttfRegular,
                fontSize: 9,
                color: mutedTextColor,
              ),
            ),
          );
        },
        build: (pw.Context context) {
          final content = <pw.Widget>[];

          // Chapter Header Block
          content.add(
            pw.Container(
              alignment: pw.Alignment.center,
              padding: const pw.EdgeInsets.only(bottom: 16),
              child: pw.Column(
                children: [
                  pw.Text(
                    book.titleAr,
                    style: pw.TextStyle(
                      font: ttfBold,
                      fontSize: 18,
                      color: darkPrimaryColor,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    book.authorAr,
                    style: pw.TextStyle(
                      font: ttfRegular,
                      fontSize: 12,
                      color: goldColor,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  if (chapterTitle.isNotEmpty) ...[
                    pw.SizedBox(height: 8),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#F5F3E9'),
                        borderRadius: pw.BorderRadius.circular(6),
                        border: pw.Border.all(color: goldColor, width: 0.8),
                      ),
                      child: pw.Text(
                        chapterTitle,
                        style: pw.TextStyle(
                          font: ttfBold,
                          fontSize: 13,
                          color: darkPrimaryColor,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                  pw.SizedBox(height: 14),
                ],
              ),
            ),
          );

          // Hadiths (using spanning Paragraph widgets to avoid page break crashes)
          for (int i = 0; i < hadiths.length; i++) {
            final h = hadiths[i];

            content.add(
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 8, bottom: 4),
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: pw.BoxDecoration(
                    color: darkPrimaryColor,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    'حديث رقم ${h.idInBook > 0 ? h.idInBook : (i + 1)}',
                    style: pw.TextStyle(
                      font: ttfBold,
                      fontSize: 9,
                      color: PdfColors.white,
                    ),
                  ),
                ),
              ),
            );

            content.add(
              pw.Paragraph(
                text: h.arabic,
                style: pw.TextStyle(
                  font: ttfRegular,
                  fontSize: 11.5,
                  lineSpacing: 3.5,
                  color: darkTextColor,
                ),
              ),
            );

            if (h.englishText.isNotEmpty) {
              content.add(
                pw.Paragraph(
                  text: h.englishText,
                  style: pw.TextStyle(
                    font: ttfRegular,
                    fontSize: 9.5,
                    lineSpacing: 2.5,
                    color: mutedTextColor,
                  ),
                ),
              );
            }

            if (i < hadiths.length - 1) {
              content.add(
                pw.Container(
                  margin: const pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Divider(
                    color: PdfColor.fromHex('#E0DCCF'),
                    thickness: 0.5,
                  ),
                ),
              );
            }
          }

          return content;
        },
      ),
    );

    final bytes = await pdf.save();
    final tempDir = await getTemporaryDirectory();
    final safeFileName =
        '${book.id}_chapter_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${tempDir.path}/$safeFileName');
    await file.writeAsBytes(bytes);

    final shareText =
        '${book.titleAr} - ${chapterTitle.isNotEmpty ? chapterTitle : book.authorAr}';

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: shareText,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );

    return file.path;
  }
}
