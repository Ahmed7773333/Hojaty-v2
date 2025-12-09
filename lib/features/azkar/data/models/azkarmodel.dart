// fake model for Azkar
class AzkarModel {
  final String id;
  final String title;

  AzkarModel({required this.id, required this.title});

  factory AzkarModel.fake() {
    return AzkarModel(id: '1', title: 'Fake Azkar');
  }
}
