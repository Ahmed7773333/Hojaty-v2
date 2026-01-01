import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/di/injector.dart';
import '../../../../config/routes/app_router.dart';
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
      backgroundColor: const Color(0xFFFFF8E1),
      body: _buildBlocConsumer(context),
    );
  }

  Widget _buildBlocConsumer(BuildContext context) {
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

        return LayoutBuilder(
          builder: (context, constraints) {
            final isTwoPageMode = constraints.maxWidth > 600;

            return Stack(
              children: [
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

                QuraanTopBar(
                  isVisible: state.isOverlayVisible,
                  onTafseerTap: () {
                    if (state.quranPages.isNotEmpty) {
                      final pageData = state.quranPages[state.currentPage];
                      final tafseerText = pageData?.tafseer?.join('\n\n') ?? '';
                      context.pushNamed(
                        AppRoutes.tafseer,
                        extra: {
                          'content': tafseerText,
                          'pageNum': state.currentPage.toString(),
                        },
                      );
                    }
                  },
                  onHezpsTap: () {
                    context.pushNamed(
                      AppRoutes.juzs,
                      extra: context.read<QuraanBloc>(),
                    );
                  },
                  onSearchTap: () {
                    context.pushNamed(
                      AppRoutes.search,
                      extra: context.read<QuraanBloc>(),
                    );
                  },
                ),

                QuraanBottomBar(
                  isVisible: state.isOverlayVisible,
                  onHomeTap: () {
                    Navigator.of(context).pop();
                  },
                  onJuzTap: () {
                    context.pushNamed(
                      AppRoutes.fehres,
                      extra: context.read<QuraanBloc>(),
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
}
