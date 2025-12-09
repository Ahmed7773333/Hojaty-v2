import '../repositories/home_repository.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../entities/home.dart';

class GetHomeUseCase {
  final HomeRepository repository;

  GetHomeUseCase(this.repository);

  // Future<Either<Failure, HomeEntity>> call() async {
  //   // You would map from Model to Entity here
  //   return await repository.getHome();
  // }
  
  Future call() => repository.getHome();
}
