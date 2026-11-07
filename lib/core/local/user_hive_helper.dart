import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/local_notification_service.dart';
import 'user_data.dart';

class UserHiveHelper {
  // Box names
  static const String _userBoxName = 'userBox';
  static const String _userId = 'currentUser';

  static Future<void> initNotifications() async {
    await LocalNotificationService.init();
  }

  // Initialize Hive and register adapters
  static Future<void> init() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    } catch (e, st) {
      log('Error initializing Hive: $e\n$st');
    }

    try {
      Hive.registerAdapter(UserDataAdapter());
    } catch (e, st) {
      log('Error registering Hive adapters: $e\n$st');
    }

    try {
      await Hive.openBox<UserData>(_userBoxName);
      await Hive.openBox('occasionsBox');
      await Hive.openBox('prayersBox');
    } catch (e, st) {
      log('Error opening Hive box: $e\n$st');
    }

    try {
      if (UserHiveHelper.getUser() == null) {
        UserHiveHelper.saveUser(
          UserData(
            id: null,
            name: null,
            firstName: null,
            secondName: null,
            email: null,
            phone: null,
            createdAt: DateTime.now().toIso8601String(),
            language: 'ar',
            role: null,
            token: null,
            onBoardingCompleted: false,
          ),
        );
      }
    } catch (e, st) {
      log('Error setting default user: $e\n$st');
    }
  }

  // --------------------- User CRUD Operations ---------------------

  /// Creates or updates a user
  static void saveUser(UserData user) {
    final box = Hive.box<UserData>(_userBoxName);
    box.put(_userId, user);
  }

  /// Gets a user by email
  static UserData? getUser() {
    final box = Hive.box<UserData>(_userBoxName);
    return box.get(_userId);
  }

  /// Gets all users
  static List<UserData> getAllUsers() {
    final box = Hive.box<UserData>(_userBoxName);
    return box.values.toList();
  }

  /// Updates specific fields of a user
  static void updateUser(UserData user) {
    final box = Hive.box<UserData>(_userBoxName);
    box.put(_userId, user);
  }

  /// Deletes a user by email
  static void deleteUser() {
    final box = Hive.box<UserData>(_userBoxName);
    box.delete(_userId);
  }

  /// Clears all users
  static void clearAllUsers() {
    final box = Hive.box<UserData>(_userBoxName);
    box.clear();
  }

  // --------------------- Helper Methods ---------------------

  /// Closes all boxes
  static void closeBoxes() {
    Hive.close();
  }

  /// Deletes all boxes (for testing/logout)
  static void deleteAllBoxes() {
    Hive.deleteBoxFromDisk(_userBoxName);
  }

  /// Get listenable box for UI bindings
  static ValueListenable<Box<UserData>> getBoxListenable() {
    return Hive.box<UserData>(_userBoxName).listenable();
  }

  // --------------------- Prayers Box Helpers ---------------------

  static Box get prayersBox => Hive.box('prayersBox');

  static bool getPrayerNotification(
    String prayerName, {
    bool defaultValue = true,
  }) {
    try {
      final box = prayersBox;
      return box.get('notif_$prayerName', defaultValue: defaultValue) as bool;
    } catch (_) {
      return defaultValue;
    }
  }

  static void setPrayerNotification(String prayerName, bool enabled) {
    try {
      prayersBox.put('notif_$prayerName', enabled);
    } catch (_) {}
  }

  static Map<String, String>? getPrayerWindow(String prayerName) {
    try {
      final data = prayersBox.get('window_$prayerName');
      if (data != null && data is Map) {
        return Map<String, String>.from(data);
      }
    } catch (_) {}
    return null;
  }

  static void setPrayerWindow(String prayerName, {String? start, String? end}) {
    try {
      final current = getPrayerWindow(prayerName) ?? {};
      if (start != null) current['start'] = start;
      if (end != null) current['end'] = end;
      prayersBox.put('window_$prayerName', current);
    } catch (_) {}
  }

  static bool getPrayerAlertsEnabled({bool defaultValue = true}) {
    try {
      return prayersBox.get('prayer_alerts_enabled', defaultValue: defaultValue)
          as bool;
    } catch (_) {
      return defaultValue;
    }
  }

  static void setPrayerAlertsEnabled(bool enabled) {
    try {
      prayersBox.put('prayer_alerts_enabled', enabled);
    } catch (_) {}
  }

  static bool getAnaOsalyEnabled({bool defaultValue = true}) {
    try {
      return prayersBox.get('hojaty_enabled', defaultValue: defaultValue)
          as bool;
    } catch (_) {
      return defaultValue;
    }
  }

  static void setAnaOsalyEnabled(bool enabled) {
    try {
      prayersBox.put('hojaty_enabled', enabled);
    } catch (_) {}
  }

  static String getAnaOsalyLanguage({String defaultValue = 'ar'}) {
    try {
      return prayersBox.get('hojaty_language', defaultValue: defaultValue)
          as String;
    } catch (_) {
      return defaultValue;
    }
  }

  static void setAnaOsalyLanguage(String language) {
    try {
      prayersBox.put('hojaty_language', language);
    } catch (_) {}
  }

  static String getAnaOsalyCustomMessageAr({String defaultValue = 'حچتي'}) {
    try {
      final val = prayersBox.get('hojaty_msg_ar') as String?;
      if (val != null && val.trim().isNotEmpty) return val;
    } catch (_) {}
    return defaultValue;
  }

  static void setAnaOsalyCustomMessageAr(String message) {
    try {
      prayersBox.put('hojaty_msg_ar', message);
    } catch (_) {}
  }

  static String getAnaOsalyCustomMessageEn({
    String defaultValue = 'I am praying',
  }) {
    try {
      final val = prayersBox.get('hojaty_msg_en') as String?;
      if (val != null && val.trim().isNotEmpty) return val;
    } catch (_) {}
    return defaultValue;
  }

  static void setAnaOsalyCustomMessageEn(String message) {
    try {
      prayersBox.put('hojaty_msg_en', message);
    } catch (_) {}
  }

  static String getAnaOsalyActiveMessage(String language) {
    if (language == 'en') {
      return getAnaOsalyCustomMessageEn();
    }
    return getAnaOsalyCustomMessageAr();
  }

  static bool getOccasionsNotificationsEnabled({bool defaultValue = true}) {
    try {
      return prayersBox.get(
            'occasions_notif_enabled',
            defaultValue: defaultValue,
          )
          as bool;
    } catch (_) {
      return defaultValue;
    }
  }

  static void setOccasionsNotificationsEnabled(bool enabled) {
    try {
      prayersBox.put('occasions_notif_enabled', enabled);
    } catch (_) {}
  }

  static bool getGeneralNotificationsEnabled({bool defaultValue = true}) {
    try {
      return prayersBox.get('general_notif_enabled', defaultValue: defaultValue)
          as bool;
    } catch (_) {
      return defaultValue;
    }
  }

  static void setGeneralNotificationsEnabled(bool enabled) {
    try {
      prayersBox.put('general_notif_enabled', enabled);
    } catch (_) {}
  }

  static bool getAthkarNotificationsEnabled({bool defaultValue = true}) {
    try {
      return prayersBox.get('athkar_notif_enabled', defaultValue: defaultValue)
          as bool;
    } catch (_) {
      return defaultValue;
    }
  }

  static void setAthkarNotificationsEnabled(bool enabled) {
    try {
      prayersBox.put('athkar_notif_enabled', enabled);
    } catch (_) {}
  }

  static String getSelectedAdhanSound({String defaultValue = 'makkah'}) {
    try {
      return prayersBox.get('selected_adhan_sound', defaultValue: defaultValue)
          as String;
    } catch (_) {
      return defaultValue;
    }
  }

  static void setSelectedAdhanSound(String soundId) {
    try {
      prayersBox.put('selected_adhan_sound', soundId);
    } catch (_) {}
  }

  // --------------------- Cached Location ---------------------
  static String getCachedPrayerCityName({String defaultValue = ''}) {
    try {
      return prayersBox.get('cached_prayer_city_name', defaultValue: defaultValue) as String? ?? defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }

  static void setCachedPrayerCityName(String cityName) {
    try {
      prayersBox.put('cached_prayer_city_name', cityName);
    } catch (_) {}
  }

  // --------------------- Free Sebha Counter ---------------------
  static int getSebhaCounter({int defaultValue = 0}) {
    try {
      return prayersBox.get('free_sebha_counter', defaultValue: defaultValue)
              as int? ??
          defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }

  static void setSebhaCounter(int count) {
    try {
      prayersBox.put('free_sebha_counter', count);
    } catch (_) {}
  }
}
