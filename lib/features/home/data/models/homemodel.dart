// fake model for Home
class HomeModel {
  final String id;
  final String title;

  HomeModel({required this.id, required this.title});

  factory HomeModel.fake() {
    return HomeModel(id: '1', title: 'Fake Home');
  }
}
