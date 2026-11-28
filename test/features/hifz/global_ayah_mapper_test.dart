import 'package:flutter_test/flutter_test.dart';
import 'package:hojaty/features/hifz/domain/utils/global_ayah_mapper.dart';

void main() {
  group('GlobalAyahMapper', () {
    test('maps known surah boundaries accurately', () {
      expect(GlobalAyahMapper.toGlobalAyahId(1, 1), 1);
      expect(GlobalAyahMapper.toGlobalAyahId(1, 7), 7);
      expect(GlobalAyahMapper.toGlobalAyahId(2, 1), 8);
      expect(GlobalAyahMapper.toGlobalAyahId(2, 255), 262);
      expect(GlobalAyahMapper.toGlobalAyahId(2, 286), 293);
      expect(GlobalAyahMapper.toGlobalAyahId(78, 1), 5673);
      expect(GlobalAyahMapper.toGlobalAyahId(114, 6), 6236);
    });

    test('round-trips all 6236 ayahs bidirectionally in O(1)', () {
      for (int g = 1; g <= GlobalAyahMapper.totalAyahs; g++) {
        final mapped = GlobalAyahMapper.fromGlobalAyahId(g);
        expect(
          GlobalAyahMapper.toGlobalAyahId(mapped.surah, mapped.ayah),
          g,
        );
      }
    });

    test('throws RangeError on out-of-bounds inputs', () {
      expect(() => GlobalAyahMapper.fromGlobalAyahId(0), throwsRangeError);
      expect(() => GlobalAyahMapper.fromGlobalAyahId(6237), throwsRangeError);
      expect(() => GlobalAyahMapper.toGlobalAyahId(0, 1), throwsRangeError);
      expect(() => GlobalAyahMapper.toGlobalAyahId(115, 1), throwsRangeError);
      expect(() => GlobalAyahMapper.toGlobalAyahId(1, 8), throwsRangeError);
    });
  });
}

