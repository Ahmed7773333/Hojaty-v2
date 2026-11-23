import 'package:dartz/dartz.dart';
import 'package:hojaty/core/error/failures.dart';
import 'package:hojaty/features/radio/data/models/reciter_model.dart';
import 'package:hojaty/features/radio/domain/repositories/radio_repository.dart';

class GetRecitersUseCase {
  final RadioRepository repository;

  const GetRecitersUseCase(this.repository);

  Future<Either<Failure, List<ReciterModel>>> call({required String language}) {
    return repository.getReciters(language: language);
  }
}

