// fake model for Settings
class SettingsModel {
  final String id;
  final String title;

  SettingsModel({required this.id, required this.title});

  factory SettingsModel.fake() {
    return SettingsModel(id: '1', title: 'Fake Settings');
  }
}
