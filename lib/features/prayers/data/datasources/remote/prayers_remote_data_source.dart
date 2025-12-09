import '../../models/prayersmodel.dart';

// You would typically extend an abstract class:
// abstract class PrayersRemoteDataSource {
//   Future<PrayersModel> fetch();
// }

class PrayersRemoteDataSource {
  // final ApiConsumer apiConsumer;
  // PrayersRemoteDataSource({required this.apiConsumer});

  Future<PrayersModel> fetch() async {
    // final response = await apiConsumer.get('/prayers');
    // return PrayersModel.fromJson(response);
    await Future.delayed(const Duration(milliseconds: 300));
    return PrayersModel.fake();
  }
}
