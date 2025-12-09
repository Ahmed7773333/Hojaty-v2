import '../../models/quraanmodel.dart';

// You would typically extend an abstract class:
// abstract class QuraanRemoteDataSource {
//   Future<QuraanModel> fetch();
// }

class QuraanRemoteDataSource {
  // final ApiConsumer apiConsumer;
  // QuraanRemoteDataSource({required this.apiConsumer});

  Future<QuraanModel> fetch() async {
    // final response = await apiConsumer.get('/quraan');
    // return QuraanModel.fromJson(response);
    await Future.delayed(const Duration(milliseconds: 300));
    return QuraanModel.fake();
  }
}
