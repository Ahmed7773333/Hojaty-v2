import 'package:flutter_test/flutter_test.dart';
import 'package:hojaty/features/hifz/domain/entities/ayah_mastery.dart';
import 'package:hojaty/features/hifz/domain/usecases/calculate_spaced_review.dart';

void main() {
  const useCase = CalculateSpacedReview();
  final baseTime = DateTime(2026, 1, 1, 8);

  group('CalculateSpacedReview', () {
    test('creates Box 1 (+1 day) initial mastery', () {
      final initial = useCase.createInitial(globalAyahId: 262, now: baseTime);
      expect(initial.masteryLevel, 1);
      expect(initial.lapseCount, 0);
      expect(initial.nextReviewAt, baseTime.add(const Duration(days: 1)));
    });

    test('promotes through Leitner Boxes 1 -> 5 and caps at Box 5 (+30d)', () {
      AyahMastery current = useCase.createInitial(
        globalAyahId: 262,
        now: baseTime,
      );

      current = useCase(existing: current, globalAyahId: 262, recalled: true, now: baseTime);
      expect(current.masteryLevel, 2);
      expect(current.nextReviewAt, baseTime.add(const Duration(days: 3)));

      current = useCase(existing: current, globalAyahId: 262, recalled: true, now: baseTime);
      expect(current.masteryLevel, 3);
      expect(current.nextReviewAt, baseTime.add(const Duration(days: 7)));

      current = useCase(existing: current, globalAyahId: 262, recalled: true, now: baseTime);
      expect(current.masteryLevel, 4);
      expect(current.nextReviewAt, baseTime.add(const Duration(days: 14)));

      current = useCase(existing: current, globalAyahId: 262, recalled: true, now: baseTime);
      expect(current.masteryLevel, 5);
      expect(current.nextReviewAt, baseTime.add(const Duration(days: 30)));

      current = useCase(existing: current, globalAyahId: 262, recalled: true, now: baseTime);
      expect(current.masteryLevel, 5);
      expect(current.nextReviewAt, baseTime.add(const Duration(days: 30)));
    });

    test('demotes on lapse, increments lapseCount, and floors at Box 1', () {
      final box4 = AyahMastery(
        globalAyahId: 262,
        masteryLevel: 4,
        lastReviewedAt: baseTime,
        nextReviewAt: baseTime.add(const Duration(days: 14)),
        lapseCount: 0,
      );

      final demoted = useCase(
        existing: box4,
        globalAyahId: 262,
        recalled: false,
        now: baseTime,
      );
      expect(demoted.masteryLevel, 3);
      expect(demoted.lapseCount, 1);
      expect(demoted.nextReviewAt, baseTime.add(const Duration(days: 7)));

      final box1 = demoted.copyWith(masteryLevel: 1);
      final floored = useCase(
        existing: box1,
        globalAyahId: 262,
        recalled: false,
        now: baseTime,
      );
      expect(floored.masteryLevel, 1);
      expect(floored.lapseCount, 2);
      expect(floored.nextReviewAt, baseTime.add(const Duration(days: 1)));
    });
  });
}

