import 'package:equatable/equatable.dart';

class FontTypeModel extends Equatable {
  final String id;
  final String title;
  final String subtitle;

  const FontTypeModel({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  @override
  List<Object?> get props => [id, title, subtitle];
}
