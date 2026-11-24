import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_category.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_entity.dart';
import 'package:hojaty/features/daily_story/domain/usecases/get_daily_stories_use_case.dart';
import 'package:hojaty/features/daily_story/domain/usecases/select_daily_story_use_case.dart';
import 'package:hojaty/features/daily_story/domain/usecases/story_palette_use_case.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_event.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_state.dart';

class DailyStoryBloc extends Bloc<DailyStoryEvent, DailyStoryState> {
  final GetDailyStoriesUseCase _getStories;
  final SelectDailyStoryUseCase _selectStory;
  final StoryPaletteUseCase _palette;

  DailyStoryBloc({
    required GetDailyStoriesUseCase getStories,
    required SelectDailyStoryUseCase selectStory,
    required StoryPaletteUseCase palette,
  })  : _getStories = getStories,
        _selectStory = selectStory,
        _palette = palette,
        super(const DailyStoryState()) {
    on<LoadDailyStoryEvent>(_onLoad);
    on<SelectStoryCategoryEvent>(_onSelectCategory);
    on<ShuffleDailyStoryEvent>(_onShuffle);
    on<SelectStoryPaletteEvent>(_onSelectPalette);
    on<SetStorySharingEvent>(_onSetSharing);
  }

  Future<void> _onLoad(
    LoadDailyStoryEvent event,
    Emitter<DailyStoryState> emit,
  ) async {
    emit(state.copyWith(status: DailyStoryStatus.loading, clearError: true));

    final result = await _getStories();
    String? error;
    List<DailyStoryEntity> stories = const [];
    result.fold((failure) => error = failure.message, (data) => stories = data);

    if (error != null || stories.isEmpty) {
      emit(
        state.copyWith(
          status: DailyStoryStatus.failure,
          errorMessage: error ?? 'No daily stories available',
        ),
      );
      return;
    }

    final now = DateTime.now();
    final today = await _selectStory.today(stories, now);
    emit(
      state.copyWith(
        status: DailyStoryStatus.success,
        stories: stories,
        currentStory: today,
        selectedCategory: SelectDailyStoryUseCase.defaultCategoryFor(now),
        selectedPalette: _palette.read(),
        seenIds: {today.id},
        clearError: true,
      ),
    );
  }

  void _onSelectCategory(
    SelectStoryCategoryEvent event,
    Emitter<DailyStoryState> emit,
  ) {
    if (event.category == state.selectedCategory || state.stories.isEmpty) {
      return;
    }
    final current = state.currentStory;

    // Keep the visible card when it already belongs to the chosen filter.
    if (event.category == DailyStoryCategory.all ||
        current?.category == event.category) {
      emit(
        state.copyWith(
          selectedCategory: event.category,
          seenIds: {if (current != null) current.id},
        ),
      );
      return;
    }

    final result = _selectStory.shuffle(
      stories: state.stories,
      category: event.category,
      current: current,
      seenIds: const {},
    );
    emit(
      state.copyWith(
        selectedCategory: event.category,
        currentStory: result.story,
        seenIds: result.seenIds,
      ),
    );
  }

  void _onShuffle(
    ShuffleDailyStoryEvent event,
    Emitter<DailyStoryState> emit,
  ) {
    if (state.stories.isEmpty) return;
    final result = _selectStory.shuffle(
      stories: state.stories,
      category: state.selectedCategory,
      current: state.currentStory,
      seenIds: state.seenIds,
    );
    emit(state.copyWith(currentStory: result.story, seenIds: result.seenIds));
  }

  Future<void> _onSelectPalette(
    SelectStoryPaletteEvent event,
    Emitter<DailyStoryState> emit,
  ) async {
    if (event.palette == state.selectedPalette) return;
    emit(state.copyWith(selectedPalette: event.palette));
    await _palette.save(event.palette);
  }

  void _onSetSharing(
    SetStorySharingEvent event,
    Emitter<DailyStoryState> emit,
  ) {
    emit(state.copyWith(isSharing: event.isSharing));
  }
}

