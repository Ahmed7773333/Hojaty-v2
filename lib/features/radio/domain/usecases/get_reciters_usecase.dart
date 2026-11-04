import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/reciter_model.dart';
import '../repositories/radio_repository.dart';

class GetRecitersUseCase {
  final RadioRepository repository;

  const GetRecitersUseCase(this.repository);

  Future<Either<Failure, List<ReciterModel>>> call({required String language}) {
    return repository.getReciters(language: language);
  }
}

