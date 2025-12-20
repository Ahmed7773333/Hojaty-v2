import 'package:equatable/equatable.dart';

class RadioEntity extends Equatable {
  final String id;
  final String title;

  const RadioEntity({required this.id, required this.title});
  
  @override
  List<Object> get props => [id, title];
}
