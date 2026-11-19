import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  const QuranPageImageWidget({
    super.key,
    required this.pageNumber,
    this.pageData,
    this.basePath,
    this.qirat = QiratType.hafs,
    this.onToggleOverlay,
  });

  @override
  State<QuranPageImageWidget> createState() => _QuranPageImageWidgetState();
}

class _QuranPageImageWidgetState extends State<QuranPageImageWidget> {
  int? _selectedVerseIndex;

  @override
  void didUpdateWidget(covariant QuranPageImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageNumber != widget.pageNumber) {
      _selectedVerseIndex = null;
    }
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
                  IgnorePointer(
                    child: CustomPaint(
                      size: renderSize,
                      painter: QuranVerseHighlightPainter(
                        rects: bounds,
                        highlightColor: AppColors.accentGold.withValues(
                          alpha: 0.32,
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
  }
}
