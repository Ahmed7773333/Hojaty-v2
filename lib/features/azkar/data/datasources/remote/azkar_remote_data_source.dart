import '../../models/azkarmodel.dart';

// You would typically extend an abstract class:
// abstract class AzkarRemoteDataSource {
//   Future<AzkarModel> fetch();
// }

class AzkarRemoteDataSource {
  // final ApiConsumer apiConsumer;
  // AzkarRemoteDataSource({required this.apiConsumer});

  Future<AzkarModel> fetch() async {
    // final response = await apiConsumer.get('/azkar');
    // return AzkarModel.fromJson(response);
    await Future.delayed(const Duration(milliseconds: 300));
    return AzkarModel.fake();
  }
}
