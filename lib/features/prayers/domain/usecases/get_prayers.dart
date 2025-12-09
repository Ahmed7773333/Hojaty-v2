import '../repositories/prayers_repository.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../entities/prayers.dart';

class GetPrayersUseCase {
  final PrayersRepository repository;

  GetPrayersUseCase(this.repository);

  // Future<Either<Failure, PrayersEntity>> call() async {
  //   // You would map from Model to Entity here
  //   return await repository.getPrayers();
  // }
  
  Future call() => repository.getPrayers();
}
