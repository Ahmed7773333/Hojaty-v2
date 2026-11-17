import 'package:equatable/equatable.dart';

class OnboardingEntity extends Equatable {
  final String id;
  final String title;

  const OnboardingEntity({required this.id, required this.title});
  
  @override
  List<Object> get props => [id, title];
}
