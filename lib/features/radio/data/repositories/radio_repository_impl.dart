import '../../domain/repositories/radio_repository.dart';
import '../../domain/datasources/radio_remote_data_source.dart';
import '../../domain/datasources/radio_local_data_source.dart';
import '../models/radiomodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../../../../core/error/exceptions.dart';

class RadioRepositoryImpl implements RadioRepository {
  final RadioRemoteDataSource remote;
  final RadioLocalDataSource local;

  RadioRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<RadioModel> getRadio() async {
    final cached = await local.load();
    if (cached != null) return cached;

    final data = await remote.fetch();
    await local.save(data);
    return data;
  }
}
