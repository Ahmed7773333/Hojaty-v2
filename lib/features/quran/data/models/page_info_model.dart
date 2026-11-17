import 'package:equatable/equatable.dart';

class PageInfoModel extends Equatable {
  final int surah;
  final int start;
  final int end;

  const PageInfoModel({
    required this.surah,
    required this.start,
    required this.end,
  });

  @override
  List<Object?> get props => [surah, start, end];
}
