import 'package:flutter/material.dart';
import '../../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/di/injector.dart';
import '../../data/models/book_models.dart';
import '../../data/repositories/book_repository.dart';
import '../widgets/book_cover_card.dart';
import '../../../../core/widgets/loading_overlay.dart';
import 'book_content_page.dart';

class AhadithPage extends StatefulWidget {
  const AhadithPage({super.key});

  @override
  State<AhadithPage> createState() => _AhadithPageState();
}

class _AhadithPageState extends State<AhadithPage> {
  final Set<String> _downloadedBooks = {};
  final Set<String> _downloadingBooks = {};
  late BookRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = injector<BookRepository>();
    _checkDownloads();
  }

  Future<void> _checkDownloads() async {
    final allBooks = [
      ...BookRepository.nineBooks,
      ...BookRepository.fortyBooks,
    ];

    for (var book in allBooks) {
      final isDownloaded = await _repository.isBookDownloaded(book.id);
      if (isDownloaded && mounted) {
        setState(() {
          _downloadedBooks.add(book.id);
        });
      }
    }
  }

  Future<void> _handleBookTap(BookInfo book) async {
    if (_downloadedBooks.contains(book.id)) {
      _openBook(book);
    } else {
      _showDownloadDialog(book);
    }
  }

  void _openBook(BookInfo book) {
    String title = book.titleKey;
    if (context.mounted) {
      title = _resolveTitle(context, book.titleKey);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BookContentPage(bookId: book.id, bookTitle: title),
      ),
    );
  }

  String _resolveTitle(BuildContext context, String key) {
    // Dynamic lookup via reflection is not possible on AppLocalizations.
    // Manual mapping or just rely on passing key if we had a Translate widget.
    // For now, mapping.
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

  Future<void> _showDownloadDialog(BookInfo book) async {
    final bool? shouldDownload = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.strings.download),
        content: Text(
          '${context.strings.downloading} ${_resolveTitle(context, book.titleKey)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.strings.download),
          ),
        ],
      ),
    );

    if (shouldDownload == true) {
      await _downloadBook(book);
    }
  }

  Future<void> _downloadBook(BookInfo book) async {
    setState(() {
      _downloadingBooks.add(book.id);
    });

    try {
      await _repository.downloadBook(book);
      if (mounted) {
        setState(() {
          _downloadingBooks.remove(book.id);
          _downloadedBooks.add(book.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.download_success)),
        );
        _openBook(book);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _downloadingBooks.remove(book.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.strings.download_failed}: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: context.colors.surface,
          appBar: AppBar(
            title: Text(
              context.strings.ahadith,
              style: AppTextStyles.notoKufiArabicHeading24.copyWith(
                color: context.colors.onSurface,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: CustomScrollView(
            slivers: [
              // Section Reference: 9 Books
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      context.strings.ahadith,
                      style: AppTextStyles.notoKufiArabicHeading20.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final book = BookRepository.nineBooks[index];
                    return BookCoverCard(
                      book: book,
                      isDownloaded: _downloadedBooks.contains(book.id),
                      isDownloading: _downloadingBooks.contains(book.id),
                      onTap: () => _handleBookTap(book),
                    );
                  }, childCount: BookRepository.nineBooks.length),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Section Reference: Forties
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "المجاميع", // Collections
                      style: AppTextStyles.notoKufiArabicHeading20.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final book = BookRepository.fortyBooks[index];
                    return BookCoverCard(
                      book: book,
                      isDownloaded: _downloadedBooks.contains(book.id),
                      isDownloading: _downloadingBooks.contains(book.id),
                      onTap: () => _handleBookTap(book),
                    );
                  }, childCount: BookRepository.fortyBooks.length),
                ),
              ),
            ],
          ),
        ),
        if (_downloadingBooks.isNotEmpty)
          LoadingOverlay(message: context.strings.downloading),
      ],
    );
  }
}
