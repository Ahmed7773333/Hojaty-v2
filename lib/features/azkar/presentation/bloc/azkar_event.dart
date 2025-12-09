import 'package:equatable/equatable.dart';

abstract class AzkarEvent extends Equatable {
  const AzkarEvent();
  @override
  List<Object> get props => [];
}

class LoadAzkarEvent extends AzkarEvent {}
