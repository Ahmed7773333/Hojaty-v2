import 'package:hojaty/features/homelayout/data/services/prayer_widget_service.dart';
import 'package:hojaty/features/homelayout/domain/entities/prayer_widget_data.dart';
import 'package:hojaty/features/homelayout/domain/repositories/prayer_widget_repository.dart';

class PrayerWidgetRepositoryImpl implements PrayerWidgetRepository {
  final PrayerWidgetService service;

  const PrayerWidgetRepositoryImpl(this.service);

  @override
  Future<void> syncPrayerWidget(PrayerWidgetData data) {
    return service.syncPrayerWidget(data);
  }

  @override
  Future<Uri?> getInitialWidgetLaunchUri() {
    return service.getInitialWidgetLaunchUri();
  }

  @override
  Stream<Uri?> get widgetClickStream => service.widgetClickStream;

  @override
  Future<bool> requestPinWidget() {
    return service.requestPinWidget();
  }
}
