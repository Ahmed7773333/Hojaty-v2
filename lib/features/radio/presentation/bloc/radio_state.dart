import 'package:equatable/equatable.dart';
import '../../data/models/readers_response.dart';

enum RadioStatus { initial, loading, loaded, error }

class RadioState extends Equatable {
  const RadioState({
    this.status = RadioStatus.initial,
    this.message = '',
    this.reciters = const [],
    this.filteredReciters = const [],
    this.recitersAr = const [],
    this.recitersEn = const [],
  });

  final RadioStatus status;
  final String message;
  final List<Reciters> reciters; // Display list
  final List<Reciters> filteredReciters; // Filtered display list
  final List<Reciters> recitersAr; // Full Arabic list for search
  final List<Reciters> recitersEn; // Full English list for search

  RadioState copyWith({
    RadioStatus? status,
    String? message,
    List<Reciters>? reciters,
    List<Reciters>? filteredReciters,
    List<Reciters>? recitersAr,
    List<Reciters>? recitersEn,
  }) {
    return RadioState(
      status: status ?? this.status,
      message: message ?? this.message,
      reciters: reciters ?? this.reciters,
      filteredReciters: filteredReciters ?? this.filteredReciters,
      recitersAr: recitersAr ?? this.recitersAr,
      recitersEn: recitersEn ?? this.recitersEn,
    );
  }

  @override
  @override
  List<Object> get props => [
    status,
    message,
    reciters,
    filteredReciters,
    recitersAr,
    recitersEn,
  ];
}
