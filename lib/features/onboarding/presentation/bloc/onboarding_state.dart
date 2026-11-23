import 'package:equatable/equatable.dart';

enum OnboardingStatus { initial, loading, loaded, error }

class OnboardingState extends Equatable {
  const OnboardingState({
    this.status = OnboardingStatus.initial,
    this.message = '',
    // final OnboardingEntity? entity,
  });

  final OnboardingStatus status;
  final String message;
  // final OnboardingEntity? entity;

  OnboardingState copyWith({
    OnboardingStatus? status,
    String? message,
    // OnboardingEntity? entity,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      message: message ?? this.message,
      // entity: entity ?? this.entity,
    );
  }

  @override
  List<Object> get props => [status, message]; // props..add(entity)
}
