import 'package:dartz/dartz.dart';
import 'package:hojaty/core/error/failures.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_entity.dart';
import 'package:hojaty/features/daily_story/domain/repositories/daily_story_repository.dart';

class GetDailyStoriesUseCase {
  final DailyStoryRepository _repository;

  const GetDailyStoriesUseCase(this._repository);

  Future<Either<Failure, List<DailyStoryEntity>>> call() =>
      _repository.getStories();
}

