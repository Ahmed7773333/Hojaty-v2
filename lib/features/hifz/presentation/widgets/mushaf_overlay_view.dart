import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_ayah_content.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_mushaf_mask_painter.dart';
import 'package:hojaty/features/quran/constants/mushaf_page_image_resolver.dart';
import 'package:hojaty/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:hojaty/features/quran/presentation/widgets/mushaf_night_mode_page_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_page_placeholder_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_verse_highlight_painter.dart';
import 'package:material_ui/material_ui.dart';

class MushafOverlayView extends StatefulWidget {
  final List<HifzAyahContent> ayahs;
  final int activeGlobalAyahId;
  final bool isTestingMode;
  final Set<int> revealedAyahs;
  final ValueChanged<int> onTapAyah;

  const MushafOverlayView({
    super.key,
    required this.ayahs,
    required this.activeGlobalAyahId,
    required this.isTestingMode,
    required this.revealedAyahs,
    required this.onTapAyah,
  });

  @override
  State<MushafOverlayView> createState() => _MushafOverlayViewState();
}

class _MushafOverlayViewState extends State<MushafOverlayView> {
  late final PageController _pageController;
  late List<int> _pages;

  @override
  void initState() {
    super.initState();
    _pages = _extractPages();
    final initialIdx = _indexOfActivePage();
    _pageController = PageController(initialPage: initialIdx);
  }

  List<int> _extractPages() {
    final unique = <int>[];
    for (final a in widget.ayahs) {
      if (!unique.contains(a.pageNumber)) {
        unique.add(a.pageNumber);
      }
    }
    if (unique.isEmpty) return [1];
    return unique;
  }

  int _indexOfActivePage() {
    for (final a in widget.ayahs) {
      if (a.globalAyahId == widget.activeGlobalAyahId) {
        final idx = _pages.indexOf(a.pageNumber);
        if (idx != -1) return idx;
      }
    }
    return 0;
  }

  @override
  void didUpdateWidget(covariant MushafOverlayView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _pages = _extractPages();
    if (oldWidget.activeGlobalAyahId != widget.activeGlobalAyahId &&
        _pageController.hasClients) {
      final targetIdx = _indexOfActivePage();
      final currentPage = _pageController.page?.round() ?? 0;
      if (targetIdx != currentPage) {
        _pageController.animateToPage(
          targetIdx,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleTapOnPage(
    TapUpDetails details,
    Size renderSize,
    int pageNumber,
  ) {
    if (renderSize.width <= 0 || renderSize.height <= 0) return;
    final nx = details.localPosition.dx / renderSize.width;
    final ny = details.localPosition.dy / renderSize.height;

    for (final ayah in widget.ayahs) {
      if (ayah.pageNumber != pageNumber) continue;
      for (final rect in ayah.bounds) {
        if (rect.length >= 4 &&
            nx >= rect[0] &&
            nx <= rect[2] &&
            ny >= rect[1] &&
            ny <= rect[3]) {
          widget.onTapAyah(ayah.globalAyahId);
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final quranState = context.watch<QuranBloc>().state;
    final backgroundColor = isDark
        ? AppColors.mushafNightBackground
        : AppColors.mushafLightBackground;

    return PageView.builder(
      controller: _pageController,
      reverse: true,
      itemCount: _pages.length,
      itemBuilder: (context, index) {
        final pageNumber = _pages[index];
        final imageProvider = MushafPageImageResolver.resolve(
          pageNumber,
          basePath: quranState.assetsPath,
          qirat: quranState.selectedQirat,
        );

        final activeRects = <List<double>>[];
        final maskedRects = <List<List<double>>>[];

        for (final ayah in widget.ayahs) {
          if (ayah.pageNumber != pageNumber || ayah.bounds.isEmpty) continue;
          if (ayah.globalAyahId == widget.activeGlobalAyahId) {
            activeRects.addAll(ayah.bounds);
          }
          if (widget.isTestingMode &&
              !widget.revealedAyahs.contains(ayah.globalAyahId)) {
            maskedRects.add(ayah.bounds);
          }
        }

        final pageImage = isDark
            ? MushafNightModePageWidget(
                imageProvider: imageProvider,
                pageNumber: pageNumber,
              )
            : Image(
                image: imageProvider,
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return QuranPagePlaceholderWidget(pageNumber: pageNumber);
                },
              );

        return LayoutBuilder(
          builder: (context, constraints) {
            final renderSize = Size(
              constraints.maxWidth,
              constraints.maxHeight,
            );
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (details) =>
                  _handleTapOnPage(details, renderSize, pageNumber),
              child: ColoredBox(
                color: backgroundColor,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    pageImage,
                    if (activeRects.isNotEmpty)
                      IgnorePointer(
                        child: CustomPaint(
                          size: renderSize,
                          painter: QuranVerseHighlightPainter(
                            rects: activeRects,
                            highlightColor: AppColors.accentGold.withValues(
                              alpha: 0.34,
                            ),
                          ),
                        ),
                      ),
                    if (maskedRects.isNotEmpty)
                      IgnorePointer(
                        child: CustomPaint(
                          size: renderSize,
                          painter: HifzMushafMaskPainter(
                            maskedBounds: maskedRects,
                            maskColor: isDark
                                ? AppColors.darkSurface.withValues(alpha: 0.94)
                                : AppColors.lightCardSelected.withValues(
                                    alpha: 0.95,
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

