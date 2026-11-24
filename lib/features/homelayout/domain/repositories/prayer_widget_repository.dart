import 'package:hojaty/features/homelayout/domain/entities/prayer_widget_data.dart';

abstract class PrayerWidgetRepository {
  Future<void> syncPrayerWidget(PrayerWidgetData data);

  Future<Uri?> getInitialWidgetLaunchUri();

  Stream<Uri?> get widgetClickStream;

  Future<bool> requestPinWidget();
}
