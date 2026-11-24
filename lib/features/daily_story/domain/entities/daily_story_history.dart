import 'package:equatable/equatable.dart';

/// Persisted selection history used to keep "today's card" stable all day
/// and to avoid repeating recent cards on consecutive days.
class DailyStoryHistory extends Equatable {
  final int? todayKey;
  final String? todayId;
  final List<String> recentIds;

  const DailyStoryHistory({
    this.todayKey,
    this.todayId,
    this.recentIds = const [],
  });

  @override
  List<Object?> get props => [todayKey, todayId, recentIds];
}

