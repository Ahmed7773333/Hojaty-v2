import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/features/quraan/data/services/quraan_pad_service.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
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
    // Using FutureBuilder to fetch path from PAD service
    final isDark = context.isDarkMode;
    return Container(
      color: isDark
          ? AppColor.darkBackground
          : const Color(0xFFFFF8E1), // Warm background color for paper feel
      child: FutureBuilder<String?>(
        future: injector<QuraanPadService>().getPageImagePath(pageNum),
        builder: (context, snapshot) {
          // If we have data (path)
          if (snapshot.hasData && snapshot.data != null) {
            return Image.file(
              File(snapshot.data!),
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text("Page $pageNum error"));
              },
            );
          }
          // Loading or missing
          // If connection state is done and no data, it means missing
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == null) {
            return Center(child: Text("Page $pageNum not found"));
          }

          // Show loading indicator or maybe placeholder while checking path?
          // Accessing local file path should be fast, but it's async.
          return const Center(child: CircularProgressIndicator());
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
