import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../data/models/quraan_page_model.dart';

class QuraanViewWidget extends StatefulWidget {
  final int initialPage;
  final bool isTwoPageMode;
  final Map<int, QuraanPageModel> quranData;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onToggleOverlay;

  const QuraanViewWidget({
    super.key,
    required this.initialPage,
    required this.isTwoPageMode,
    required this.quranData,
    required this.onPageChanged,
    required this.onToggleOverlay,
  });

  @override
  State<QuraanViewWidget> createState() => _QuraanViewWidgetState();
}

class _QuraanViewWidgetState extends State<QuraanViewWidget> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Quran pages are 1-based.
    // In LTR, PageView index 0 is left. In RTL, index 0 is right.
    // We typically want to swipe right to go to next page (1 -> 2).
    // But PageView follows directionality. Quran is usually RTL.
    // If usage is 1-based page, we need to map logic.
    // Let's assume standard PageView:
    // Index 0 -> Page 1
    // Index 1 -> Page 2
    // If TwoPageMode:
    // Index 0 -> Page 1 & 2? Or Page 0 & 1?
    _initController();
  }

  void _initController() {
    int initialIndex;
    if (widget.isTwoPageMode) {
      // Index 0: Page 1, 2
      // Index 1: Page 3, 4
      // So page 1 -> index 0. Page 2 -> index 0. Page 3 -> index 1.
      initialIndex = (widget.initialPage - 1) ~/ 2;
    } else {
      initialIndex = widget.initialPage - 1;
    }
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  void didUpdateWidget(QuraanViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isTwoPageMode != widget.isTwoPageMode) {
      // Re-calculate index when mode changes
      /*
        If was single (Page 5, index 4).
        Now double (Page 5, index 2).
       */
      final newIndex = widget.isTwoPageMode
          ? (widget.initialPage - 1) ~/ 2
          : (widget.initialPage - 1);
      if (_pageController.hasClients) {
        _pageController.jumpToPage(newIndex);
      } else {
        _pageController = PageController(initialPage: newIndex);
      }
    } else if (oldWidget.initialPage != widget.initialPage) {
      // If external jump logic provided
      final targetIndex = widget.isTwoPageMode
          ? (widget.initialPage - 1) ~/ 2
          : (widget.initialPage - 1);
      if (_pageController.hasClients &&
          _pageController.page?.round() != targetIndex) {
        _pageController.jumpToPage(targetIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine total count
    const totalPages = 604;
    final itemCount = widget.isTwoPageMode
        ? (totalPages / 2).ceil()
        : totalPages;

    return SafeArea(
      child: GestureDetector(
        onTap: widget.onToggleOverlay,
        child: Directionality(
          textDirection: TextDirection.rtl, // Quran is RTL
          child: PageView.builder(
            controller: _pageController,
            itemCount: itemCount,
            onPageChanged: (index) {
              // Convert index back to page number
              // Single: index 0 -> page 1
              // Double: index 0 -> page 1 (and 2 displayed)
              int pageNum = widget.isTwoPageMode ? (index * 2) + 1 : index + 1;
              widget.onPageChanged(pageNum);
            },
            itemBuilder: (context, index) {
              if (widget.isTwoPageMode) {
                final rightPageNum = (index * 2) + 1;
                final leftPageNum = rightPageNum + 1;
                return Row(
                  children: [
                    Expanded(child: _buildPageImage(rightPageNum)),
                    if (leftPageNum <= totalPages)
                      Expanded(child: _buildPageImage(leftPageNum))
                    else
                      const Expanded(
                        child: SizedBox(),
                      ), // Empty space if last page is odd in pair
                  ],
                );
              } else {
                return _buildPageImage(index + 1);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageImage(int pageNum) {
    return Container(
      color: const Color(0xFFFFF8E1), // Warm background color for paper feel
      child: Image.asset(
        'assets/pages-hafs/$pageNum.png',
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) =>
            Center(child: Text(context.strings.quranPageNotFound(pageNum))),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
