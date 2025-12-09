import 'package:equatable/equatable.dart';

enum QuraanStatus { initial, loading, loaded, error }

class QuraanState extends Equatable {
  const QuraanState({
    this.status = QuraanStatus.initial,
    this.message = '',
    // final QuraanEntity? entity,
  });

  final QuraanStatus status;
  final String message;
  // final QuraanEntity? entity;

  QuraanState copyWith({
    QuraanStatus? status,
    String? message,
    // QuraanEntity? entity,
  }) {
    return QuraanState(
      status: status ?? this.status,
      message: message ?? this.message,
      // entity: entity ?? this.entity,
    );
  }

  @override
  List<Object> get props => [status, message]; // props..add(entity)
}
