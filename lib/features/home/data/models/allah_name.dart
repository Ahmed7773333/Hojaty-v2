class AllahName {
  final int id;
  final String name;
  final String text;

  const AllahName({required this.id, required this.name, required this.text});

  factory AllahName.fromJson(Map<String, dynamic> json) {
    return AllahName(
      id: json['id'] as int,
      name: json['name'] as String,
      text: json['text'] as String,
    );
  }
}
