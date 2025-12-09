import '../../models/homemodel.dart';

// You would typically extend an abstract class:
// abstract class HomeRemoteDataSource {
//   Future<HomeModel> fetch();
// }

class HomeRemoteDataSource {
  // final ApiConsumer apiConsumer;
  // HomeRemoteDataSource({required this.apiConsumer});

  Future<HomeModel> fetch() async {
    // final response = await apiConsumer.get('/home');
    // return HomeModel.fromJson(response);
    await Future.delayed(const Duration(milliseconds: 300));
    return HomeModel.fake();
  }
}
