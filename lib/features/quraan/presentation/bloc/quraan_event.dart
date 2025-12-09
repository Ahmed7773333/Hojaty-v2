import 'package:equatable/equatable.dart';

abstract class QuraanEvent extends Equatable {
  const QuraanEvent();
  @override
  List<Object> get props => [];
}

class LoadQuraanEvent extends QuraanEvent {}
