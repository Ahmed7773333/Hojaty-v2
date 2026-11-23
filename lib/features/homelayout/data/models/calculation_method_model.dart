import 'package:equatable/equatable.dart';

class CalculationMethodModel extends Equatable {
  final String id;
  final String title;
  final String subtitle;

  const CalculationMethodModel({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  @override
  List<Object?> get props => [id, title, subtitle];
}
