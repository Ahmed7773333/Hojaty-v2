import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hojaty/features/prayers/data/models/prayers/prayers_helper.dart';

class NotificationService {
  static const String _channelKey = 'adhan_channel';
  static const String _channelName = 'Adhan Notifications';
  static const String _channelDescription = 'Notifications for prayer times';

  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
          channelGroupKey: 'adhan_channel_group',
          channelKey: _channelKey,
          channelName: _channelName,
          channelDescription: _channelDescription,
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          soundSource: 'resource://raw/azan', // For Android
          playSound: true,
          enableVibration: true,
          criticalAlerts: true,
        ),
      ],
      // Channel groups are only visual and are optional
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'adhan_channel_group',
          channelGroupName: 'Adhan Group',
        ),
      ],
      debug: true,
    );

    await _requestPermission();
    await _configureListeners();
  }

  static Future<void> _requestPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<void> _configureListeners() async {
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    debugPrint('onDismissActionReceivedMethod');
    if (receivedAction.buttonKeyPressed == 'STOP_AZAN') {
      await AwesomeNotifications().cancel(receivedAction.id!);
    }
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    debugPrint('onActionReceivedMethod');

    // Always stop the sound when any action is received (tap or button)
    // Scheduling with precise alarms might keep playing sound, so we explicitly cancel/stop.
    // However, clicking the notification automatically dismisses it usually,
    // but extracting logic:

    if (receivedAction.buttonKeyPressed == 'STOP_AZAN') {
      // Stop action
      debugPrint('Stop Azan button pressed');
    } else {
      // Normal tap, app opens.
      // Sound should stop if notification is dismissed.
      debugPrint('Notification tapped');
    }
  }

  static Future<void> schedulePrayerNotifications() async {
    // Cancel all previous schedules to avoid duplicates
    await AwesomeNotifications().cancelAllSchedules();
    // await AwesomeNotifications().cancelAll();

    final prayersHelper = PrayersHelper();
    final prayerTimes = await prayersHelper.getTodayPrayerTimes();

    int id = 1;
    final now = DateTime.now();

    for (var entry in prayerTimes.entries) {
      final prayerName = entry.key;
      final prayerTime = entry.value;

      if (prayerTime.isAfter(now)) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: _channelKey,
            title: 'Time for $prayerName',
            body: 'It is now time for $prayerName prayer.',
            bigPicture: 'asset://assets/images/madina.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            category: NotificationCategory.Alarm, // To make it like an alarm
            wakeUpScreen: true,
            fullScreenIntent: true,
            autoDismissible: false, // User must interact
            payload: {'prayer': prayerName},
            customSound: 'resource://raw/azan',
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'STOP_AZAN',
              label: 'Stop Azan',
              actionType: ActionType
                  .DismissAction, // Dismisses notification and stops sound
              autoDismissible: true,
            ),
            NotificationActionButton(
              key: 'OPEN_APP',
              label: 'Open App',
              actionType: ActionType.Default,
              autoDismissible: true,
            ),
          ],
          schedule: NotificationCalendar.fromDate(date: prayerTime),
        );
        debugPrint('Scheduled $prayerName at $prayerTime with ID $id');
        id++;
      }
    }
  }

  static Future<void> cancelAll() async {
    await AwesomeNotifications().cancelAll();
  }
}
