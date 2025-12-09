import '../repositories/azkar_repository.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../entities/azkar.dart';

class GetAzkarUseCase {
  final AzkarRepository repository;

  GetAzkarUseCase(this.repository);

  // Future<Either<Failure, AzkarEntity>> call() async {
  //   // You would map from Model to Entity here
  //   return await repository.getAzkar();
  // }
  
  Future call() => repository.getAzkar();
}
