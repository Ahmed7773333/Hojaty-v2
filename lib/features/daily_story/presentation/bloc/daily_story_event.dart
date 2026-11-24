import 'package:equatable/equatable.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_category.dart';
import 'package:hojaty/features/daily_story/domain/entities/story_card_palette.dart';

abstract class DailyStoryEvent extends Equatable {
  const DailyStoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadDailyStoryEvent extends DailyStoryEvent {
  const LoadDailyStoryEvent();
}

class SelectStoryCategoryEvent extends DailyStoryEvent {
  final DailyStoryCategory category;

  const SelectStoryCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class ShuffleDailyStoryEvent extends DailyStoryEvent {
  const ShuffleDailyStoryEvent();
}

class SelectStoryPaletteEvent extends DailyStoryEvent {
  final StoryCardPalette palette;

  const SelectStoryPaletteEvent(this.palette);

  @override
  List<Object?> get props => [palette];
}

class SetStorySharingEvent extends DailyStoryEvent {
  final bool isSharing;

  const SetStorySharingEvent(this.isSharing);

  @override
  List<Object?> get props => [isSharing];
}

