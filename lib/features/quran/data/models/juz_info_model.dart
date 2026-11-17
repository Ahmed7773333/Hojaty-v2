import 'package:equatable/equatable.dart';

class JuzInfoModel extends Equatable {
  final int id;
  final List<int> surahs;
  final Map<int, List<int>> verses;

  const JuzInfoModel({
    required this.id,
    required this.surahs,
    required this.verses,
  });

  @override
  List<Object?> get props => [id, surahs, verses];
}
