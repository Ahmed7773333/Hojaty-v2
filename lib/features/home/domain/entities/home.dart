import 'package:equatable/equatable.dart';

class HomeEntity extends Equatable {
  final String id;
  final String title;

  const HomeEntity({required this.id, required this.title});
  
  @override
  List<Object> get props => [id, title];
}
