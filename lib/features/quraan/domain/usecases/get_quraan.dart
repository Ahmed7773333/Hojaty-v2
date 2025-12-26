import '../repositories/quraan_repository.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../entities/quraan.dart';

class GetQuraanUseCase {
  final QuraanRepository repository;

  GetQuraanUseCase(this.repository);

  // Future<Either<Failure, QuraanEntity>> call() async {
  //   // You would map from Model to Entity here
  //   return await repository.getQuraan();
  // }
  
  Future call() => repository.getQuranPages();
}
