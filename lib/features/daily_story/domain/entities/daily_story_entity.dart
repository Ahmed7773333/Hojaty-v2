import 'package:equatable/equatable.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_category.dart';

class DailyStoryEntity extends Equatable {
  final String id;
  final DailyStoryCategory category;
  final String categoryLabel;
  final String mainText;
  final String subText;
  final String reference;

  const DailyStoryEntity({
    required this.id,
    required this.category,
    required this.categoryLabel,
    required this.mainText,
    required this.subText,
    required this.reference,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        categoryLabel,
        mainText,
        subText,
        reference,
      ];
}

