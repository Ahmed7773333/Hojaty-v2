import 'package:equatable/equatable.dart';

enum RadioStatus { initial, loading, loaded, error }

class RadioState extends Equatable {
  const RadioState({
    this.status = RadioStatus.initial,
    this.message = '',
    // final RadioEntity? entity,
  });

  final RadioStatus status;
  final String message;
  // final RadioEntity? entity;

  RadioState copyWith({
    RadioStatus? status,
    String? message,
    // RadioEntity? entity,
  }) {
    return RadioState(
      status: status ?? this.status,
      message: message ?? this.message,
      // entity: entity ?? this.entity,
    );
  }

  @override
  List<Object> get props => [status, message]; // props..add(entity)
}
