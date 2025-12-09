import 'package:equatable/equatable.dart';

class QuraanEntity extends Equatable {
  final String id;
  final String title;

  const QuraanEntity({required this.id, required this.title});
  
  @override
  List<Object> get props => [id, title];
}
