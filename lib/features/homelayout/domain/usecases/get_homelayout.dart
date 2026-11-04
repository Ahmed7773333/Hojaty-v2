import '../repositories/homelayout_repository.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../entities/homelayout.dart';

class GetHomelayoutUseCase {
  final HomelayoutRepository repository;

  GetHomelayoutUseCase(this.repository);

  Future call() => repository.getHomelayout();
}
