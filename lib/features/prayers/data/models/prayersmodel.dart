// fake model for Prayers
class PrayersModel {
  final String id;
  final String title;

  PrayersModel({required this.id, required this.title});

  factory PrayersModel.fake() {
    return PrayersModel(id: '1', title: 'Fake Prayers');
  }
}
