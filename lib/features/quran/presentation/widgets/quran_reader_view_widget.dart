import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../constants/mushaf_page_image_resolver.dart';
import '../../domain/entities/qirat_type.dart';
import '../utils/mushaf_shader_program_loader.dart';
import 'quran_page_image_widget.dart';

class QuranReaderViewWidget extends StatefulWidget {
  final int initialPage;
  final bool isTwoPageMode;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onToggleOverlay;
  final String? basePath;
  final QiratType qirat;

  const QuranReaderViewWidget({
    super.key,
    required this.initialPage,
    required this.isTwoPageMode,
    required this.onPageChanged,
    required this.onToggleOverlay,
    this.basePath,
    this.qirat = QiratType.hafs,
  });

  @override
  State<QuranReaderViewWidget> createState() => _QuranReaderViewWidgetState();
}

class _QuranReaderViewWidgetState extends State<QuranReaderViewWidget> {
  late PageController _pageController;
  static const int _totalPages = 604;
  int? _lastPrecachedPage;
  String? _lastBasePath;
  QiratType? _lastQirat;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.isDark) {
      MushafShaderProgramLoader.load().then<void>(
        (_) {},
        onError: (Object _) {},
      );
    }
    _precacheAdjacentPages(widget.initialPage);
  }

  void _initController() {
    int initialIndex;
    if (widget.isTwoPageMode) {
      initialIndex = (widget.initialPage - 1) ~/ 2;
    } else {
      initialIndex = widget.initialPage - 1;
    }
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  void didUpdateWidget(QuranReaderViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isTwoPageMode != widget.isTwoPageMode) {
      final newIndex = widget.isTwoPageMode
          ? (widget.initialPage - 1) ~/ 2
          : (widget.initialPage - 1);
      if (_pageController.hasClients) {
        _pageController.jumpToPage(newIndex);
      } else {
        _pageController = PageController(initialPage: newIndex);
      }
      _precacheAdjacentPages(widget.initialPage, force: true);
    } else if (oldWidget.initialPage != widget.initialPage ||
        oldWidget.basePath != widget.basePath ||
        oldWidget.qirat != widget.qirat) {
      final targetIndex = widget.isTwoPageMode
          ? (widget.initialPage - 1) ~/ 2
          : (widget.initialPage - 1);
      if (_pageController.hasClients &&
          _pageController.page?.round() != targetIndex) {
        _pageController.jumpToPage(targetIndex);
      }
      _precacheAdjacentPages(
        widget.initialPage,
        force: oldWidget.basePath != widget.basePath ||
            oldWidget.qirat != widget.qirat,
      );
    }
  }

  void _precacheAdjacentPages(int centerPage, {bool force = false}) {
    if (!force &&
        _lastPrecachedPage == centerPage &&
        _lastBasePath == widget.basePath &&
        _lastQirat == widget.qirat) {
      return;
    }
    _lastPrecachedPage = centerPage;
    _lastBasePath = widget.basePath;
    _lastQirat = widget.qirat;

    final offsets = widget.isTwoPageMode
        ? const [-2, -1, 2, 3]
        : const [-1, 1, 2];

    for (final offset in offsets) {
      final targetPage = centerPage + offset;
      if (targetPage < 1 || targetPage > _totalPages) continue;
      final provider = MushafPageImageResolver.resolve(
        targetPage,
        basePath: widget.basePath,
        qirat: widget.qirat,
      );
      precacheImage(provider, context, onError: (Object _, StackTrace? _) {});
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.isTwoPageMode
        ? (_totalPages / 2).ceil()
        : _totalPages;

    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onToggleOverlay,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: PageView.builder(
            controller: _pageController,
            itemCount: itemCount,
            onPageChanged: (index) {
              final pageNum = widget.isTwoPageMode ? (index * 2) + 1 : index + 1;
              _precacheAdjacentPages(pageNum);
              widget.onPageChanged(pageNum);
            },
            itemBuilder: (context, index) {
              if (widget.isTwoPageMode) {
                final rightPageNum = (index * 2) + 1;
                final leftPageNum = rightPageNum + 1;
                return Row(
                  children: [
                    Expanded(
                      child: QuranPageImageWidget(
                        pageNumber: rightPageNum,
                        basePath: widget.basePath,
                        qirat: widget.qirat,
                      ),
                    ),
                    if (leftPageNum <= _totalPages)
                      Expanded(
                        child: QuranPageImageWidget(
                          pageNumber: leftPageNum,
                          basePath: widget.basePath,
                          qirat: widget.qirat,
                        ),
                      )
                    else
                      const Expanded(child: SizedBox()),
                  ],
                );
              }
              return QuranPageImageWidget(
                pageNumber: index + 1,
                basePath: widget.basePath,
                qirat: widget.qirat,
              );
            },
          ),
        ),
      ),
    );
  }
}
