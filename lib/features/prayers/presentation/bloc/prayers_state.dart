import 'package:equatable/equatable.dart';

enum PrayersStatus { initial, loading, loaded, error }

class PrayersState extends Equatable {
  const PrayersState({
    this.status = PrayersStatus.initial,
    this.message = '',
    // final PrayersEntity? entity,
  });

  final PrayersStatus status;
  final String message;
  // final PrayersEntity? entity;

  PrayersState copyWith({
    PrayersStatus? status,
    String? message,
    // PrayersEntity? entity,
  }) {
    return PrayersState(
      status: status ?? this.status,
      message: message ?? this.message,
      // entity: entity ?? this.entity,
    );
  }

  @override
  List<Object> get props => [status, message]; // props..add(entity)
}
