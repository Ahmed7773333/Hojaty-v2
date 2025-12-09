import 'package:equatable/equatable.dart';

class AzkarEntity extends Equatable {
  final String id;
  final String title;

  const AzkarEntity({required this.id, required this.title});
  
  @override
  List<Object> get props => [id, title];
}
