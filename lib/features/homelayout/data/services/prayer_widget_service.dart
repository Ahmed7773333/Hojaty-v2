import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:hojaty/features/homelayout/domain/entities/prayer_widget_data.dart';

class PrayerWidgetService {
  static const String appGroupId = 'group.com.wolfdev.hojaty';
  static const String androidQualifiedWidgetName =
      'com.wolfdev.hojaty.PrayerWidgetProvider';
  static const String iosWidgetName = 'HojatyPrayerWidget';
  static const String deepLinkScheme = 'hojaty';
  static const String deepLinkPrayerTimesHost = 'prayer_times';

  static const String keyNextPrayerKey = 'prayer_key';
  static const String keyNextPrayerNameAr = 'next_prayer_name_ar';
  static const String keyNextPrayerNameEn = 'next_prayer_name_en';
  static const String keyNextPrayerTimeFormatted = 'next_prayer_time_formatted';
  static const String keyNextPrayerTimestampMs = 'next_prayer_timestamp_ms';
  static const String keyLocationName = 'location_name';
  static const String keyHijriDate = 'hijri_date';
  static const String keyLanguage = 'language';
  static const String keyPrayerScheduleJson = 'prayer_schedule_json';
  static const String keyIsInitialized = 'is_initialized';

  bool _isConfigured = false;

  bool get _isSupportedPlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<void> _ensureConfigured() async {
    if (_isConfigured || !_isSupportedPlatform) return;
    if (Platform.isIOS) {
      await HomeWidget.setAppGroupId(appGroupId);
    }
    _isConfigured = true;
  }

  Future<void> syncPrayerWidget(PrayerWidgetData data) async {
    if (!_isSupportedPlatform) return;
    try {
      await _ensureConfigured();

      final scheduleJson = jsonEncode(
        data.schedule.map((slot) => slot.toJson()).toList(),
      );

      await Future.wait([
        HomeWidget.saveWidgetData<String>(
          keyNextPrayerKey,
          data.nextPrayerKey,
        ),
        HomeWidget.saveWidgetData<String>(
          keyNextPrayerNameAr,
          data.nextPrayerNameAr,
        ),
        HomeWidget.saveWidgetData<String>(
          keyNextPrayerNameEn,
          data.nextPrayerNameEn,
        ),
        HomeWidget.saveWidgetData<String>(
          keyNextPrayerTimeFormatted,
          data.nextPrayerTimeFormatted,
        ),
        HomeWidget.saveWidgetData<int>(
          keyNextPrayerTimestampMs,
          data.nextPrayerTimestampMs,
        ),
        HomeWidget.saveWidgetData<String>(keyLocationName, data.locationName),
        HomeWidget.saveWidgetData<String>(keyHijriDate, data.hijriDate),
        HomeWidget.saveWidgetData<String>(keyLanguage, data.language),
        HomeWidget.saveWidgetData<String>(keyPrayerScheduleJson, scheduleJson),
        HomeWidget.saveWidgetData<bool>(keyIsInitialized, true),
      ]);

      await HomeWidget.updateWidget(
        qualifiedAndroidName: androidQualifiedWidgetName,
        iOSName: iosWidgetName,
      );
    } catch (e, st) {
      log('PrayerWidgetService.syncPrayerWidget error: $e\n$st');
    }
  }

  Future<Uri?> getInitialWidgetLaunchUri() async {
    if (!_isSupportedPlatform) return null;
    try {
      await _ensureConfigured();
      return await HomeWidget.initiallyLaunchedFromHomeWidget();
    } catch (e) {
      log('PrayerWidgetService.getInitialWidgetLaunchUri error: $e');
      return null;
    }
  }

  Stream<Uri?> get widgetClickStream {
    if (!_isSupportedPlatform) {
      return const Stream<Uri?>.empty();
    }
    return HomeWidget.widgetClicked;
  }

  Future<bool> requestPinWidget() async {
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      await _ensureConfigured();
      final isSupported = await HomeWidget.isRequestPinWidgetSupported() ?? false;
      if (!isSupported) return false;
      await HomeWidget.requestPinWidget(
        qualifiedAndroidName: androidQualifiedWidgetName,
      );
      return true;
    } catch (e) {
      log('PrayerWidgetService.requestPinWidget error: $e');
      return false;
    }
  }
}
