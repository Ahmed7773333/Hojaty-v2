// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/features/homelayout/data/models/occasion_item_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayers_helper.dart';
import 'package:hojaty/features/homelayout/data/services/azan_audio_service.dart';
import 'package:hojaty/features/radio/services/radio_audio_player_service.dart';
import 'package:hojaty/hojaty_app.dart';

@pragma('vm:entry-point')
class LocalNotificationService {
  /// Check if current platform is supported by awesome_notifications
  static bool get isSupportedPlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);

  // MethodChannel for native device flip detection (flip face-down to stop Azan)
  static const MethodChannel _flipMethodChannel = MethodChannel(
    'com.wolfdev.hojaty/azan_flip',
  );

  // Channel Keys (v2 to guarantee no vibration across all device states & clear cached OS settings)
  static const String prayersChannelKey = 'prayers_channel_makkah_v2';
  static const String prayersChannelMakkahKey = 'prayers_channel_makkah_v2';
  static const String prayersChannelMadinahKey = 'prayers_channel_madinah_v2';
  static const String prayersChannelAzanKey = 'prayers_channel_azan_v2';
  static const String prayersChannelCustomKey = 'prayers_channel_custom_v2';
  static const String prePrayerChannelKey = 'pre_prayer_channel_v3';
  static const String occasionsChannelKey = 'occasions_channel_v2';
  static const String anaOsalyChannelKey = 'hojaty_channel_v2';
  static const String generalChannelKey = 'general_channel_v2';
  static const String salawatChannelKey = 'salawat_channel_v3';

  static const int salawatNotificationId = 777;
  static const int salawatTestNotificationId = 776;
  static int _salawatTestToggle = 0;
  static int _adhanTestToggle = 0;
  static int _preAdhanTestToggle = 0;

  /// Default notification small icon resource for Android
  static const String defaultNotificationIcon =
      'resource://drawable/res_app_icon';

  static String? _currentPlayingSound;
  static bool _isLoadingAudio = false;

  static Future<void> _playCustomAdhan(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return;

      if (_currentPlayingSound == filePath &&
          (RadioAudioPlayerService().isPlaying || _isLoadingAudio)) {
        return;
      }

      _currentPlayingSound = filePath;
      _isLoadingAudio = true;

      await _stopCustomAdhan();
      _currentPlayingSound = filePath;

      await RadioAudioPlayerService().playFilePath(
        filePath: filePath,
        surahName: 'الأذان',
        reciterName: 'مواقيت الصلاة',
        album: 'أصوات الأذان',
        isAlert: true,
      );
      log('Playing custom adhan notification sound: $filePath');
    } catch (e) {
      if (e is! PlatformException || e.code != 'abort') {
        log('Error playing custom adhan: $e');
      }
    } finally {
      _isLoadingAudio = false;
    }
  }

  static Future<void> _stopCustomAdhan() async {
    _currentPlayingSound = null;
    _isLoadingAudio = false;
    try {
      if (RadioAudioPlayerService().isPlaying) {
        await RadioAudioPlayerService().stop();
      }
    } catch (e) {
      if (e is! PlatformException || e.code != 'abort') {
        log('Error stopping custom adhan: $e');
      }
    }
  }

  static bool _isNativeSalawatSoundAvailable = false;
  static bool _isNativePrayerCloseSoundAvailable = false;

  static Future<void> _playSalawatAudio() async {
    try {
      const soundId = 'assets/audio/salli_ala_muhammad.wav';
      if (_currentPlayingSound == soundId &&
          (RadioAudioPlayerService().isPlaying || _isLoadingAudio)) {
        return;
      }

      _currentPlayingSound = soundId;
      _isLoadingAudio = true;

      await _stopCustomAdhan();
      _currentPlayingSound = soundId;

      await RadioAudioPlayerService().playAsset(
        assetPath: soundId,
        title: 'الصلاة على النبي ﷺ',
        artist: 'تطبيق أنا أصلي',
      );
      log('Playing Salawat audio via just_audio from asset');
    } catch (e) {
      if (e is! PlatformException || e.code != 'abort') {
        log('Error playing Salawat asset audio: $e');
      }
    } finally {
      _isLoadingAudio = false;
    }
  }

  static Future<void> _playPrePrayerAudio() async {
    try {
      const soundId = 'assets/audio/prayer_time_is_close.wav';
      if (_currentPlayingSound == soundId &&
          (RadioAudioPlayerService().isPlaying || _isLoadingAudio)) {
        return;
      }

      _currentPlayingSound = soundId;
      _isLoadingAudio = true;

      await _stopCustomAdhan();
      _currentPlayingSound = soundId;

      await RadioAudioPlayerService().playAsset(
        assetPath: soundId,
        title: 'اقترب موعد الصلاة',
        artist: 'تطبيق أنا أصلي',
      );
      log('Playing pre-prayer audio via just_audio from asset');
    } catch (e) {
      if (e is! PlatformException || e.code != 'abort') {
        log('Error playing pre-prayer asset audio: $e');
      }
    } finally {
      _isLoadingAudio = false;
    }
  }

  /// Helper to safely communicate with flip detector
  static Future<void> _startFlipDetector([int? notificationId]) async {
    if (!Platform.isAndroid) return;
    try {
      await _flipMethodChannel.invokeMethod('startFlipDetector', {
        'notificationId': notificationId,
      });
    } catch (_) {}
  }

  static Future<void> _stopFlipDetector() async {
    await _stopCustomAdhan();
    if (!Platform.isAndroid) return;
    try {
      await _flipMethodChannel.invokeMethod('stopFlipDetector');
    } catch (_) {}
  }

  /// Initialize Awesome Notifications with all required channels
  static Future<void> init() async {
    if (!isSupportedPlatform) {
      log(
        'LocalNotificationService: Platform not supported for awesome_notifications.',
      );
      return;
    }
    log('Initializing LocalNotificationService...');

    // Delete legacy channels from system settings to eliminate cached vibration settings
    if (Platform.isAndroid) {
      final legacyKeys = [
        'prayers_channel_makkah',
        'prayers_channel_madinah',
        'prayers_channel_azan',
        'occasions_channel',
        'hojaty_channel',
        'general_channel',
        'pre_prayer_channel',
        'pre_prayer_channel_v2',
        'prayers_channel',
        'salawat_channel_v2',
      ];
      for (final legacyKey in legacyKeys) {
        try {
          await AwesomeNotifications().removeChannel(legacyKey);
        } catch (_) {}
      }
    }

    try {
      await AwesomeNotifications().initialize(
        defaultNotificationIcon,
        _buildChannels(includeCustomRawSounds: true),
      );
      _isNativeSalawatSoundAvailable = true;
      _isNativePrayerCloseSoundAvailable = true;
      _setListeners();
      log('LocalNotificationService initialized with custom native sounds.');
    } catch (e) {
      log('LocalNotificationService custom sound validation: $e');
      _isNativeSalawatSoundAvailable = false;
      _isNativePrayerCloseSoundAvailable = false;
      try {
        await AwesomeNotifications().initialize(
          defaultNotificationIcon,
          _buildChannels(includeCustomRawSounds: false),
        );
        _setListeners();
        log('LocalNotificationService initialized with fallback channels.');
      } catch (fallbackErr, st) {
        log('Fallback initialization error: $fallbackErr\n$st');
      }
    }
  }

  static List<NotificationChannel> _buildChannels({
    required bool includeCustomRawSounds,
  }) {
    return [
      // 1. Makkah Prayer Channel (Vibration completely disabled)
      NotificationChannel(
        channelKey: prayersChannelMakkahKey,
        channelName: 'أذان مكة المكرمة',
        channelDescription: 'تنبيهات مواقيت الصلاة بصوت أذان مكة المكرمة',
        defaultColor: const Color(0xFF1E3A34),
        ledColor: const Color(0xFFD4AF37),
        icon: defaultNotificationIcon,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        playSound: true,
        criticalAlerts: true,
        soundSource: Platform.isAndroid ? 'resource://raw/makka_azan' : null,
        enableVibration: false,
        vibrationPattern: Int64List.fromList([0]),
        onlyAlertOnce: false,
      ),

      // 2. Madinah Prayer Channel (Vibration completely disabled)
      NotificationChannel(
        channelKey: prayersChannelMadinahKey,
        channelName: 'أذان المدينة المنورة',
        channelDescription: 'تنبيهات مواقيت الصلاة بصوت أذان المدينة المنورة',
        defaultColor: const Color(0xFF1E3A34),
        ledColor: const Color(0xFFD4AF37),
        icon: defaultNotificationIcon,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        playSound: true,
        criticalAlerts: true,
        soundSource: Platform.isAndroid ? 'resource://raw/madina_azan' : null,
        enableVibration: false,
        vibrationPattern: Int64List.fromList([0]),
        onlyAlertOnce: false,
      ),

      // 3. Traditional Azan Prayer Channel (Vibration completely disabled)
      NotificationChannel(
        channelKey: prayersChannelAzanKey,
        channelName: 'الأذان التقليدي',
        channelDescription: 'تنبيهات مواقيت الصلاة بصوت الأذان التقليدي',
        defaultColor: const Color(0xFF1E3A34),
        ledColor: const Color(0xFFD4AF37),
        icon: defaultNotificationIcon,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        playSound: true,
        criticalAlerts: true,
        soundSource: Platform.isAndroid ? 'resource://raw/azan' : null,
        enableVibration: false,
        vibrationPattern: Int64List.fromList([0]),
        onlyAlertOnce: false,
      ),

      // 3.5 Custom Adhan Channel (Silent channel - audio handled dynamically)
      NotificationChannel(
        channelKey: prayersChannelCustomKey,
        channelName: 'أذان مخصص',
        channelDescription: 'تنبيهات مواقيت الصلاة بصوت أذان مخصص',
        defaultColor: const Color(0xFF1E3A34),
        ledColor: const Color(0xFFD4AF37),
        icon: defaultNotificationIcon,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        playSound: false,
        criticalAlerts: true,
        enableVibration: false,
        vibrationPattern: Int64List.fromList([0]),
        onlyAlertOnce: false,
      ),

      // 4. Occasions Channel (Vibration completely disabled)
      NotificationChannel(
        channelKey: occasionsChannelKey,
        channelName: 'المناسبات الإسلامية',
        channelDescription: 'تذكير بالمناسبات الإسلامية ومواسم الطاعات',
        defaultColor: const Color(0xFF1E3A34),
        ledColor: const Color(0xFFD4AF37),
        icon: defaultNotificationIcon,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: false,
        vibrationPattern: Int64List.fromList([0]),
        onlyAlertOnce: false,
      ),

      // 5. Hojaty Channel (Vibration completely disabled)
      NotificationChannel(
        channelKey: anaOsalyChannelKey,
        channelName: 'وضع حچتي',
        channelDescription: 'تنبيهات بدء وانتهاء نافذة الصلاة والرد التلقائي',
        defaultColor: const Color(0xFF1E3A34),
        ledColor: const Color(0xFFD4AF37),
        icon: defaultNotificationIcon,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: false,
        vibrationPattern: Int64List.fromList([0]),
        onlyAlertOnce: false,
      ),

      // 6. General Notifications (Vibration completely disabled)
      NotificationChannel(
        channelKey: generalChannelKey,
        channelName: 'تنبيهات عامة',
        channelDescription: 'الأذكار اليومية والتنبيهات العامة',
        defaultColor: const Color(0xFF1E3A34),
        icon: defaultNotificationIcon,
        importance: NotificationImportance.Default,
        channelShowBadge: true,
        playSound: true,
        enableVibration: false,
        vibrationPattern: Int64List.fromList([0]),
        onlyAlertOnce: false,
      ),

      // 7. Pre-Prayer Reminder Channel (Vibration completely disabled)
      NotificationChannel(
        channelKey: prePrayerChannelKey,
        channelName: 'التنبيه المسبق للأذان',
        channelDescription:
            'تنبيه خفيف للتذكير باقتراب موعد الصلاة قبل دخول الوقت',
        defaultColor: const Color(0xFF1E3A34),
        ledColor: const Color(0xFFD4AF37),
        icon: defaultNotificationIcon,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        soundSource: includeCustomRawSounds && Platform.isAndroid
            ? 'resource://raw/prayer_time_is_close'
            : null,
        enableVibration: false,
        vibrationPattern: Int64List.fromList([0]),
        onlyAlertOnce: false,
      ),

      // 8. Salawat on the Prophet Reminder Channel
      NotificationChannel(
        channelKey: salawatChannelKey,
        channelName: 'الصلاة على النبي ﷺ',
        channelDescription:
            'تذكير دوري كل ساعة بالصلاة والسلام على رسول الله ﷺ',
        defaultColor: const Color(0xFF1E3A34),
        ledColor: const Color(0xFFD4AF37),
        icon: defaultNotificationIcon,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: includeCustomRawSounds,
        criticalAlerts: true,
        soundSource: includeCustomRawSounds
            ? (Platform.isAndroid
                  ? 'resource://raw/salli_ala_muhammad'
                  : (Platform.isIOS ? 'salli_ala_muhammad.aiff' : null))
            : null,
        enableVibration: false,
        vibrationPattern: Int64List.fromList([0]),
        onlyAlertOnce: false,
      ),
    ];
  }

  /// Check and request notification permissions automatically (no vibration permission requested)
  static Future<bool> requestPermission() async {
    if (!isSupportedPlatform) return false;
    try {
      final bool isAllowed = await AwesomeNotifications()
          .isNotificationAllowed();
      if (!isAllowed) {
        final bool userChoice = await AwesomeNotifications()
            .requestPermissionToSendNotifications(
              permissions: const [
                NotificationPermission.Alert,
                NotificationPermission.Sound,
                NotificationPermission.Badge,
                NotificationPermission.Light,
                NotificationPermission.FullScreenIntent,
                NotificationPermission.PreciseAlarms,
              ],
            );
        if (!userChoice) {
          log('User denied basic notification permissions.');
          return false;
        }
      }

      // Explicitly ensure exact alarm permission on Android 12+ (API 31+)
      if (Platform.isAndroid) {
        final allowedList = await AwesomeNotifications().checkPermissionList(
          permissions: const [NotificationPermission.PreciseAlarms],
        );
        if (!allowedList.contains(NotificationPermission.PreciseAlarms)) {
          log('PreciseAlarms permission not granted, requesting...');
          await AwesomeNotifications().requestPermissionToSendNotifications(
            permissions: const [NotificationPermission.PreciseAlarms],
          );
        }
      }

      return await AwesomeNotifications().isNotificationAllowed();
    } catch (e, st) {
      log('Error requesting notification permission: $e\n$st');
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

      _flipMethodChannel.setMethodCallHandler((call) async {
        if (call.method == 'onAzanStoppedByFlip') {
          final notifId = call.arguments?['notificationId'];
          log(
            'Azan notification $notifId was successfully stopped by flipping device face down.',
          );
          await _stopCustomAdhan();
        }
      });
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
    final id = receivedNotification.id;
    final type = receivedNotification.payload?['type'];
    if (type == 'salawat' ||
        type == 'salawat_test' ||
        id == salawatNotificationId ||
        id == salawatTestNotificationId ||
        id == (salawatTestNotificationId - 1)) {
      if (!_isNativeSalawatSoundAvailable) {
        await _playSalawatAudio();
      }
    } else if (type == 'pre_prayer') {
      if (!_isNativePrayerCloseSoundAvailable) {
        await _playPrePrayerAudio();
      }
    } else if ((id != null && id >= 100 && id <= 105) ||
        id == 999 ||
        id == 996 ||
        type == 'prayer') {
      await _startFlipDetector(id);
      final soundPath = receivedNotification.payload?['soundPath'];
      if (soundPath != null && soundPath.isNotEmpty) {
        await _playCustomAdhan(soundPath);
      }
    }
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    log('Notification dismissed: ${receivedAction.id}');
    await _stopCustomAdhan();
    await _stopFlipDetector();
  }

  /// Action listener: handles notification clicks and navigates via AnaOsalyApp.navigatorKey
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    log(
      'Notification action clicked: ${receivedAction.id}, payload: ${receivedAction.payload}',
    );

    await _stopCustomAdhan();
    await _stopFlipDetector();

    final payload = receivedAction.payload ?? {};
    final type = payload['type'];

    final navContext = HojatyApp.navigatorKey.currentContext;
    if (navContext == null) return;

    if (type == 'prayer' || type == 'pre_prayer') {
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
        return prayersChannelMakkahKey;
      default:
        return prayersChannelCustomKey;
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
    bool isPreReminderEnabled = true,
    int preReminderMinutes = 5,
    Map<String, int>? prayerPreReminderMinutes,
  }) async {
    if (!isSupportedPlatform) return;
    try {
      // Automatically ensure permissions are requested
      final isAllowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isAllowed) {
        final granted = await requestPermission();
        if (!granted) {
          log(
            'Notification permissions not granted, aborting prayer scheduling.',
          );
          return;
        }
      }

      await cancelPrayerNotifications();
      final now = DateTime.now();
      final coords = UserHiveHelper.getCachedCoordinates();
      final helper = PrayersHelper(coordinates: coords);
      final localTz = await AwesomeNotifications().getLocalTimeZoneIdentifier();

      final todayDate = DateTime(now.year, now.month, now.day);
      final tomorrowDate = todayDate.add(const Duration(days: 1));

      final todayTimes = helper.getPrayerDateTimes(todayDate);
      final tomorrowTimes = helper.getPrayerDateTimes(tomorrowDate);

      for (int i = 0; i < PrayerType.values.length; i++) {
        final type = PrayerType.values[i];

        try {
          // Determine if notification is enabled from the provided list or user preferences
          final prayerModel = prayers.where((p) => p.type == type).firstOrNull;
          final isEnabled =
              prayerModel?.isNotificationEnabled ??
              UserHiveHelper.getPrayerNotification(type.name);
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
          final channelKey = (localSoundPath != null)
              ? prayersChannelCustomKey
              : getPrayerChannelKey(prayerSoundId);
          final soundResource = getSoundResource(prayerSoundId);

          final content = NotificationContent(
            id: id,
            channelKey: channelKey,
            title: title,
            body: body,
            icon: defaultNotificationIcon,
            customSound: (isFullAdhan && Platform.isAndroid && isBuiltIn)
                ? soundResource
                : null,
            category: NotificationCategory.Reminder,
            wakeUpScreen: true,
            fullScreenIntent: true,
            payload: {
              'type': 'prayer',
              'prayer': type.name,
              'soundId': prayerSoundId,
              'soundPath': (isFullAdhan && localSoundPath != null)
                  ? localSoundPath
                  : '',
            },
          );

          final actionButtons = [
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
          ];

          // Attempt precise alarm first; fallback to standard alarm if OS restricts exact alarms
          try {
            await AwesomeNotifications().createNotification(
              content: content,
              actionButtons: actionButtons,
              schedule: NotificationCalendar(
                year: targetTime.year,
                month: targetTime.month,
                day: targetTime.day,
                hour: targetTime.hour,
                minute: targetTime.minute,
                second: targetTime.second,
                allowWhileIdle: true,
                timeZone: localTz,
              ),
            );
          } catch (preciseErr) {
            log(
              'Precise alarm failed for $prayerName, falling back to standard alarm: $preciseErr',
            );
            await AwesomeNotifications().createNotification(
              content: content,
              actionButtons: actionButtons,
              schedule: NotificationCalendar(
                year: targetTime.year,
                month: targetTime.month,
                day: targetTime.day,
                hour: targetTime.hour,
                minute: targetTime.minute,
                second: targetTime.second,
                allowWhileIdle: true,
                preciseAlarm: false,
                timeZone: localTz,
              ),
            );
          }

          log(
            'Scheduled prayer notification for $prayerName at $targetTime (TZ: $localTz) with ID $id and sound $soundResource',
          );

          // Schedule Pre-Prayer Reminder (e.g. 5 minutes before)
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

              final preContent = NotificationContent(
                id: preId,
                channelKey: prePrayerChannelKey,
                title: preTitle,
                body: preBody,
                icon: defaultNotificationIcon,
                category: NotificationCategory.Reminder,
                wakeUpScreen: true,
                customSound: _isNativePrayerCloseSoundAvailable
                    ? 'resource://raw/prayer_time_is_close'
                    : null,
                payload: {
                  'type': 'pre_prayer',
                  'prayer': type.name,
                  'minutes': specificPreMinutes.toString(),
                },
              );

              final preActionButtons = [
                NotificationActionButton(
                  key: 'OPEN_APP',
                  label: language == 'ar' ? 'فتح التطبيق' : 'Open App',
                ),
                NotificationActionButton(
                  key: 'DISMISS',
                  label: language == 'ar' ? 'حسناً' : 'OK',
                  actionType: ActionType.DismissAction,
                ),
              ];

              try {
                await AwesomeNotifications().createNotification(
                  content: preContent,
                  actionButtons: preActionButtons,
                  schedule: NotificationCalendar(
                    year: preTime.year,
                    month: preTime.month,
                    day: preTime.day,
                    hour: preTime.hour,
                    minute: preTime.minute,
                    second: preTime.second,
                    allowWhileIdle: true,
                    timeZone: localTz,
                  ),
                );
              } catch (_) {
                await AwesomeNotifications().createNotification(
                  content: preContent,
                  actionButtons: preActionButtons,
                  schedule: NotificationCalendar(
                    year: preTime.year,
                    month: preTime.month,
                    day: preTime.day,
                    hour: preTime.hour,
                    minute: preTime.minute,
                    second: preTime.second,
                    allowWhileIdle: true,
                    preciseAlarm: false,
                    timeZone: localTz,
                  ),
                );
              }

              log(
                'Scheduled pre-prayer notification for $prayerName at $preTime with ID $preId',
              );
            }
          }
        } catch (itemErr, itemSt) {
          log(
            'Error scheduling single prayer notification for $type: $itemErr\n$itemSt',
          );
        }
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
      final isAllowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isAllowed) {
        final granted = await requestPermission();
        if (!granted) {
          log(
            'Notification permissions not granted, aborting occasion scheduling.',
          );
          return;
        }
      }

      await cancelOccasionNotifications();
      final now = DateTime.now();

      for (int i = 0; i < occasions.length; i++) {
        try {
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

            final content = NotificationContent(
              id: id * 10 + 1,
              channelKey: occasionsChannelKey,
              title: title,
              body: body,
              icon: defaultNotificationIcon,
              category: NotificationCategory.Reminder,
              payload: {'type': 'occasion', 'occasionTitle': occasion.title},
            );

            try {
              await AwesomeNotifications().createNotification(
                content: content,
                schedule: NotificationCalendar.fromDate(
                  date: dayBeforeTime,
                  allowWhileIdle: true,
                  preciseAlarm: true,
                ),
              );
            } catch (_) {
              await AwesomeNotifications().createNotification(
                content: content,
                schedule: NotificationCalendar.fromDate(
                  date: dayBeforeTime,
                  allowWhileIdle: true,
                ),
              );
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

            final content = NotificationContent(
              id: id * 10 + 2,
              channelKey: occasionsChannelKey,
              title: title,
              body: body,
              icon: defaultNotificationIcon,
              category: NotificationCategory.Event,
              payload: {'type': 'occasion', 'occasionTitle': occasion.title},
            );

            try {
              await AwesomeNotifications().createNotification(
                content: content,
                schedule: NotificationCalendar.fromDate(
                  date: morningTime,
                  allowWhileIdle: true,
                  preciseAlarm: true,
                ),
              );
            } catch (_) {
              await AwesomeNotifications().createNotification(
                content: content,
                schedule: NotificationCalendar.fromDate(
                  date: morningTime,
                  allowWhileIdle: true,
                ),
              );
            }
          }
        } catch (itemErr, itemSt) {
          log('Error scheduling single occasion: $itemErr\n$itemSt');
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
      final isAllowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isAllowed) {
        final granted = await requestPermission();
        if (!granted) return;
      }

      final title = language == 'ar'
          ? 'اختبار تنبيه الصلاة والأذان'
          : 'Prayer & Adhan Notification Test';
      final body = language == 'ar'
          ? 'حان الآن وقت صلاة الظهر - حي على الصلاة'
          : 'It is now time for Dhuhr prayer - Come to prayer';

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

      final channelKey = (localSoundPath != null)
          ? prayersChannelCustomKey
          : getPrayerChannelKey(effectiveSoundId);
      final soundResource = getSoundResource(effectiveSoundId);

      await AwesomeNotifications().cancel(999);
      await AwesomeNotifications().cancel(996);
      _adhanTestToggle = (_adhanTestToggle == 0) ? 1 : 0;
      final int activeId = (_adhanTestToggle == 0) ? 999 : 996;

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: activeId,
          channelKey: channelKey,
          title: title,
          body: body,
          icon: defaultNotificationIcon,
          customSound: (isFullAdhan && Platform.isAndroid && isBuiltIn)
              ? soundResource
              : null,
          category: NotificationCategory.Reminder,
          wakeUpScreen: true,
          payload: {
            'type': 'prayer',
            'prayer': 'dhuhr',
            'soundId': effectiveSoundId,
            'soundPath': (isFullAdhan && localSoundPath != null)
                ? localSoundPath
                : '',
          },
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
        'Instant test notification sent successfully with sound: $effectiveSoundId',
      );
    } catch (e, st) {
      log('Error sending test notification: $e\n$st');
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
      final isAllowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isAllowed) {
        final granted = await requestPermission();
        if (!granted) return;
      }

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

      await AwesomeNotifications().cancel(998);
      await AwesomeNotifications().cancel(995);
      _preAdhanTestToggle = (_preAdhanTestToggle == 0) ? 1 : 0;
      final int activeId = (_preAdhanTestToggle == 0) ? 998 : 995;

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: activeId,
          channelKey: prePrayerChannelKey,
          title: title,
          body: body,
          icon: defaultNotificationIcon,
          category: NotificationCategory.Reminder,
          wakeUpScreen: true,
          customSound: _isNativePrayerCloseSoundAvailable
              ? 'resource://raw/prayer_time_is_close'
              : null,
          payload: {'type': 'pre_prayer', 'prayer': prayerType.name},
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'OPEN_APP',
            label: language == 'ar' ? 'فتح التطبيق' : 'Open App',
          ),
          NotificationActionButton(
            key: 'DISMISS',
            label: language == 'ar' ? 'حسناً' : 'OK',
            actionType: ActionType.DismissAction,
          ),
        ],
      );
      log('Test pre-adhan notification sent successfully');
    } catch (e, st) {
      log('Error sending test pre-adhan notification: $e\n$st');
    }
  }

  /// Schedules an hourly recurring notification for Salawat on the Prophet ﷺ
  static Future<void> scheduleSalawatNotification({
    required String language,
    bool enabled = true,
  }) async {
    if (!isSupportedPlatform) return;
    try {
      await cancelSalawatNotification();
      if (!enabled) return;

      final title = language == 'ar'
          ? 'الصلاة على النبي ﷺ'
          : 'Blessings upon the Prophet ﷺ';
      final body = language == 'ar'
          ? 'اللهم صلِّ وسلِّم وبارك على سيدنا محمد وعلى آله وصحبه أجمعين'
          : 'O Allah, bestow peace and blessings upon our Master Muhammad';

      final content = NotificationContent(
        id: salawatNotificationId,
        channelKey: salawatChannelKey,
        title: title,
        body: body,
        icon: defaultNotificationIcon,
        category: NotificationCategory.Reminder,
        wakeUpScreen: true,
        customSound: _isNativeSalawatSoundAvailable
            ? (Platform.isAndroid
                  ? 'resource://raw/salli_ala_muhammad'
                  : (Platform.isIOS ? 'salli_ala_muhammad.aiff' : null))
            : null,
        payload: {'type': 'salawat'},
      );

      final actionButtons = [
        NotificationActionButton(
          key: 'OPEN_APP',
          label: language == 'ar' ? 'فتح التطبيق' : 'Open App',
        ),
        NotificationActionButton(
          key: 'DISMISS',
          label: language == 'ar' ? 'حسناً' : 'OK',
          actionType: ActionType.DismissAction,
        ),
      ];

      try {
        await AwesomeNotifications().createNotification(
          content: content,
          actionButtons: actionButtons,
          schedule: NotificationInterval(
            interval: const Duration(hours: 1),
            repeats: true,
            allowWhileIdle: true,
          ),
        );
      } catch (preciseErr) {
        log(
          'Precise alarm failed for salawat reminder, falling back: $preciseErr',
        );
        await AwesomeNotifications().createNotification(
          content: content,
          actionButtons: actionButtons,
          schedule: NotificationInterval(
            interval: const Duration(hours: 1),
            repeats: true,
            allowWhileIdle: true,
            preciseAlarm: false,
          ),
        );
      }
      log('Salawat hourly notification scheduled successfully.');
    } catch (e, st) {
      log('Error scheduling salawat notification: $e\n$st');
    }
  }

  /// Cancels the hourly Salawat notification
  static Future<void> cancelSalawatNotification() async {
    if (!isSupportedPlatform) return;
    await _stopCustomAdhan();
    try {
      await AwesomeNotifications().cancel(salawatNotificationId);
      await AwesomeNotifications().cancelSchedule(salawatNotificationId);
      log('Salawat notification cancelled.');
    } catch (e) {
      log('Error cancelling salawat notification: $e');
    }
  }

  /// Shows an immediate test notification with the Salawat audio
  static Future<void> showTestSalawatNotification({
    required String language,
  }) async {
    if (!isSupportedPlatform) return;
    try {
      final isAllowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isAllowed) {
        final granted = await requestPermission();
        if (!granted) return;
      }

      // 1. Cancel previous test notification IDs from the bar first
      await AwesomeNotifications().cancel(salawatTestNotificationId);
      await AwesomeNotifications().cancel(salawatTestNotificationId - 1);

      // 2. Toggle active ID between 776 and 775 to guarantee Android always treats each tap
      // as a brand-new notification and triggers the heads-up banner & sound immediately
      _salawatTestToggle = (_salawatTestToggle == 0) ? 1 : 0;
      final int activeTestId = salawatTestNotificationId - _salawatTestToggle;

      final title = language == 'ar'
          ? 'الصلاة على النبي ﷺ'
          : 'Blessings upon the Prophet ﷺ';
      final body = language == 'ar'
          ? 'اللهم صلِّ وسلِّم وبارك على سيدنا محمد وعلى آله وصحبه أجمعين'
          : 'O Allah, bestow peace and blessings upon our Master Muhammad';

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: activeTestId,
          channelKey: salawatChannelKey,
          title: title,
          body: body,
          icon: defaultNotificationIcon,
          category: NotificationCategory.Reminder,
          wakeUpScreen: true,
          customSound: _isNativeSalawatSoundAvailable
              ? (Platform.isAndroid
                    ? 'resource://raw/salli_ala_muhammad'
                    : (Platform.isIOS ? 'salli_ala_muhammad.aiff' : null))
              : null,
          payload: {'type': 'salawat_test'},
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'OPEN_APP',
            label: language == 'ar' ? 'فتح التطبيق' : 'Open App',
          ),
          NotificationActionButton(
            key: 'DISMISS',
            label: language == 'ar' ? 'حسناً' : 'OK',
            actionType: ActionType.DismissAction,
          ),
        ],
      );
      log('Test salawat notification sent successfully with ID $activeTestId.');
    } catch (e, st) {
      log('Error sending test salawat notification: $e\n$st');
    }
  }

  /// Cancels all prayer notifications (IDs 100 to 199)
  static Future<void> cancelPrayerNotifications() async {
    if (!isSupportedPlatform) return;
    await _stopCustomAdhan();
    await _stopFlipDetector();
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
    await _stopCustomAdhan();
    await _stopFlipDetector();
    try {
      await AwesomeNotifications().cancelAll();
    } catch (_) {}
  }
}
