class Hadith {
  final int number;
  final String hadith;
  final String description;
  final String searchTerm;

  const Hadith({
    required this.number,
    required this.hadith,
    required this.description,
    required this.searchTerm,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      number: json['number'] as int,
      hadith: json['hadith'] as String,
      description: json['description'] as String,
      searchTerm: json['searchTerm'] as String,
    );
  }
}
