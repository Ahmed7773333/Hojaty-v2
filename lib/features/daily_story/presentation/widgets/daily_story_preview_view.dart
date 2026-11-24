import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/assets.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/snackbar_helper.dart';
import 'package:hojaty/features/daily_story/data/services/daily_story_share_service.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_bloc.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_event.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_state.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_app_bar_widget.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_canvas_widget.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_preview_body_widget.dart';
import 'package:hojaty/shared/widgets/error_display_widget.dart';
import 'package:hojaty/shared/widgets/loading_widget.dart';

class DailyStoryPreviewView extends StatefulWidget {
  const DailyStoryPreviewView({super.key});

  @override
  State<DailyStoryPreviewView> createState() => _DailyStoryPreviewViewState();
}

class _DailyStoryPreviewViewState extends State<DailyStoryPreviewView> {
  final GlobalKey _canvasKey = GlobalKey();
  DateTime _lastVisualChange = DateTime.fromMillisecondsSinceEpoch(0);
  bool _logoPrecached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_logoPrecached) {
      _logoPrecached = true;
      // The footer logo must be decoded before the first capture.
      precacheImage(const AssetImage(Assets.logo), context);
    }
  }

  Future<void> _share() async {
    final bloc = context.read<DailyStoryBloc>();
    if (bloc.state.isSharing) return;
    bloc.add(const SetStorySharingEvent(true));

    try {
      // Never capture a half-finished cross-fade between two cards.
      final remaining = DailyStoryCanvasWidget.transitionDuration -
          DateTime.now().difference(_lastVisualChange);
      if (remaining > Duration.zero) {
        await Future<void>.delayed(remaining);
      }
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;

      final boundary = _canvasKey.currentContext?.findRenderObject();
      if (boundary is! RenderRepaintBoundary) {
        throw StateError('Story canvas is not ready');
      }
      final box = context.findRenderObject() as RenderBox?;
      final origin =
          box != null ? box.localToGlobal(Offset.zero) & box.size : null;

      await injector<DailyStoryShareService>().shareBoundary(
        boundary: boundary,
        sharePositionOrigin: origin,
      );
    } catch (_) {
      if (!mounted) return;
      SnackbarHelper.showError(
        context,
        message: context.strings.dailyStoryShareError,
      );
    } finally {
      if (!bloc.isClosed) bloc.add(const SetStorySharingEvent(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DailyStoryBloc, DailyStoryState>(
      listenWhen: (prev, curr) =>
          prev.currentStory != curr.currentStory ||
          prev.selectedPalette != curr.selectedPalette,
      listener: (context, state) => _lastVisualChange = DateTime.now(),
      child: Scaffold(
        backgroundColor: context.isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Column(
          children: [
            const DailyStoryAppBarWidget(),
            Expanded(
              child: BlocBuilder<DailyStoryBloc, DailyStoryState>(
                buildWhen: (prev, curr) => prev.status != curr.status,
                builder: (context, state) => switch (state.status) {
                  DailyStoryStatus.success => DailyStoryPreviewBodyWidget(
                      canvasKey: _canvasKey,
                      onShare: _share,
                    ),
                  DailyStoryStatus.failure => ErrorDisplayWidget(
                      message: context.strings.dailyStoryLoadError,
                      onRetry: () => context
                          .read<DailyStoryBloc>()
                          .add(const LoadDailyStoryEvent()),
                    ),
                  _ => const LoadingWidget(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

