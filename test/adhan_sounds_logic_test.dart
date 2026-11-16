import 'package:hojaty/features/homelayout/data/models/adhan_setting_model.dart';
import 'package:hojaty/features/homelayout/data/models/azan_audio_item_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';

void main() {
  // 1. Verify cleanTitle
  final cleaned = AzanAudioItemModel.cleanTitle('01   أذان الحرم المكي   1&nbsp;');
  assert(cleaned == '01 أذان الحرم المكي 1', 'Title cleaning failed: $cleaned');

  // 2. Verify model parsing and formatting
  final model = AzanAudioItemModel.fromJson(const {
    'id': 'azan_01',
    'title': '01   أذان الحرم المكي   1&nbsp;',
    'file': '01 - أذان الحرم المكي - 1&nbsp;.mp3',
    'url': 'https://cdn.jsdelivr.net/gh/Ahmed7773333/azans@v1.0.0/Azan_MP3/test.mp3',
    'duration_sec': 204,
    'size_kb': 462,
  });

  assert(model.id == 'azan_01', 'id mismatch');
  assert(model.durationSec == 204, 'duration mismatch');
  assert(model.formattedDuration == '03:24', 'formattedDuration mismatch: ${model.formattedDuration}');
  assert(model.formattedSize == '462 KB', 'formattedSize mismatch: ${model.formattedSize}');

  // Test size formatting for MB
  final largeModel = model.copyWith(sizeKb: 2048);
  assert(largeModel.formattedSize == '2.0 MB', 'formattedSize MB mismatch: ${largeModel.formattedSize}');

  // 3. Verify AdhanSettingModel per-prayer sound assignment
  const settings = AdhanSettingModel(
    selectedSoundId: 'makkah',
    prayerSoundIds: {
      'fajr': 'azan_07',
      'maghrib': 'madinah',
    },
  );

  // Fajr has custom 'azan_07'
  assert(settings.getSoundForPrayer(PrayerType.fajr) == 'azan_07', 'Fajr sound mismatch');
  // Maghrib has custom 'madinah'
  assert(settings.getSoundForPrayer(PrayerType.maghrib) == 'madinah', 'Maghrib sound mismatch');
  // Dhuhr has no custom sound, falls back to default selectedSoundId ('makkah')
  assert(settings.getSoundForPrayer(PrayerType.dhuhr) == 'makkah', 'Dhuhr fallback mismatch');
  // Asr has no custom sound, falls back to default selectedSoundId ('makkah')
  assert(settings.getSoundForPrayer(PrayerType.asr) == 'makkah', 'Asr fallback mismatch');
  // Isha has no custom sound, falls back to default selectedSoundId ('makkah')
  assert(settings.getSoundForPrayer(PrayerType.isha) == 'makkah', 'Isha fallback mismatch');

  // 4. Verify copyWith updates prayerSoundIds
  final updated = settings.copyWith(
    prayerSoundIds: {
      ...settings.prayerSoundIds,
      'asr': 'azan_03',
    },
  );
  assert(updated.getSoundForPrayer(PrayerType.asr) == 'azan_03', 'Asr updated sound mismatch');
}

