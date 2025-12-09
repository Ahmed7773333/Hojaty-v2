import 'package:equatable/equatable.dart';

abstract class PrayersEvent extends Equatable {
  const PrayersEvent();
  @override
  List<Object> get props => [];
}

class LoadPrayersEvent extends PrayersEvent {}
