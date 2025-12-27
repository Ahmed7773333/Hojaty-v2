import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/readers_response.dart';
import '../repositories/radio_repository.dart';

class GetRecitersUseCase {
  final RadioRepository repository;

  GetRecitersUseCase(this.repository);

  Future<Either<Failure, ReadersResponseModel>> call({
    required String language,
  }) {
    return repository.getReciters(language: language);
  }
}
