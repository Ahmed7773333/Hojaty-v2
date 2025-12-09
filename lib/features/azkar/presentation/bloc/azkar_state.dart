import 'package:equatable/equatable.dart';

enum AzkarStatus { initial, loading, loaded, error }

class AzkarState extends Equatable {
  const AzkarState({
    this.status = AzkarStatus.initial,
    this.message = '',
    // final AzkarEntity? entity,
  });

  final AzkarStatus status;
  final String message;
  // final AzkarEntity? entity;

  AzkarState copyWith({
    AzkarStatus? status,
    String? message,
    // AzkarEntity? entity,
  }) {
    return AzkarState(
      status: status ?? this.status,
      message: message ?? this.message,
      // entity: entity ?? this.entity,
    );
  }

  @override
  List<Object> get props => [status, message]; // props..add(entity)
}
