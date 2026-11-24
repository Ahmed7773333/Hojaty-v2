import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_bloc.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_event.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_preview_view.dart';

class DailyStoryPreviewPage extends StatelessWidget {
  const DailyStoryPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DailyStoryBloc>(
      create: (_) => injector<DailyStoryBloc>()..add(const LoadDailyStoryEvent()),
      child: const DailyStoryPreviewView(),
    );
  }
}

