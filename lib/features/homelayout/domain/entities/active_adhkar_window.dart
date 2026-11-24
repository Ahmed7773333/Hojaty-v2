import 'package:equatable/equatable.dart';
import 'package:hojaty/features/homelayout/data/models/athkar_category_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';

class ActiveAdhkarWindow extends Equatable {
  final AthkarCategoryType categoryType;
  final int categoryId;
  final DateTime nextBoundary;
  final PrayerType? activePrayer;

  const ActiveAdhkarWindow({
    required this.categoryType,
    required this.categoryId,
    required this.nextBoundary,
    this.activePrayer,
  });

  @override
  List<Object?> get props => [
        categoryType,
        categoryId,
        nextBoundary,
        activePrayer,
      ];
}
