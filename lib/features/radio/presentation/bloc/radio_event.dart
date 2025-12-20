import 'package:equatable/equatable.dart';

abstract class RadioEvent extends Equatable {
  const RadioEvent();
  @override
  List<Object> get props => [];
}

class LoadRadioEvent extends RadioEvent {}
