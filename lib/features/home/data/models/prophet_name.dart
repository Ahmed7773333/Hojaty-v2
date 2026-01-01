class ProphetName {
  final String name;

  const ProphetName({required this.name});

  factory ProphetName.fromJson(Map<String, dynamic> json) {
    return ProphetName(name: json['name'] as String);
  }
}
