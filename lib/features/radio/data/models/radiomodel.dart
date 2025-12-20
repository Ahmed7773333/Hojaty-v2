// fake model for Radio
class RadioModel {
  final String id;
  final String title;

  RadioModel({required this.id, required this.title});

  factory RadioModel.fake() {
    return RadioModel(id: '1', title: 'Fake Radio');
  }
}
