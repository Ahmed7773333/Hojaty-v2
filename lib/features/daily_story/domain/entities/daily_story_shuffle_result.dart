import 'package:equatable/equatable.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_entity.dart';

class DailyStoryShuffleResult extends Equatable {
  final DailyStoryEntity story;
  final Set<String> seenIds;

  const DailyStoryShuffleResult({required this.story, required this.seenIds});

  @override
  List<Object?> get props => [story, seenIds];
}

