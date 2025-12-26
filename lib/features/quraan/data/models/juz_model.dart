class JuzInfo {
  final int id;
  final List<int> surahs;
  final Map<int, List<int>> verses;

  const JuzInfo({
    required this.id,
    required this.surahs,
    required this.verses,
  });
}