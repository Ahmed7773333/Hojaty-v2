import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/features/quraan/data/services/quraan_pad_service.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../data/models/page_data.dart';
import '../../domain/entities/qirat_type.dart';
import '../../domain/repositories/quraan_repository.dart';

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
    // Listen to selected Qirat changes
    return Container(
      color: context.isDarkMode
          ? AppColor.darkBackground
          : const Color(0xFFFFF8E1),
      child: StreamBuilder<QiratType>(
        stream: injector<QuraanRepository>().watchSelectedQirat(),
        builder: (context, qiratSnapshot) {
          // If no data yet (stream waiting), check current value or default
          // But actually we can just fetch once or wait.
          // Better: use FutureBuilder inside to fetch current if stream is empty?
          // Or just default to Hafs if waiting.
          // Since watch only emits on change, we need an initial value.
          // We can use a combined approach or just FutureBuilder that re-runs when stream emits?
          // StreamBuilder re-builds on event.
          // If we want initial value, we need `initialData`. We can't easily get it sync.
          // So we use a nested FutureBuilder for the image path which depends on the qirat.

          // To solve "initial data" for StreamBuilder: we can just fetch it.
          // But simply: let's resolve the path with the "latest" qirat we know.
          // IF stream snapshot has data, use it. Else use Future to get it.

          return FutureBuilder<QiratType>(
            future: qiratSnapshot.hasData
                ? Future.value(qiratSnapshot.data)
                : injector<QuraanRepository>().getSelectedQirat(),
            builder: (context, qiratAsync) {
              if (!qiratAsync.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final currentQirat = qiratAsync.data!;

              return FutureBuilder<String?>(
                future: injector<QuraanPadService>().getPageImagePath(
                  pageNum,
                  qirat: currentQirat,
                ),
                builder: (context, snapshot) {
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
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data == null) {
                    return Center(child: Text("Page $pageNum not found"));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
          );
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
