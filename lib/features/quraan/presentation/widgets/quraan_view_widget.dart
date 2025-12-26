import 'package:flutter/material.dart';
import '../../data/models/page_data.dart';

class QuraanViewWidget extends StatefulWidget {
  final int initialPage;
  final bool isTwoPageMode;
  final Map<int, PageData> quranData;
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
    _initController();
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
  void didUpdateWidget(QuraanViewWidget oldWidget) {
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
    } else if (oldWidget.initialPage != widget.initialPage) {
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
                      const Expanded(child: SizedBox()),
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
        errorBuilder: (context, error, stackTrace) {
          // Fallback to text if image fails or missing?
          // For now just error text.
          return Center(child: Text("Page $pageNum not found"));
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
