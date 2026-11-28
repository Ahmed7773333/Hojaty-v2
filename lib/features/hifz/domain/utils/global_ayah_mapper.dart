/// O(1) bidirectional converter between `globalAyahId` (1..6236) and `(surah, ayah)`.
class GlobalAyahMapper {
  const GlobalAyahMapper._();

  static const int totalAyahs = 6236;
  static const int totalSurahs = 114;

  /// Cumulative ayah counts before each surah (0-indexed: index `s - 1` is offset for surah `s`).
  static const List<int> surahOffsets = <int>[
    0, 7, 293, 493, 669, 789, 954, 1160, 1235, 1364, 1473, 1596, 1707, 1750,
    1802, 1901, 2029, 2140, 2250, 2348, 2483, 2595, 2673, 2791, 2855, 2932,
    3159, 3252, 3340, 3409, 3469, 3503, 3533, 3606, 3660, 3705, 3788, 3970,
    4058, 4133, 4218, 4272, 4325, 4414, 4473, 4510, 4545, 4583, 4612, 4630,
    4675, 4735, 4784, 4846, 4901, 4979, 5075, 5104, 5126, 5150, 5163, 5177,
    5188, 5199, 5217, 5229, 5241, 5271, 5323, 5375, 5419, 5447, 5475, 5495,
    5551, 5591, 5622, 5672, 5712, 5758, 5800, 5829, 5848, 5884, 5909, 5931,
    5948, 5967, 5993, 6023, 6043, 6058, 6079, 6090, 6098, 6106, 6125, 6130,
    6138, 6146, 6157, 6168, 6176, 6179, 6188, 6193, 6197, 6204, 6207, 6213,
    6216, 6221, 6225, 6230,
  ];

  /// Returns the number of ayahs in [surah] (1..114).
  static int surahAyahCount(int surah) {
    RangeError.checkValueInInterval(surah, 1, totalSurahs, 'surah');
    if (surah == totalSurahs) {
      return totalAyahs - surahOffsets[totalSurahs - 1];
    }
    return surahOffsets[surah] - surahOffsets[surah - 1];
  }

  /// Returns the first global ayah ID (1..6236) of [surah].
  static int firstGlobalAyahOfSurah(int surah) {
    RangeError.checkValueInInterval(surah, 1, totalSurahs, 'surah');
    return surahOffsets[surah - 1] + 1;
  }

  /// Returns the last global ayah ID (1..6236) of [surah].
  static int lastGlobalAyahOfSurah(int surah) {
    RangeError.checkValueInInterval(surah, 1, totalSurahs, 'surah');
    if (surah == totalSurahs) return totalAyahs;
    return surahOffsets[surah];
  }

  /// Converts 1-based ([surah], [ayah]) to 1-based `globalAyahId` (1..6236).
  static int toGlobalAyahId(int surah, int ayah) {
    RangeError.checkValueInInterval(surah, 1, totalSurahs, 'surah');
    final maxAyah = surahAyahCount(surah);
    RangeError.checkValueInInterval(ayah, 1, maxAyah, 'ayah');
    return surahOffsets[surah - 1] + ayah;
  }

  /// Converts 1-based [globalAyahId] (1..6236) to 1-based `({int surah, int ayah})`.
  static ({int surah, int ayah}) fromGlobalAyahId(int globalAyahId) {
    RangeError.checkValueInInterval(
      globalAyahId,
      1,
      totalAyahs,
      'globalAyahId',
    );
    int low = 0;
    int high = totalSurahs - 1;
    while (low <= high) {
      final mid = (low + high) >> 1;
      final start = surahOffsets[mid] + 1;
      final end = mid == totalSurahs - 1 ? totalAyahs : surahOffsets[mid + 1];
      if (globalAyahId < start) {
        high = mid - 1;
      } else if (globalAyahId > end) {
        low = mid + 1;
      } else {
        return (surah: mid + 1, ayah: globalAyahId - surahOffsets[mid]);
      }
    }
    throw StateError('Unreachable globalAyahId: $globalAyahId');
  }

  /// Zero-pads [number] to 3 digits (e.g. `2` -> `'002'`).
  static String padThree(int number) => number.toString().padLeft(3, '0');
}

