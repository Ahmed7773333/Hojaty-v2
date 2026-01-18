import 'package:flutter/material.dart';
import '../../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/di/injector.dart';
import '../../data/models/book_models.dart';
import '../../data/repositories/book_repository.dart';
import '../widgets/book_cover_card.dart';
import 'book_content_page.dart';

class ProphetsStoriesPage extends StatefulWidget {
  const ProphetsStoriesPage({super.key});

  @override
  State<ProphetsStoriesPage> createState() => _ProphetsStoriesPageState();
}

class _ProphetsStoriesPageState extends State<ProphetsStoriesPage> {
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
    const allBooks = BookRepository.otherBooks;

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
    switch (key) {
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
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: Text(
          "كتب أخرى", // Other Books. Or Prophets Stories if desired, but content is specific.
          // Ideally use a key like `prophets_stories` if available, or `other_books`.
          // I'll stick to a hardcoded string or context.strings key if I added one.
          // I didn't add `other_books` key. I'll use Arabic directly for now.
          // context.strings.prophets_stories // Assuming it might exist from user's old code?
          // I'll check if I can use general title.
          // Staying safe with generic term.
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
                final book = BookRepository.otherBooks[index];
                return BookCoverCard(
                  book: book,
                  isDownloaded: _downloadedBooks.contains(book.id),
                  isDownloading: _downloadingBooks.contains(book.id),
                  onTap: () => _handleBookTap(book),
                );
              }, childCount: BookRepository.otherBooks.length),
            ),
          ),
        ],
      ),
    );
  }
}
