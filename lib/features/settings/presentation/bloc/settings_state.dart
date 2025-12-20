import 'package:equatable/equatable.dart';
import '../../../../features/home/data/models/user_db.dart';

enum SettingsStatus { initial, loading, loaded, error }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.message = '',
    this.user,
    this.rebuildToggle = false,
  });

  final SettingsStatus status;
  final String message;
  final User? user;
  final bool rebuildToggle;

  SettingsState copyWith({
    SettingsStatus? status,
    String? message,
    User? user,
    bool? rebuildToggle,
  }) {
    return SettingsState(
      status: status ?? this.status,
      message: message ?? this.message,
      user: user ?? this.user,
      rebuildToggle: rebuildToggle ?? this.rebuildToggle,
    );
  }

  @override
  List<Object?> get props => [status, message, user, rebuildToggle];
}
