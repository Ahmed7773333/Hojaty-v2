import '../../domain/repositories/homelayout_repository.dart';
import '../../domain/datasources/homelayout_remote_data_source.dart';
import '../../domain/datasources/homelayout_local_data_source.dart';
import '../models/homelayoutmodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../../../../core/error/exceptions.dart';

class HomelayoutRepositoryImpl implements HomelayoutRepository {
  final HomelayoutRemoteDataSource remote;
  final HomelayoutLocalDataSource local;

  HomelayoutRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<HomelayoutModel> getHomelayout() async {
    final cached = await local.load();
    if (cached != null) return cached;

    final data = await remote.fetch();
    await local.save(data);
    return data;
  }
}
