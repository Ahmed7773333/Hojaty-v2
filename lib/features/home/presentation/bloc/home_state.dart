import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.message = '',
    // final HomeEntity? entity,
  });

  final HomeStatus status;
  final String message;
  // final HomeEntity? entity;

  HomeState copyWith({
    HomeStatus? status,
    String? message,
    // HomeEntity? entity,
  }) {
    return HomeState(
      status: status ?? this.status,
      message: message ?? this.message,
      // entity: entity ?? this.entity,
    );
  }

  @override
  List<Object> get props => [status, message]; // props..add(entity)
}
