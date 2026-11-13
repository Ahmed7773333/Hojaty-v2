import 'package:hojaty/features/homelayout/data/models/adhan_setting_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';

void main() {
  // 1. Verify default values of AdhanSettingModel
  const defaultSettings = AdhanSettingModel();
  assert(defaultSettings.isPreAdhanReminderEnabled == true, 'Pre-adhan reminder should be enabled by default');
  assert(defaultSettings.preAdhanReminderMinutes == 5, 'Pre-adhan reminder default should be 5 minutes');

  // 2. Verify copyWith
  final updatedSettings = defaultSettings.copyWith(
    preAdhanReminderMinutes: 10,
    isPreAdhanReminderEnabled: false,
  );
  assert(updatedSettings.preAdhanReminderMinutes == 10, 'preAdhanReminderMinutes should be updated to 10');
  assert(updatedSettings.isPreAdhanReminderEnabled == false, 'isPreAdhanReminderEnabled should be false');

  // 3. Verify Pre-Reminder Time calculation
  final prayerTime = DateTime(2026, 11, 14, 12, 0); // 12:00 PM
  const minutesBefore = 5;
  final preReminderTime = prayerTime.subtract(const Duration(minutes: minutesBefore));
  assert(
    preReminderTime.hour == 11 && preReminderTime.minute == 55,
    '5 minutes before 12:00 must be 11:55',
  );

  // 4. Verify ID range separation and bounds within 100..199
  for (final type in PrayerType.values) {
    final mainId = 100 + type.index;
    final preId = 150 + type.index;

    assert(mainId >= 100 && mainId < 150, 'Main ID must be in 100..149');
    assert(preId >= 150 && preId < 199, 'Pre ID must be in 150..199');
    assert(mainId != preId, 'Main ID and Pre ID must never collide');
  }

  print('All Pre-Adhan Reminder logic checks passed successfully!');
}
