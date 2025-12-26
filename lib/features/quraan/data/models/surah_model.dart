class SurahInfo {
  final int number;
  final String name;
  final String englishName;
  final int ayahCount;
  final String revelationType; // 'Meccan' or 'Medinan'
  final String arabicRevelationType; // 'مكية' or 'مدنية'
  final int pageNumber; // Madīnah Mushaf starting page

  const SurahInfo({
    required this.number,
    required this.name,
    required this.englishName,
    required this.ayahCount,
    required this.revelationType,
    required this.arabicRevelationType,
    required this.pageNumber,
  });
}