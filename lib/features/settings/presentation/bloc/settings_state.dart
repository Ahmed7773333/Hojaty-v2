import 'package:equatable/equatable.dart';

enum SettingsStatus { initial, loading, loaded, error }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.message = '',
    // final SettingsEntity? entity,
  });

  final SettingsStatus status;
  final String message;
  // final SettingsEntity? entity;

  SettingsState copyWith({
    SettingsStatus? status,
    String? message,
    // SettingsEntity? entity,
  }) {
    return SettingsState(
      status: status ?? this.status,
      message: message ?? this.message,
      // entity: entity ?? this.entity,
    );
  }

  @override
  List<Object> get props => [status, message]; // props..add(entity)
}
