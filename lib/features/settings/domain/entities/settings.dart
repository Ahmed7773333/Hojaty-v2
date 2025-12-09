import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final String id;
  final String title;

  const SettingsEntity({required this.id, required this.title});
  
  @override
  List<Object> get props => [id, title];
}
