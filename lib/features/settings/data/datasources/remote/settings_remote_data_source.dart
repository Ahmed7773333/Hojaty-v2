import '../../models/settingsmodel.dart';

// You would typically extend an abstract class:
// abstract class SettingsRemoteDataSource {
//   Future<SettingsModel> fetch();
// }

class SettingsRemoteDataSource {
  // final ApiConsumer apiConsumer;
  // SettingsRemoteDataSource({required this.apiConsumer});

  Future<SettingsModel> fetch() async {
    // final response = await apiConsumer.get('/settings');
    // return SettingsModel.fromJson(response);
    await Future.delayed(const Duration(milliseconds: 300));
    return SettingsModel.fake();
  }
}
