import 'package:hojaty/features/daily_story/domain/entities/daily_story_category.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_entity.dart';

class DailyStoryModel extends DailyStoryEntity {
  const DailyStoryModel({
    required super.id,
    required super.category,
    required super.categoryLabel,
    required super.mainText,
    required super.subText,
    required super.reference,
  });

  factory DailyStoryModel.fromJson(Map<String, dynamic> json) {
    return DailyStoryModel(
      id: json['id'] as String? ?? '',
      category: DailyStoryCategory.fromKey(json['category'] as String?),
      categoryLabel: json['category_label_ar'] as String? ?? '',
      mainText: json['main_text'] as String? ?? '',
      subText: json['sub_text'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
    );
  }
}

