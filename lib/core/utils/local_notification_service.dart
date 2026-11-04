import 'dart:developer';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../config/routes/app_router.dart';
import '../../features/homelayout/data/models/occasion_item_model.dart';
import '../../features/homelayout/data/models/prayer_time_model.dart';
import '../../features/homelayout/data/models/prayers_helper.dart';
import '../../main.dart';
import '../local/user_hive_helper.dart';

class LocalNotificationService {
  /// Check if current platform is supported by awesome_notifications
  static bool get isSupportedPlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);

  // Channel Keys
  static const String prayersChannelKey = 'prayers_channel_makkah';
  static const String prayersChannelMakkahKey = 'prayers_channel_makkah';
  static const String prayersChannelMadinahKey = 'prayers_channel_madinah';
  static const String prayersChannelAzanKey = 'prayers_channel_azan';
  static const String occasionsChannelKey = 'occasions_channel';
  static const String anaOsalyChannelKey = 'hojaty_channel';
  static const String generalChannelKey = 'general_channel';

  /// Initialize Awesome Notifications with all required channels
  static Future<void> init() async {
    if (!isSupportedPlatform) {
      log(
        'LocalNotificationService: Platform not supported for awesome_notifications.',
      );
      return;
    }
    log('Initializing LocalNotificationService...');
    try {
      await AwesomeNotifications().initialize(
        null, // null uses default app launcher icon across platforms
        [
          // 1. Makkah Prayer Channel
          NotificationChannel(
            channelKey: prayersChannelMakkahKey,
            channelName: 'أذان مكة المكرمة',
            channelDescription: 'تنبيهات مواقيت الصلاة بصوت أذان مكة المكرمة',
            defaultColor: const Color(0xFF1E3A34),
            ledColor: const Color(0xFFD4AF37),
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            playSound: true,
            soundSource: Platform.isAndroid
                ? 'resource://raw/makka_azan'
                : null,
            enableVibration: true,
          ),

          // 2. Madinah Prayer Channel
          NotificationChannel(
            channelKey: prayersChannelMadinahKey,
            channelName: 'أذان المدينة المنورة',
            channelDescription:
                'تنبيهات مواقيت الصلاة بصوت أذان المدينة المنورة',
            defaultColor: const Color(0xFF1E3A34),
            ledColor: const Color(0xFFD4AF37),
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            playSound: true,
            soundSource: Platform.isAndroid
                ? 'resource://raw/madina_azan'
                : null,
            enableVibration: true,
          ),

          // 3. Traditional Azan Prayer Channel
          NotificationChannel(
            channelKey: prayersChannelAzanKey,
            channelName: 'الأذان التقليدي',
            channelDescription: 'تنبيهات مواقيت الصلاة بصوت الأذان التقليدي',
            defaultColor: const Color(0xFF1E3A34),
            ledColor: const Color(0xFFD4AF37),
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            playSound: true,
            soundSource: Platform.isAndroid ? 'resource://raw/azan' : null,
            enableVibration: true,
          ),

          // 4. Occasions Channel (High Importance)
          NotificationChannel(
            channelKey: occasionsChannelKey,
            channelName: 'المناسبات الإسلامية',
            channelDescription: 'تذكير بالمناسبات الإسلامية ومواسم الطاعات',
            defaultColor: const Color(0xFF1E3A34),
            ledColor: const Color(0xFFD4AF37),
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
            enableVibration: true,
          ),

          // 5. Hojaty Channel (Prayer Window Alert)
          NotificationChannel(
            channelKey: anaOsalyChannelKey,
            channelName: 'وضع حچتي',
            channelDescription:
                'تنبيهات بدء وانتهاء نافذة الصلاة والرد التلقائي',
            defaultColor: const Color(0xFF1E3A34),
            ledColor: const Color(0xFFD4AF37),
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
          ),

          // 6. General Notifications (Athkar, Reminders)
          NotificationChannel(
            channelKey: generalChannelKey,
            channelName: 'تنبيهات عامة',
            channelDescription: 'الأذكار اليومية والتنبيهات العامة',
            defaultColor: const Color(0xFF1E3A34),
            importance: NotificationImportance.Default,
            channelShowBadge: true,
            playSound: true,
          ),
        ],
        debug: false,
      );

      _setListeners();
      log('LocalNotificationService initialized successfully.');
    } catch (e, st) {
      log('Error initializing LocalNotificationService: $e\n$st');
      try {
        await AwesomeNotifications().initialize(null, [
          NotificationChannel(
            channelKey: prayersChannelMakkahKey,
            channelName: 'أذان مكة المكرمة',
            channelDescription: 'تنبيهات مواقيت الصلاة بصوت أذان مكة المكرمة',
            importance: NotificationImportance.Max,
            playSound: true,
          ),
          NotificationChannel(
            channelKey: prayersChannelMadinahKey,
            channelName: 'أذان المدينة المنورة',
            channelDescription:
                'تنبيهات مواقيت الصلاة بصوت أذان المدينة المنورة',
            importance: NotificationImportance.Max,
            playSound: true,
          ),
          NotificationChannel(
            channelKey: prayersChannelAzanKey,
            channelName: 'الأذان التقليدي',
            channelDescription: 'تنبيهات مواقيت الصلاة بصوت الأذان التقليدي',
            importance: NotificationImportance.Max,
            playSound: true,
          ),
          NotificationChannel(
            channelKey: occasionsChannelKey,
            channelName: 'المناسبات الإسلامية',
            channelDescription: 'تذكير بالمناسبات الإسلامية ومواسم الطاعات',
            importance: NotificationImportance.High,
          ),
          NotificationChannel(
            channelKey: anaOsalyChannelKey,
            channelName: 'وضع حچتي',
            channelDescription:
                'تنبيهات بدء وانتهاء نافذة الصلاة والرد التلقائي',
            importance: NotificationImportance.High,
          ),
          NotificationChannel(
            channelKey: generalChannelKey,
            channelName: 'تنبيهات عامة',
            channelDescription: 'الأذكار اليومية والتنبيهات العامة',
            importance: NotificationImportance.Default,
          ),
        ], debug: false);
        _setListeners();
        log('LocalNotificationService initialized with fallback channels.');
      } catch (fallbackErr) {
        log('Fallback initialization error: $fallbackErr');
      }
    }
  }

  /// Check and request notification permissions
  static Future<bool> requestPermission() async {
    if (!isSupportedPlatform) return false;
    try {
      final bool isAllowed = await AwesomeNotifications()
          .isNotificationAllowed();
      if (!isAllowed) {
        return await AwesomeNotifications()
            .requestPermissionToSendNotifications();
      }
      return true;
    } catch (e) {
      log('Error requesting notification permission: $e');
      return false;
    }
  }

  /// Sets notification action and lifecycle listeners
  static void _setListeners() {
    if (!isSupportedPlatform) return;
    try {
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      );
    } catch (e) {
      log('Error setting notification listeners: $e');
    }
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    log('Notification created: ${receivedNotification.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    log('Notification displayed: ${receivedNotification.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    log('Notification dismissed: ${receivedAction.id}');
  }

  /// Action listener: handles notification clicks and navigates via AnaOsalyApp.navigatorKey
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    log(
      'Notification action clicked: ${receivedAction.id}, payload: ${receivedAction.payload}',
    );

    final payload = receivedAction.payload ?? {};
    final type = payload['type'];

    final navContext = AnaOsalyApp.navigatorKey.currentContext;
    if (navContext == null) return;

    if (type == 'prayer') {
      Navigator.of(navContext).pushNamed(AppRoutes.prayerTimes);
    } else if (type == 'occasion') {
      Navigator.of(navContext).pushNamed(
        AppRoutes.occasionDetail,
        arguments: payload['occasionTitle'],
      );
    } else if (type == 'hojaty') {
      Navigator.of(navContext).pushNamed(
        AppRoutes.prayerTimes,
        arguments: 2, // 3rd tab (Hojaty)
      );
    }
  }

  static String getPrayerChannelKey([String? soundId]) {
    final selectedId = soundId ?? UserHiveHelper.getSelectedAdhanSound();
    switch (selectedId) {
      case 'madinah':
        return prayersChannelMadinahKey;
      case 'azan':
        return prayersChannelAzanKey;
      case 'makkah':
      default:
        return prayersChannelMakkahKey;
    }
  }

  static String getSoundResource([String? soundId]) {
    final selectedId = soundId ?? UserHiveHelper.getSelectedAdhanSound();
    switch (selectedId) {
      case 'madinah':
        return 'resource://raw/madina_azan';
      case 'azan':
        return 'resource://raw/azan';
      case 'makkah':
      default:
        return 'resource://raw/makka_azan';
    }
  }

  // ---------------------------------------------------------------------------
  // Scheduling Operations
  // ---------------------------------------------------------------------------

  /// Schedules prayer notifications for upcoming prayers
  static Future<void> schedulePrayerNotifications({
    required List<PrayerTimeModel> prayers,
    required bool isFullAdhan,
    required String language,
    String? soundId,
  }) async {
    if (!isSupportedPlatform) return;
    try {
      await cancelPrayerNotifications();
      final now = DateTime.now();
      const helper = PrayersHelper(coordinates: GeoCoordinates.cairo);
      final localTz = await AwesomeNotifications().getLocalTimeZoneIdentifier();

      final todayDate = DateTime(now.year, now.month, now.day);
      final tomorrowDate = todayDate.add(const Duration(days: 1));

      final todayTimes = helper.getPrayerDateTimes(todayDate);
      final tomorrowTimes = helper.getPrayerDateTimes(tomorrowDate);
      final soundResource = getSoundResource(soundId);

      for (int i = 0; i < PrayerType.values.length; i++) {
        final type = PrayerType.values[i];

        // Determine if notification is enabled from the provided list or user preferences
        final prayerModel = prayers.where((p) => p.type == type).firstOrNull;
        final isEnabled =
            prayerModel?.isNotificationEnabled ??
            UserHiveHelper.getPrayerNotification(type.name, defaultValue: true);
        if (!isEnabled) continue;

        // Use today's prayer time if upcoming; otherwise roll over to tomorrow
        DateTime targetTime = todayTimes[type]!;
        if (targetTime.isBefore(now)) {
          targetTime = tomorrowTimes[type]!;
        }

        final prayerName = PrayersHelper.getPrayerName(
          type,
          language: language,
        );
        final title = language == 'ar'
            ? 'حان الآن وقت صلاة $prayerName'
            : 'It is now time for $prayerName prayer';
        final body = language == 'ar'
            ? 'حي على الصلاة، حي على الفلاح'
            : 'Come to prayer, come to success';

        final id = 100 + type.index;

        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: getPrayerChannelKey(soundId),
            title: title,
            body: body,
            customSound: (isFullAdhan && Platform.isAndroid)
                ? soundResource
                : null,
            notificationLayout: NotificationLayout.Default,
            category: NotificationCategory.Alarm,
            wakeUpScreen: true,
            fullScreenIntent: true,
            payload: {'type': 'prayer', 'prayer': type.name},
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'OPEN_APP',
              label: language == 'ar' ? 'فتح التطبيق' : 'Open App',
            ),
            NotificationActionButton(
              key: 'DISMISS',
              label: language == 'ar' ? 'إيقاف' : 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true,
            ),
          ],
          schedule: NotificationCalendar(
            year: targetTime.year,
            month: targetTime.month,
            day: targetTime.day,
            hour: targetTime.hour,
            minute: targetTime.minute,
            second: targetTime.second,
            millisecond: 0,
            repeats: false,
            allowWhileIdle: true,
            preciseAlarm: true,
            timeZone: localTz,
          ),
        );

        log(
          'Scheduled prayer notification for $prayerName at $targetTime (TZ: $localTz) with ID $id and sound $soundResource',
        );
      }
    } catch (e, st) {
      log('Error scheduling prayer notifications: $e\n$st');
    }
  }

  /// Schedules reminders for upcoming Islamic Occasions
  static Future<void> scheduleOccasionsNotifications({
    required List<OccasionItemModel> occasions,
    required String language,
  }) async {
    if (!isSupportedPlatform) return;
    try {
      await cancelOccasionNotifications();
      final now = DateTime.now();

      for (int i = 0; i < occasions.length; i++) {
        final occasion = occasions[i];
        final targetDate = occasion.targetDateTime;
        if (targetDate == null || targetDate.isBefore(now)) continue;

        final id = 200 + i;

        // Reminder 1: Day before at 09:00 AM
        final dayBefore = targetDate.subtract(const Duration(days: 1));
        final dayBeforeTime = DateTime(
          dayBefore.year,
          dayBefore.month,
          dayBefore.day,
          9,
          0,
        );

        if (dayBeforeTime.isAfter(now)) {
          final title = language == 'ar'
              ? 'تذكير بمناسبة إسلامية قادمة'
              : 'Upcoming Islamic Occasion Reminder';
          final body = language == 'ar'
              ? 'غداً يوافق ${occasion.title} (${occasion.hijriDate})'
              : 'Tomorrow is ${occasion.title} (${occasion.hijriDate})';

          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: id * 10 + 1,
              channelKey: occasionsChannelKey,
              title: title,
              body: body,
              category: NotificationCategory.Reminder,
              payload: {'type': 'occasion', 'occasionTitle': occasion.title},
            ),
            schedule: NotificationCalendar.fromDate(
              date: dayBeforeTime,
              allowWhileIdle: true,
              preciseAlarm: true,
            ),
          );
        }

        // Reminder 2: Morning of the occasion at 08:00 AM
        final morningTime = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          8,
          0,
        );

        if (morningTime.isAfter(now)) {
          final title = language == 'ar'
              ? 'اليوم: ${occasion.title}'
              : 'Today: ${occasion.title}';
          final body = language == 'ar'
              ? 'كل عام وأنتم بخير بمناسبة ${occasion.title}'
              : 'Blessed ${occasion.title} to you and your family';

          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: id * 10 + 2,
              channelKey: occasionsChannelKey,
              title: title,
              body: body,
              category: NotificationCategory.Event,
              payload: {'type': 'occasion', 'occasionTitle': occasion.title},
            ),
            schedule: NotificationCalendar.fromDate(
              date: morningTime,
              allowWhileIdle: true,
              preciseAlarm: true,
            ),
          );
        }
      }
    } catch (e, st) {
      log('Error scheduling occasion notifications: $e\n$st');
    }
  }

  /// Shows an instant test notification
  static Future<void> showTestNotification({
    required bool isFullAdhan,
    required String language,
    String? soundId,
  }) async {
    if (!isSupportedPlatform) return;
    try {
      await requestPermission();

      final title = language == 'ar'
          ? 'اختبار تنبيه الصلاة والأذان'
          : 'Prayer & Adhan Notification Test';
      final body = language == 'ar'
          ? 'حان الآن وقت صلاة الظهر - حي على الصلاة'
          : 'It is now time for Dhuhr prayer - Come to prayer';

      final soundResource = getSoundResource(soundId);

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 999,
          channelKey: getPrayerChannelKey(soundId),
          title: title,
          body: body,
          customSound: (isFullAdhan && Platform.isAndroid)
              ? soundResource
              : null,
          category: NotificationCategory.Alarm,
          wakeUpScreen: true,
          payload: {'type': 'prayer', 'prayer': 'dhuhr'},
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'OPEN_APP',
            label: language == 'ar' ? 'فتح التطبيق' : 'Open App',
          ),
          NotificationActionButton(
            key: 'DISMISS',
            label: language == 'ar' ? 'إيقاف الأذان' : 'Stop Adhan',
            actionType: ActionType.DismissAction,
            isDangerousOption: true,
          ),
        ],
      );
      log(
        'Instant test notification sent successfully with sound: $soundResource',
      );
    } catch (e, st) {
      log('Error sending test notification: $e\n$st');
    }
  }

  /// Cancels all prayer notifications (IDs 100 to 199)
  static Future<void> cancelPrayerNotifications() async {
    if (!isSupportedPlatform) return;
    for (int id = 100; id <= 199; id++) {
      try {
        await AwesomeNotifications().cancel(id);
        await AwesomeNotifications().cancelSchedule(id);
      } catch (_) {}
    }
  }

  /// Cancels all occasion notifications (IDs 2000 to 3000)
  static Future<void> cancelOccasionNotifications() async {
    if (!isSupportedPlatform) return;
    for (int id = 2000; id <= 3000; id++) {
      try {
        await AwesomeNotifications().cancel(id);
      } catch (_) {}
    }
  }

  /// Cancels all scheduled notifications
  static Future<void> cancelAll() async {
    if (!isSupportedPlatform) return;
    try {
      await AwesomeNotifications().cancelAll();
    } catch (_) {}
  }
}
