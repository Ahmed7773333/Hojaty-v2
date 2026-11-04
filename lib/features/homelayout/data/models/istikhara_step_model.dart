import 'package:equatable/equatable.dart';

class IstikharaStepModel extends Equatable {
  final int stepNumber;
  final String title;
  final String description;
  final bool isDua;

  const IstikharaStepModel({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.isDua = false,
  });

  @override
  List<Object?> get props => [stepNumber, title, description, isDua];
}
