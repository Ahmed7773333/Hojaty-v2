import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../bloc/quraan_bloc.dart';
import '../bloc/quraan_event.dart';
import '../bloc/quraan_state.dart';
import '../widgets/quraan_bottom_bar.dart';
import '../widgets/quraan_top_bar.dart';
import '../widgets/quraan_view_widget.dart';

class QuraanPage extends StatelessWidget {
  const QuraanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<QuraanBloc>()..add(LoadQuraanData()),
      child: const QuraanView(),
    );
  }
}

class QuraanView extends StatelessWidget {
  const QuraanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Background matching pages
      body: blocConsumer(context),
    );
  }

  Widget blocConsumer(BuildContext context) {
    return BlocConsumer<QuraanBloc, QuraanState>(
      listener: (context, state) {
        if (state.status == QuraanStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Unknown Error')),
          );
        }
      },
      builder: (context, state) {
        if (state.status == QuraanStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Determine responsive mode
        return LayoutBuilder(
          builder: (context, constraints) {
            final isTwoPageMode =
                constraints.maxWidth > 600; // Tablet/Landscape logic

            return Stack(
              children: [
                // Main Content
                QuraanViewWidget(
                  initialPage: state.currentPage,
                  isTwoPageMode: isTwoPageMode,
                  quranData: state.quranPages,
                  onPageChanged: (page) {
                    context.read<QuraanBloc>().add(PageChanged(page));
                  },
                  onToggleOverlay: () {
                    context.read<QuraanBloc>().add(ToggleOverlay());
                  },
                ),

                // Top Bar
                QuraanTopBar(
                  isVisible: state.isOverlayVisible,
                  onTafseerTap: () {
                    // Navigate to Tafseer
                    // For now show snackbar or navigate if route exists
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.strings.navigateTo(
                            context.strings.quranTafseer,
                          ),
                        ),
                      ),
                    );
                  },
                  onHezpsTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.strings.navigateTo(
                            context.strings.quranHezps,
                          ),
                        ),
                      ),
                    );
                  },
                  onSearchTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.strings.navigateTo(
                            context.strings.quranSearch,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Bottom Bar
                QuraanBottomBar(
                  isVisible: state.isOverlayVisible,
                  juzText: _getJuzText(state, context),
                  hizbText: _getHizbText(state, context),
                  pageText: _getPageText(state, context),
                  onHomeTap: () {
                    Navigator.of(context).pop(); // Or navigate to home
                  },
                  onJuzTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.strings.navigateTo(context.strings.quranJuzs),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getJuzText(QuraanState state, BuildContext context) {
    if (state.quranPages.isEmpty) return '${context.strings.quranJuzLabel} -';
    final pageData = state.quranPages[state.currentPage];
    return pageData?.juzName ??
        '${context.strings.quranJuzLabel} ${pageData?.juzNumber ?? '-'}';
  }

  String _getHizbText(QuraanState state, BuildContext context) {
    if (state.quranPages.isEmpty) return '${context.strings.quranHizbLabel} -';
    final pageData = state.quranPages[state.currentPage];
    return pageData?.quarterName ?? '';
  }

  String _getPageText(QuraanState state, BuildContext context) {
    if (state.quranPages.isEmpty) {
      return '${context.strings.quranPageLabel} ${state.currentPage}';
    }
    final pageData = state.quranPages[state.currentPage];
    if (pageData == null) {
      return '${context.strings.quranPageLabel} ${state.currentPage}';
    }

    // Example: "Al-Baqara"
    final surah = pageData.surahsNames.isNotEmpty
        ? pageData.surahsNames.first
        : '';
    return '$surah - ${context.strings.quranPageLabel} ${state.currentPage}';
  }
}
