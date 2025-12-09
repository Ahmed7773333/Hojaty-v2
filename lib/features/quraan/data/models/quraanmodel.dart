// fake model for Quraan
class QuraanModel {
  final String id;
  final String title;

  QuraanModel({required this.id, required this.title});

  factory QuraanModel.fake() {
    return QuraanModel(id: '1', title: 'Fake Quraan');
  }
}
