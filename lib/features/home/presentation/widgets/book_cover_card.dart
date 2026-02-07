import 'package:flutter/material.dart';
import 'package:hojaty/config/theme/app_text_styles.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../data/models/book_models.dart';

class BookCoverCard extends StatelessWidget {
  final BookInfo book;
  final bool isDownloaded;
  final VoidCallback onTap;
  final bool isDownloading;

  const BookCoverCard({
    super.key,
    required this.book,
    required this.isDownloaded,
    required this.onTap,
    this.isDownloading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get translated title
    final String title = _getBookTitle(context, book.titleKey);

    return GestureDetector(
      onTap: isDownloading ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colors.primary.withOpacity(0.8),
              context.colors.primaryContainer,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Book Pattern/Texture (Optional)
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 100,
                  color: context.colors.onPrimaryContainer,
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.notoKufiArabicHeading20.copyWith(
                          color: context.colors.onPrimary,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isDownloading)
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.colors.onPrimary,
                      ),
                    )
                  else if (!isDownloaded)
                    Icon(
                      Icons.cloud_download_outlined,
                      color: context.colors.onPrimary.withOpacity(0.8),
                    )
                  else
                    Icon(
                      Icons.check_circle_outline,
                      color: context.colors.onPrimary.withOpacity(0.8),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBookTitle(BuildContext context, String key) {
    // Map keys to context.strings properties dynamically if possible,
    // otherwise manual mapping or verify keys exist in context.strings.
    // Since AppLocalizations usually generates getters, we can't access by string key dynamically easily
    // without a map.
    // However, I can genericize this or just use a switch/map here or better yet,
    // modify the `BookInfo` to hold the translated string passed from parent.
    // Re-checking how I set up `titleKey`.
    // I'll assume the parent passes the translated title or I handle it here.
    // For now, I'll pass the *key* and try to lookup.
    // Actually, cleaner is to have the parent resolve the translation.
    // But `BookInfo` has `titleKey`.

    // Quick map for generated getters
    switch (key) {
      case 'book_bukhari':
        return context.strings.book_bukhari;
      case 'book_muslim':
        return context.strings.book_muslim;
      case 'book_nasai':
        return context.strings.book_nasai;
      case 'book_abudawud':
        return context.strings.book_abudawud;
      case 'book_tirmidhi':
        return context.strings.book_tirmidhi;
      case 'book_ibnmajah':
        return context.strings.book_ibnmajah;
      case 'book_malik':
        return context.strings.book_malik;
      case 'book_ahmed':
        return context.strings.book_ahmed;
      case 'book_darimi':
        return context.strings.book_darimi;
      case 'book_nawawi40':
        return context.strings.book_nawawi40;
      case 'book_qudsi40':
        return context.strings.book_qudsi40;
      case 'book_shahwaliullah40':
        return context.strings.book_shahwaliullah40;
      case 'book_riyad':
        return context.strings.book_riyad;
      case 'book_bulugh':
        return context.strings.book_bulugh;
      case 'book_mishkat':
        return context.strings.book_mishkat;
      case 'book_adab':
        return context.strings.book_adab;
      case 'book_shamail':
        return context.strings.book_shamail;
      default:
        return key;
    }
  }
}
