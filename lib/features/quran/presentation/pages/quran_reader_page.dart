import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/features/quran/constants/quran_text_helper.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../widgets/quran_asset_download_widget.dart';
import '../widgets/quran_bottom_bar_widget.dart';
import '../widgets/quran_reader_view_widget.dart';
import '../widgets/quran_top_bar_widget.dart';

class QuranReaderPage extends StatefulWidget {
  final int? initialPage;

  const QuranReaderPage({super.key, this.initialPage});

  @override
  State<QuranReaderPage> createState() => _QuranReaderPageState();
}

class _QuranReaderPageState extends State<QuranReaderPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<QuranBloc>();
    if (bloc.state.status == QuranStatus.initial) {
      bloc.add(const LoadQuranDataEvent());
    } else {
      bloc.add(const CheckQuranAssetStatusEvent());
    }
    if (widget.initialPage != null &&
        widget.initialPage! >= 1 &&
        widget.initialPage! <= 604) {
      bloc.add(JumpToPageEvent(widget.initialPage!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFFFFDF5),
      body: BlocConsumer<QuranBloc, QuranState>(
        listener: (context, state) {
          if (state.status == QuranStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.status == QuranStatus.loading && state.quranPages.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: isDark ? AppColors.accentGold : AppColors.primaryDark,
              ),
            );
          }

          if (!kDebugMode && state.assetStatus != QuranAssetStatus.downloaded) {
            return const QuranAssetDownloadWidget();
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape =
                  MediaQuery.orientationOf(context) == Orientation.landscape;
              final isTwoPageMode = isLandscape && constraints.maxWidth > 600;

              return Stack(
                children: [
                  QuranReaderViewWidget(
                    initialPage: state.currentPage,
                    isTwoPageMode: isTwoPageMode,
                    basePath: state.assetsPath,
                    qirat: state.selectedQirat,
                    onPageChanged: (page) {
                      context.read<QuranBloc>().add(PageChangedEvent(page));
                    },
                    onToggleOverlay: () {
                      context.read<QuranBloc>().add(const ToggleOverlayEvent());
                    },
                  ),
                  QuranTopBarWidget(
                    isVisible: state.isOverlayVisible,
                    currentPage: state.currentPage,
                    onSearchTap: () async {
                      final pageNum = await context.pushNamed<int>(
                        AppRoutes.quranSearch,
                      );
                      if (pageNum != null && context.mounted) {
                        context.read<QuranBloc>().add(JumpToPageEvent(pageNum));
                      }
                    },
                    onJuzsTap: () async {
                      final pageNum = await context.pushNamed<int>(
                        AppRoutes.quranJuzs,
                      );
                      if (pageNum != null && context.mounted) {
                        context.read<QuranBloc>().add(JumpToPageEvent(pageNum));
                      }
                    },
                    onFehresTap: () async {
                      final pageNum = await context.pushNamed<int>(
                        AppRoutes.quranFehres,
                      );
                      if (pageNum != null && context.mounted) {
                        context.read<QuranBloc>().add(JumpToPageEvent(pageNum));
                      }
                    },
                    onTafseerTap: () {
                      final pageData = state.quranPages[state.currentPage];
                      context.pushNamed(
                        AppRoutes.quranTafseer,
                        extra: {
                          'pageData': pageData,
                          'pageNum': state.currentPage,
                        },
                      );
                    },
                  ),
                  QuranBottomBarWidget(
                    isVisible: state.isOverlayVisible,
                    currentPage: state.currentPage,
                    onHomeTap: () {
                      Navigator.of(context).pop();
                    },
                    onListenTap: () {
                      final surah = QuranTextHelper.getSurahByPage(state.currentPage);
                      if (surah != null) {
                        context.pushNamed(
                          AppRoutes.radio,
                          extra: surah,
                        );
                      }
                    },
                    onQiraatTap: () {
                      
                    },
                  
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
