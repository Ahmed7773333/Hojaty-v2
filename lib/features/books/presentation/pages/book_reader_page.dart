import 'package:flutter/material.dart';
import 'package:hojaty/features/books/data/models/book_page_model.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../data/models/book_collection_model.dart';
import '../../data/models/book_info_model.dart';
import '../../data/models/book_reader_theme_model.dart';
import '../../data/repositories/books_repository.dart';
import '../../domain/utils/book_paginator.dart';
import '../widgets/book_reader/book_page_leaf_widget.dart';
import '../widgets/book_reader/book_reader_bottom_bar_widget.dart';
import '../widgets/book_reader/book_reader_header_widget.dart';
import '../widgets/book_reader/book_reader_jump_dialog.dart';
import '../widgets/book_reader/book_reader_search_sheet.dart';
import '../widgets/book_reader/book_reader_settings_sheet.dart';
import '../widgets/book_reader/book_reader_share_sheet.dart';
import '../widgets/book_reader/book_reader_toc_sheet.dart';

class BookReaderPage extends StatefulWidget {
  final BookInfoModel book;
  final BookCollectionModel collection;
  final int? initialChapterId;
  final int? initialHadithId;
  final bool scopedToChapter;

  const BookReaderPage({
    super.key,
    required this.book,
    required this.collection,
    this.initialChapterId,
    this.initialHadithId,
    this.scopedToChapter = false,
  });

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  late final BookPaginationResult _paginationResult;
  late final PageController _pageController;
  late int _currentPage;
  bool _showOverlay = true;
  BookReaderThemeMode _themeMode = BookReaderThemeMode.vintage;
  double _fontSize = 17.0;
  bool _showEnglish = false;

  @override
  void initState() {
    super.initState();
    _paginationResult = BookPaginator.paginate(
      collection: widget.collection,
      scopedChapterId: widget.scopedToChapter ? widget.initialChapterId : null,
    );

    int startPage = 1;
    if (widget.initialHadithId != null) {
      startPage = _paginationResult.hadithPages[widget.initialHadithId] ?? 1;
    } else if (widget.initialChapterId != null) {
      startPage = _paginationResult.chapterStartPages[widget.initialChapterId] ?? 1;
    }

    if (_paginationResult.pages.isEmpty) {
      _currentPage = 1;
      _pageController = PageController();
    } else {
      _currentPage = startPage.clamp(1, _paginationResult.pages.length);
      _pageController = PageController(initialPage: _currentPage - 1);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleOverlay() {
    setState(() => _showOverlay = !_showOverlay);
  }

  void _jumpToPage(int page) {
    if (page < 1 || page > _paginationResult.pages.length) return;
    setState(() => _currentPage = page);
    _pageController.jumpToPage(page - 1);
  }

  void _previousPage() {
    if (_currentPage > 1) {
      _jumpToPage(_currentPage - 1);
    }
  }

  void _nextPage() {
    if (_currentPage < _paginationResult.pages.length) {
      _jumpToPage(_currentPage + 1);
    }
  }

  void _openToc() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookReaderTocSheet(
        chapters: widget.collection.chapters,
        chapterStartPages: _paginationResult.chapterStartPages,
        currentChapterId: _getCurrentPageModel()?.chapterId ?? 0,
        onSelectChapterPage: _jumpToPage,
      ),
    );
  }

  void _openSearch() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookReaderSearchSheet(
        hadiths: widget.collection.hadiths,
        hadithPages: _paginationResult.hadithPages,
        onSelectPage: _jumpToPage,
      ),
    );
  }

  void _openSettings() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookReaderSettingsSheet(
        fontSize: _fontSize,
        currentThemeMode: _themeMode,
        showEnglish: _showEnglish,
        onFontSizeChanged: (double newSize) => setState(() => _fontSize = newSize),
        onThemeChanged: (BookReaderThemeMode newTheme) => setState(() => _themeMode = newTheme),
        onToggleEnglish: (bool val) => setState(() => _showEnglish = val),
      ),
    );
  }

  void _openShare() {
    final pageModel = _getCurrentPageModel();
    if (pageModel == null) return;

    final chapterHadiths = widget.collection.hadiths
        .where((h) => h.chapterId == pageModel.chapterId)
        .toList();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookReaderShareSheet(
        book: widget.book,
        currentPage: pageModel,
        chapterHadiths: chapterHadiths,
      ),
    );
  }

  Future<void> _openPdf() async {
    final repo = injector<BooksRepository>();
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final success = await repo.openBookPdf(widget.book);

      if (!mounted) return;
      Navigator.of(context).pop();

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.pdfNotFound)),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.pdfOpenError)),
        );
      }
    }
  }

  void _openJumpDialog() {
    showDialog(
      context: context,
      builder: (_) => BookReaderJumpDialog(
        currentPage: _currentPage,
        totalPages: _paginationResult.pages.length,
        onJump: _jumpToPage,
      ),
    );
  }

  BookPageModel? _getCurrentPageModel() {
    if (_paginationResult.pages.isEmpty) return null;
    final index = (_currentPage - 1).clamp(0, _paginationResult.pages.length - 1);
    return _paginationResult.pages[index];
  }

  @override
  Widget build(BuildContext context) {
    final theme = BookReaderThemeModel.fromMode(_themeMode);
    final currentPageModel = _getCurrentPageModel();
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final totalPages = _paginationResult.pages.length;

    return Scaffold(
      backgroundColor: theme.background,
      body: totalPages == 0
          ? Center(
              child: Text(
                context.strings.noHadithsFound,
                style: context.textTheme.bodyMedium?.copyWith(color: theme.primaryText),
              ),
            )
          : Stack(
              children: [
                // Horizontal Page View for reading
                PageView.builder(
                  controller: _pageController,
                  itemCount: totalPages,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index + 1);
                  },
                  itemBuilder: (context, index) {
                    final page = _paginationResult.pages[index];
                    return BookPageLeafWidget(
                      page: page,
                      totalPages: totalPages,
                      bookTitle: widget.book.getDisplayTitle(isAr),
                      fontSize: _fontSize,
                      theme: theme,
                      showEnglish: _showEnglish,
                      onTap: _toggleOverlay,
                    );
                  },
                ),

                // Top Header Overlay
                if (_showOverlay)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: BookReaderHeaderWidget(
                      title: widget.book.getDisplayTitle(isAr),
                      chapterTitle: currentPageModel?.chapterTitle ?? '',
                      theme: theme,
                      onBack: () => Navigator.of(context).pop(),
                      onSearch: _openSearch,
                      onToc: _openToc,
                      onSettings: _openSettings,
                      onShare: _openShare,
                      onOpenPdf: widget.book.hasPdf ? _openPdf : null,
                    ),
                  ),

                // Bottom Navigation Overlay
                if (_showOverlay)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: BookReaderBottomBarWidget(
                      currentPage: _currentPage,
                      totalPages: totalPages,
                      theme: theme,
                      onPageChanged: _jumpToPage,
                      onPreviousPage: _previousPage,
                      onNextPage: _nextPage,
                      onJumpToPage: _openJumpDialog,
                    ),
                  ),
              ],
            ),
    );
  }
}

