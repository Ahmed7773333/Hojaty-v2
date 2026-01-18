import 'package:flutter/material.dart';
import 'package:hojaty/config/theme/app_text_styles.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../data/models/book_models.dart';
import '../../data/repositories/book_repository.dart';

class BookContentPage extends StatelessWidget {
  final String bookId;
  final String bookTitle;

  const BookContentPage({
    super.key,
    required this.bookId,
    required this.bookTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: Text(
          bookTitle,
          style: AppTextStyles.notoKufiArabicHeading20.copyWith(
            color: context.colors.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: context.colors.onSurface),
      ),
      body: FutureBuilder<BookCollection>(
        future: injector<BookRepository>().getBook(bookId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${context.strings.errorMessage}: ${snapshot.error}',
                style: TextStyle(color: context.colors.error),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(child: Text(context.strings.no_hadith_found));
          }

          final book = snapshot.data!;
          // If chapters exist, show chapters list. Otherwise hadiths.
          // Note: Some books like 40 hadiths might have 1 dummy chapter or 0.
          // Logic: if chapters.length > 1, show chapters.
          // Else show all hadiths.

          final bool showChapters = book.chapters.length > 1;

          if (showChapters) {
            return _ChaptersList(book: book);
          } else {
            return _HadithsList(hadiths: book.hadiths);
          }
        },
      ),
    );
  }
}

class _ChaptersList extends StatelessWidget {
  final BookCollection book;

  const _ChaptersList({required this.book});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: book.chapters.length,
      itemBuilder: (context, index) {
        final chapter = book.chapters[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text(
              chapter.arabic,
              style: AppTextStyles.notoKufiArabicBody13Medium.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            trailing: CircleAvatar(
              backgroundColor: context.colors.primaryContainer,
              child: Text(
                '${index + 1}',
                style: TextStyle(color: context.colors.onPrimaryContainer),
              ),
            ),
            onTap: () {
              // Filter hadiths for this chapter
              final chapterHadiths = book.hadiths
                  .where((h) => h.chapterId == chapter.id)
                  .toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(title: Text(chapter.arabic)),
                    body: _HadithsList(hadiths: chapterHadiths),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _HadithsList extends StatelessWidget {
  final List<HadithItem> hadiths;

  const _HadithsList({required this.hadiths});

  @override
  Widget build(BuildContext context) {
    if (hadiths.isEmpty) {
      return Center(child: Text(context.strings.no_hadith_found));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: hadiths.length,
      separatorBuilder: (context, index) => const Divider(height: 32),
      itemBuilder: (context, index) {
        final hadith = hadiths[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hadith Number
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: context.colors.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${context.strings.hadith_number} ${hadith.idInBook}',
                style: TextStyle(
                  color: context.colors.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            // Arabic Text
            Text(
              hadith.arabic,
              style: AppTextStyles.hafsSmartStyle.copyWith(
                fontSize: 20,
                color: context.colors.onSurface,
                height: 1.8,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            if (hadith.english.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              // English Text
              Text(
                hadith.english.text,
                style: AppTextStyles.elgharibStyle.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
              ),
            ],
          ],
        );
      },
    );
  }
}
