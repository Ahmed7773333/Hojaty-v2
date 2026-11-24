import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/features/homelayout/data/models/occasion_item_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayers_helper.dart';
import 'package:hojaty/features/homelayout/data/services/azan_audio_service.dart';

@pragma('vm:entry-point')
class LocalNotificationService {
  static bool get isSupportedPlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);

  static const MethodChannel _notifChannel = MethodChannel(
    'com.wolfdev.hojaty/notifications',
  );

  static const MethodChannel _flipChannel = MethodChannel(
    'com.wolfdev.hojaty/azan_flip',
  );

  static const int salawatNotificationId = 777;

  /// Initialize native notification channels and flip listener
  static Future<void> init() async {
    if (!isSupportedPlatform) return;
    try {
      log('Initializing Native LocalNotificationService...');
      if (Platform.isAndroid || Platform.isIOS) {
        await _notifChannel.invokeMethod('init');

        _flipChannel.setMethodCallHandler((call) async {
          if (call.method == 'onAzanStoppedByFlip') {
            final notifId = call.arguments?['notificationId'];
            log('Azan notification $notifId stopped by face-down flip.');
          }
        });

        if (Platform.isIOS) {
          await requestPermission();
        }
      }
      log('Native LocalNotificationService initialized successfully.');
    } catch (e, st) {
      log('LocalNotificationService initialization error: $e\n$st');
    }
  }

  /// Request notification & alarm permissions
  static Future<bool> requestPermission() async {
    if (!isSupportedPlatform) return false;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final res = await _notifChannel.invokeMethod<bool>('requestPermission');
        return res ?? true;
      }
      return true;
    } catch (e) {
      log('Error requesting permissions: $e');
      return false;
    }
  }

  /// Stop all playing alarm/notification audio
  static Future<void> stopAllAudio() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    try {
      await _notifChannel.invokeMethod('stopAllAudio');
    } catch (_) {}
  }

  /// Schedules prayer notifications for upcoming prayers
  static Future<void> schedulePrayerNotifications({
    required List<PrayerTimeModel> prayers,
    required bool isFullAdhan,
    required String language,
    String? soundId,
    bool isPreReminderEnabled = true,
    int preReminderMinutes = 5,
    Map<String, int>? prayerPreReminderMinutes,
  }) async {
    if (!isSupportedPlatform) return;
    try {
      await cancelPrayerNotifications();

      final now = DateTime.now();
      final coords = UserHiveHelper.getCachedCoordinates();
      final helper = PrayersHelper(
        coordinates: coords,
        parameters: UserHiveHelper.getPrayerCalculationParameters(coords),
      );

      final todayDate = DateTime(now.year, now.month, now.day);
      final tomorrowDate = todayDate.add(const Duration(days: 1));

      final todayTimes = helper.getPrayerDateTimes(todayDate);
      final tomorrowTimes = helper.getPrayerDateTimes(tomorrowDate);

      for (int i = 0; i < PrayerType.values.length; i++) {
        final type = PrayerType.values[i];
        final prayerModel = prayers.where((p) => p.type == type).firstOrNull;
        final isEnabled =
            prayerModel?.isNotificationEnabled ??
            UserHiveHelper.getPrayerNotification(type.name);
        if (!isEnabled) continue;

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
        final prayerSoundId = UserHiveHelper.getPrayerAdhanSound(
          type.name,
          defaultValue: soundId ?? 'makkah',
        );

        final isBuiltIn =
            prayerSoundId == 'makkah' ||
            prayerSoundId == 'madinah' ||
            prayerSoundId == 'azan';

        String? localSoundPath;
        if (!isBuiltIn) {
          try {
            localSoundPath = await injector<AzanAudioService>()
                .getExistingLocalPath(prayerSoundId);
          } catch (_) {}
        }

        if (Platform.isAndroid || Platform.isIOS) {
          await _notifChannel.invokeMethod('schedulePrayer', {
            'id': id,
            'triggerTimeMillis': targetTime.millisecondsSinceEpoch,
            'title': title,
            'body': body,
            'soundId': isFullAdhan ? prayerSoundId : 'short_reminder',
            'soundPath': (isFullAdhan && localSoundPath != null)
                ? localSoundPath
                : '',
          });

          // Pre-prayer reminder
          final specificPreMinutes =
              prayerPreReminderMinutes?[type.name] ??
              UserHiveHelper.getPrayerPreAdhanReminderMinutes(
                type.name,
                defaultValue: preReminderMinutes,
              );

          if (isPreReminderEnabled && specificPreMinutes > 0) {
            final preTime = targetTime.subtract(
              Duration(minutes: specificPreMinutes),
            );
            if (preTime.isAfter(now)) {
              final preId = 150 + type.index;
              final preTitle = language == 'ar'
                  ? 'اقترب موعد صلاة $prayerName'
                  : '$prayerName prayer is approaching';
              final preBody = language == 'ar'
                  ? 'فاضل $specificPreMinutes دقائق على صلاة $prayerName، استعد للصلاة'
                  : 'Remaining $specificPreMinutes minutes until $prayerName prayer. Prepare for prayer.';

              await _notifChannel.invokeMethod('schedulePrePrayer', {
                'id': preId,
                'triggerTimeMillis': preTime.millisecondsSinceEpoch,
                'title': preTitle,
                'body': preBody,
              });
            }
          }
        }
      }
      log('All prayer and pre-prayer alarms scheduled successfully.');
    } catch (e, st) {
      log('Error scheduling prayer notifications: $e\n$st');
    }
  }

  /// Cancels all prayer and pre-prayer alarms
  static Future<void> cancelPrayerNotifications() async {
    if (!isSupportedPlatform) return;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await _notifChannel.invokeMethod('cancelAllPrayers');
        await _notifChannel.invokeMethod('cancelAllPrePrayers');
      }
      log('All prayer notifications cancelled.');
    } catch (e) {
      log('Error cancelling prayer notifications: $e');
    }
  }

  /// Shows an instant test notification for Adhan
  static Future<void> showTestNotification({
    required bool isFullAdhan,
    required String language,
    String? soundId,
  }) async {
    if (!isSupportedPlatform) return;
    try {
      final effectiveSoundId =
          soundId ?? UserHiveHelper.getSelectedAdhanSound();
      final isBuiltIn =
          effectiveSoundId == 'makkah' ||
          effectiveSoundId == 'madinah' ||
          effectiveSoundId == 'azan';

      String? localSoundPath;
      if (!isBuiltIn) {
        try {
          localSoundPath = await injector<AzanAudioService>()
              .getExistingLocalPath(effectiveSoundId);
        } catch (_) {}
      }

      final title = language == 'ar'
          ? 'اختبار تنبيه الصلاة والأذان'
          : 'Prayer & Adhan Notification Test';
      final body = language == 'ar'
          ? 'حان الآن وقت صلاة الظهر - حي على الصلاة'
          : 'It is now time for Dhuhr prayer - Come to prayer';

      if (Platform.isAndroid || Platform.isIOS) {
        await _notifChannel.invokeMethod('showTestNotification', {
          'isFullAdhan': isFullAdhan,
          'soundId': isFullAdhan ? effectiveSoundId : 'short_reminder',
          'soundPath': (isFullAdhan && localSoundPath != null)
              ? localSoundPath
              : '',
          'title': title,
          'body': body,
        });
      }
      log('Test adhan notification triggered successfully.');
    } catch (e, st) {
      log('Error showing test notification: $e\n$st');
    }
  }

  /// Displays an instant test notification for the pre-adhan reminder
  static Future<void> showTestPreAdhanNotification({
    required String language,
    int minutes = 5,
    PrayerType prayerType = PrayerType.dhuhr,
  }) async {
    if (!isSupportedPlatform) return;
    try {
      final prayerName = PrayersHelper.getPrayerName(
        prayerType,
        language: language,
      );
      final title = language == 'ar'
          ? 'اقترب موعد صلاة $prayerName'
          : '$prayerName prayer is approaching';
      final body = language == 'ar'
          ? 'فاضل $minutes دقائق على صلاة $prayerName، استعد للصلاة'
          : 'Remaining $minutes minutes until $prayerName prayer. Prepare for prayer.';

      if (Platform.isAndroid || Platform.isIOS) {
        await _notifChannel.invokeMethod('showTestPreAdhanNotification', {
          'title': title,
          'body': body,
        });
      }
      log('Test pre-adhan notification triggered successfully.');
    } catch (e, st) {
      log('Error showing test pre-adhan notification: $e\n$st');
    }
  }

  /// Schedules an hourly recurring notification for Salawat on the Prophet ﷺ
  static Future<void> scheduleSalawatNotification({
    required String language,
    bool enabled = true,
  }) async {
    if (!isSupportedPlatform) return;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await _notifChannel.invokeMethod('scheduleSalawat', {
          'enabled': enabled,
        });
      }
      log('Salawat notification schedule updated: enabled=$enabled');
    } catch (e, st) {
      log('Error scheduling Salawat notification: $e\n$st');
    }
  }

  /// Cancels the hourly Salawat notification
  static Future<void> cancelSalawatNotification() async {
    await scheduleSalawatNotification(language: 'ar', enabled: false);
  }

  /// Shows an immediate test notification with the Salawat audio
  static Future<void> showTestSalawatNotification({
    required String language,
  }) async {
    if (!isSupportedPlatform) return;
    try {
      final title = language == 'ar'
          ? 'الصلاة على النبي ﷺ'
          : 'Blessings upon the Prophet ﷺ';
      final body = language == 'ar'
          ? 'اللهم صلِّ وسلِّم وبارك على سيدنا محمد وعلى آله وصحبه أجمعين'
          : 'O Allah, bestow peace and blessings upon our Master Muhammad';

      if (Platform.isAndroid || Platform.isIOS) {
        await _notifChannel.invokeMethod('showTestSalawatNotification', {
          'title': title,
          'body': body,
        });
      }
      log('Test Salawat notification triggered successfully.');
    } catch (e, st) {
      log('Error showing test Salawat notification: $e\n$st');
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
        );

        if (dayBeforeTime.isAfter(now)) {
          final title = language == 'ar'
              ? 'تذكير بمناسبة إسلامية قادمة'
              : 'Upcoming Islamic Occasion Reminder';
          final body = language == 'ar'
              ? 'غداً يوافق ${occasion.title} (${occasion.hijriDate})'
              : 'Tomorrow is ${occasion.title} (${occasion.hijriDate})';

          if (Platform.isAndroid || Platform.isIOS) {
            await _notifChannel.invokeMethod('scheduleOccasion', {
              'id': id * 10 + 1,
              'triggerTimeMillis': dayBeforeTime.millisecondsSinceEpoch,
              'title': title,
              'body': body,
            });
          }
        }

        // Reminder 2: Morning of the occasion at 08:00 AM
        final morningTime = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          8,
        );

        if (morningTime.isAfter(now)) {
          final title = language == 'ar'
              ? 'اليوم: ${occasion.title}'
              : 'Today: ${occasion.title}';
          final body = language == 'ar'
              ? 'كل عام وأنتم بخير بمناسبة ${occasion.title}'
              : 'Blessed ${occasion.title} to you and your family';

          if (Platform.isAndroid || Platform.isIOS) {
            await _notifChannel.invokeMethod('scheduleOccasion', {
              'id': id * 10 + 2,
              'triggerTimeMillis': morningTime.millisecondsSinceEpoch,
              'title': title,
              'body': body,
            });
          }
        }
      }
      log('Occasions notifications scheduled successfully.');
    } catch (e, st) {
      log('Error scheduling occasion notifications: $e\n$st');
    }
  }

  /// Cancels all occasion notifications
  static Future<void> cancelOccasionNotifications() async {
    if (!isSupportedPlatform) return;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await _notifChannel.invokeMethod('cancelAllOccasions');
      }
      log('Occasion notifications cancelled.');
    } catch (e) {
      log('Error cancelling occasion notifications: $e');
    }
  }

  /// Cancels all notifications across all categories
  static Future<void> cancelAll() async {
    await cancelPrayerNotifications();
    await cancelSalawatNotification();
    await cancelOccasionNotifications();
    await stopAllAudio();
  }
}
