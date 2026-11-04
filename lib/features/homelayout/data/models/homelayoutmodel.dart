// fake model for Homelayout
class HomelayoutModel {
  final String id;
  final String title;

  HomelayoutModel({required this.id, required this.title});

  factory HomelayoutModel.fake() {
    return HomelayoutModel(id: '1', title: 'Fake Homelayout');
  }
}
