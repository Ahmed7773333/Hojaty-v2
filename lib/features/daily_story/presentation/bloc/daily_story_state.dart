import 'package:equatable/equatable.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_category.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_entity.dart';
import 'package:hojaty/features/daily_story/domain/entities/story_card_palette.dart';

enum DailyStoryStatus { initial, loading, success, failure }

class DailyStoryState extends Equatable {
  final DailyStoryStatus status;
  final List<DailyStoryEntity> stories;
  final DailyStoryEntity? currentStory;
  final DailyStoryCategory selectedCategory;
  final StoryCardPalette selectedPalette;
  final Set<String> seenIds;
  final bool isSharing;
  final String? errorMessage;

  const DailyStoryState({
    this.status = DailyStoryStatus.initial,
    this.stories = const [],
    this.currentStory,
    this.selectedCategory = DailyStoryCategory.all,
    this.selectedPalette = StoryCardPalette.emeraldDawn,
    this.seenIds = const {},
    this.isSharing = false,
    this.errorMessage,
  });

  DailyStoryState copyWith({
    DailyStoryStatus? status,
    List<DailyStoryEntity>? stories,
    DailyStoryEntity? currentStory,
    DailyStoryCategory? selectedCategory,
    StoryCardPalette? selectedPalette,
    Set<String>? seenIds,
    bool? isSharing,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DailyStoryState(
      status: status ?? this.status,
      stories: stories ?? this.stories,
      currentStory: currentStory ?? this.currentStory,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedPalette: selectedPalette ?? this.selectedPalette,
      seenIds: seenIds ?? this.seenIds,
      isSharing: isSharing ?? this.isSharing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        stories,
        currentStory,
        selectedCategory,
        selectedPalette,
        seenIds,
        isSharing,
        errorMessage,
      ];
}

