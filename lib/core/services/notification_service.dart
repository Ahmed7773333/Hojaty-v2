import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:hojaty/features/prayers/data/models/prayers/prayers_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../features/home/data/models/user_db_helper.dart';

class NotificationService {
  /// Initialize notification permissions
  static Future<void> initializeNotifications() async {
    try {
      // Request notification permission on Android 13+
      if (Platform.isAndroid) {
        final status = await Permission.notification.status;
        if (status.isDenied) {
          await Permission.notification.request();
        }

        // Check for exact alarm permission on Android 12+
        await checkAndroidScheduleExactAlarmPermission();
      }
      debugPrint('Notification service initialized');
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  /// Check and request exact alarm permission for Android 12+
  static Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    debugPrint('Schedule exact alarm permission: $status');
    if (status.isDenied) {
      debugPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      debugPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not '}granted.',
      );
    }
  }

  /// Schedule prayer alarms using the alarm package
  static Future<void> schedulePrayerNotifications() async {
    try {
      // Cancel all previous alarms to avoid duplicates
      await Alarm.stopAll();

      final user = UserDbHelper.getById();
      if (user != null && !user.uiShowNotifications) {
        debugPrint('Notifications disabled by user');
        return;
      }

      final isSound = user?.uiIsSoundEnabled ?? true;
      final isVibrate = user?.uiIsVibrateEnabled ?? true;

      final prayersHelper = PrayersHelper();
      final prayerTimes = await prayersHelper.getTodayPrayerTimes();

      int id = 1;
      final now = DateTime.now();

      for (var entry in prayerTimes.entries) {
        final prayerName = entry.key;
        final prayerTime = entry.value;

        if (prayerTime.isAfter(now)) {
          final alarmSettings = AlarmSettings(
            id: id,
            dateTime: prayerTime,
            assetAudioPath: 'assets/azan.mp3',
            loopAudio: false, // Azan should play once
            vibrate: isVibrate,
            warningNotificationOnKill: Platform.isIOS,
            androidFullScreenIntent: true,
            volumeSettings: VolumeSettings.fade(
              volume: isSound ? 1.0 : 0.0,
              fadeDuration: const Duration(seconds: 3),
              volumeEnforced: true,
            ),
            notificationSettings: NotificationSettings(
              title: 'حان وقت صلاة $prayerName',
              body: 'حان الآن وقت صلاة $prayerName',
              stopButton: 'إيقاف الأذان',
              icon: 'notification_icon',
            ),
          );

          await Alarm.set(alarmSettings: alarmSettings);
          debugPrint('Scheduled $prayerName alarm at $prayerTime with ID $id');
          id++;
        }
      }
    } catch (e) {
      debugPrint('Error scheduling prayer alarms: $e');
    }
  }

  /// Cancel all scheduled alarms
  static Future<void> cancelAll() async {
    await Alarm.stopAll();
  }

  /// Stop a specific alarm by ID
  static Future<void> stopAlarm(int id) async {
    await Alarm.stop(id);
  }

  /// Shows a test alarm (triggers after 5 seconds for testing)
  static Future<void> showTestNotification() async {
    try {
      // Request permissions first
      if (Platform.isAndroid) {
        final notificationStatus = await Permission.notification.status;
        if (notificationStatus.isDenied) {
          await Permission.notification.request();
        }
        await checkAndroidScheduleExactAlarmPermission();
      }

      final testAlarmTime = DateTime.now().add(const Duration(seconds: 5));

      final alarmSettings = AlarmSettings(
        id: 9999, // Unique ID for test alarm
        dateTime: testAlarmTime,
        assetAudioPath: 'assets/azan.mp3',
        loopAudio: false,
        vibrate: true,
        warningNotificationOnKill: Platform.isIOS,
        androidFullScreenIntent: true,
        volumeSettings: VolumeSettings.fade(
          volume: 1.0,
          fadeDuration: const Duration(seconds: 2),
          volumeEnforced: true,
        ),
        notificationSettings: const NotificationSettings(
          title: 'اختبار الأذان',
          body: 'هذا اختبار لتنبيه صلاة',
          stopButton: 'إيقاف',
          icon: 'notification_icon',
        ),
      );

      await Alarm.set(alarmSettings: alarmSettings);
      debugPrint('Test alarm scheduled for $testAlarmTime (in 5 seconds)');
    } catch (e) {
      debugPrint('Error scheduling test alarm: $e');
    }
  }
}
