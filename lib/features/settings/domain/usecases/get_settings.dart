import '../repositories/settings_repository.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../entities/settings.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  GetSettingsUseCase(this.repository);

  // Future<Either<Failure, SettingsEntity>> call() async {
  //   // You would map from Model to Entity here
  //   return await repository.getSettings();
  // }
  
  Future call() => repository.getSettings();
}
