import 'package:flutter_test/flutter_test.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_step.dart';
import 'package:hojaty/features/hifz/domain/usecases/generate_playback_queue.dart';

void main() {
  const useCase = GeneratePlaybackQueue();

  group('GeneratePlaybackQueue', () {
    test('prepends Basmalah once when starting on Surah 2 Ayah 1', () {
      final queue = useCase(
        startGlobalAyah: 8,
        endGlobalAyah: 9,
        ayahRepeatCount: 2,
        rangeRepeatCount: 1,
        cumulativeChaining: false,
      );

      expect(queue.first.stepType, StepType.basmalah);
      expect(queue.first.surah, 1);
      expect(queue.first.ayah, 1);
      expect(
        queue.where((s) => s.stepType == StepType.basmalah).length,
        1,
      );
    });

    test('omits Basmalah for Al-Fatihah (1), At-Tawbah (9), and mid-surah', () {
      final fatihah = useCase(
        startGlobalAyah: 1,
        endGlobalAyah: 3,
        ayahRepeatCount: 1,
        rangeRepeatCount: 1,
        cumulativeChaining: false,
      );
      expect(fatihah.any((s) => s.stepType == StepType.basmalah), isFalse);

      // Surah 9 starts at global 1236
      final tawbah = useCase(
        startGlobalAyah: 1236,
        endGlobalAyah: 1237,
        ayahRepeatCount: 1,
        rangeRepeatCount: 1,
        cumulativeChaining: false,
      );
      expect(tawbah.any((s) => s.stepType == StepType.basmalah), isFalse);

      final midSurah = useCase(
        startGlobalAyah: 10,
        endGlobalAyah: 12,
        ayahRepeatCount: 1,
        rangeRepeatCount: 1,
        cumulativeChaining: false,
      );
      expect(midSurah.any((s) => s.stepType == StepType.basmalah), isFalse);
    });

    test('generates exact cumulative chaining sequence for 1..3 (3x)', () {
      final queue = useCase(
        startGlobalAyah: 1,
        endGlobalAyah: 3,
        ayahRepeatCount: 3,
        rangeRepeatCount: 1,
        cumulativeChaining: true,
      );

      final summary = queue
          .map((s) => '${s.globalAyahId}:${s.stepType.name}:${s.repeatIndex}')
          .toList();

      expect(summary, [
        '1:singleRepeat:1',
        '1:singleRepeat:2',
        '1:singleRepeat:3',
        '2:singleRepeat:1',
        '2:singleRepeat:2',
        '2:singleRepeat:3',
        '1:chainLink:1',
        '2:chainLink:1',
        '3:singleRepeat:1',
        '3:singleRepeat:2',
        '3:singleRepeat:3',
        '1:chainLink:1',
        '2:chainLink:1',
        '3:chainLink:1',
      ]);
    });

    test('supports infinity mode (-1) and snaps mid-session mutations', () {
      final infinityQueue = useCase(
        startGlobalAyah: 10,
        endGlobalAyah: 12,
        ayahRepeatCount: -1,
        rangeRepeatCount: 1,
        cumulativeChaining: false,
      );
      expect(infinityQueue.length, 3);
      expect(infinityQueue[1].isInfinity, isTrue);

      final mutatedQueue = useCase(
        startGlobalAyah: 10,
        endGlobalAyah: 12,
        ayahRepeatCount: 5,
        rangeRepeatCount: 2,
        cumulativeChaining: true,
      );
      final snapped = useCase.snapStepIndex(
        newQueue: mutatedQueue,
        currentGlobalAyahId: 11,
        preferredType: StepType.singleRepeat,
      );
      expect(mutatedQueue[snapped].globalAyahId, 11);
      expect(mutatedQueue[snapped].stepType, StepType.singleRepeat);
    });
  });
}

