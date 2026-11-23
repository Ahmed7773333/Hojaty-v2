import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/features/quran/constants/mushaf_page_image_resolver.dart';
import 'package:hojaty/features/quran/data/models/page_data_model.dart';
import 'package:hojaty/features/quran/domain/entities/qirat_type.dart';
import 'package:hojaty/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:hojaty/features/quran/presentation/widgets/mushaf_night_mode_page_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_page_placeholder_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_verse_action_bottom_sheet_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_verse_highlight_painter.dart';

class QuranPageImageWidget extends StatefulWidget {
  final int pageNumber;
  final PageDataModel? pageData;
  final String? basePath;
  final QiratType qirat;
  final VoidCallback? onToggleOverlay;
  final int? initialHighlightVerseIndex;

  const QuranPageImageWidget({
    super.key,
    required this.pageNumber,
    this.pageData,
    this.basePath,
    this.qirat = QiratType.hafs,
    this.onToggleOverlay,
    this.initialHighlightVerseIndex,
  });

  @override
  State<QuranPageImageWidget> createState() => _QuranPageImageWidgetState();
}

class _QuranPageImageWidgetState extends State<QuranPageImageWidget>
    with SingleTickerProviderStateMixin {
  int? _selectedVerseIndex;
  late AnimationController _highlightAnimController;
  late Animation<double> _highlightOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _highlightAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _highlightOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.45)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.45, end: 0.20)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.20, end: 0.45)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.45, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
    ]).animate(_highlightAnimController);

    _highlightAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _selectedVerseIndex = null;
        });
      }
    });

    if (widget.initialHighlightVerseIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _triggerLightShow(widget.initialHighlightVerseIndex!);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant QuranPageImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageNumber != widget.pageNumber) {
      _highlightAnimController.stop();
      _selectedVerseIndex = null;
    }

    if (widget.initialHighlightVerseIndex != null &&
        widget.initialHighlightVerseIndex !=
            oldWidget.initialHighlightVerseIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _triggerLightShow(widget.initialHighlightVerseIndex!);
        }
      });
    }
  }

  @override
  void dispose() {
    _highlightAnimController.dispose();
    super.dispose();
  }

  void _triggerLightShow(int verseIndex) {
    setState(() {
      _selectedVerseIndex = verseIndex;
    });
    _highlightAnimController.forward(from: 0.0);
  }

  PageDataModel? _resolvePageData() {
    if (widget.pageData != null) return widget.pageData;
    try {
      return context.read<QuranBloc>().state.quranPages[widget.pageNumber];
    } catch (_) {
      return null;
    }
  }

  void _onTap() {
    if (_highlightAnimController.isAnimating) {
      _highlightAnimController.stop();
    }
    if (_selectedVerseIndex != null) {
      setState(() {
        _selectedVerseIndex = null;
      });
    } else {
      widget.onToggleOverlay?.call();
    }
  }

  void _onLongPressStart(LongPressStartDetails details, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final nx = details.localPosition.dx / size.width;
    final ny = details.localPosition.dy / size.height;

    final pageData = _resolvePageData();
    final versesBounds = pageData?.versesBounds;
    if (versesBounds == null || versesBounds.isEmpty) return;

    int? hitIndex;
    for (int i = 0; i < versesBounds.length; i++) {
      final rects = versesBounds[i];
      for (final rect in rects) {
        if (rect.length >= 4) {
          final left = rect[0];
          final top = rect[1];
          final right = rect[2];
          final bottom = rect[3];
          if (nx >= left && nx <= right && ny >= top && ny <= bottom) {
            hitIndex = i;
            break;
          }
        }
      }
      if (hitIndex != null) break;
    }

    if (hitIndex != null) {
      _selectVerseAndOpenSheet(hitIndex, pageData!);
    }
  }

  Future<void> _selectVerseAndOpenSheet(
    int index,
    PageDataModel pageData,
  ) async {
    if (_highlightAnimController.isAnimating) {
      _highlightAnimController.stop();
    }
    setState(() {
      _selectedVerseIndex = index;
    });

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (bottomSheetContext) {
        return QuranVerseActionBottomSheetWidget(
          pageData: pageData,
          verseIndex: index,
          pageNumber: widget.pageNumber,
        );
      },
    );

    if (mounted) {
      setState(() {
        _selectedVerseIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final backgroundColor = isDark
        ? AppColors.mushafNightBackground
        : AppColors.mushafLightBackground;
    final imageProvider = MushafPageImageResolver.resolve(
      widget.pageNumber,
      basePath: widget.basePath,
      qirat: widget.qirat,
    );

    final pageData = _resolvePageData();
    final bounds = (_selectedVerseIndex != null &&
            pageData?.versesBounds != null &&
            _selectedVerseIndex! < pageData!.versesBounds!.length)
        ? pageData.versesBounds![_selectedVerseIndex!]
        : null;

    final pageContent = isDark
        ? MushafNightModePageWidget(
            imageProvider: imageProvider,
            pageNumber: widget.pageNumber,
          )
        : Image(
            image: imageProvider,
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return QuranPagePlaceholderWidget(
                pageNumber: widget.pageNumber,
              );
            },
          );

    return LayoutBuilder(
      builder: (context, constraints) {
        final renderSize = Size(constraints.maxWidth, constraints.maxHeight);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _onTap,
          onLongPressStart: (details) => _onLongPressStart(details, renderSize),
          child: ColoredBox(
            color: backgroundColor,
            child: Stack(
              fit: StackFit.expand,
              children: [
                pageContent,
                if (bounds != null && bounds.isNotEmpty)
                  AnimatedBuilder(
                    animation: _highlightOpacityAnimation,
                    builder: (context, child) {
                      final currentAlpha = _highlightAnimController.isAnimating
                          ? _highlightOpacityAnimation.value
                          : 0.32;
                      if (currentAlpha <= 0.0) {
                        return const SizedBox.shrink();
                      }
                      return IgnorePointer(
                        child: RepaintBoundary(
                          child: CustomPaint(
                            size: renderSize,
                            painter: QuranVerseHighlightPainter(
                              rects: bounds,
                              highlightColor: AppColors.accentGold.withValues(
                                alpha: currentAlpha,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
