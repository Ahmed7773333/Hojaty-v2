import 'package:equatable/equatable.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayers_helper.dart';

class AdhanSettingModel extends Equatable {
  final bool isFullAdhan;
  final bool isAllPrayersEnabled;
  final bool isAnaOsalyEnabled;
  final String anaOsalyLanguage;
  final String selectedSoundId;
  final Map<String, String> prayerSoundIds;
  final String customMessageAr;
  final String customMessageEn;
  final bool isPreAdhanReminderEnabled;
  final int preAdhanReminderMinutes;
  final Map<String, int> prayerPreAdhanReminderMinutes;
  final bool isSalawatReminderEnabled;
  final AsrMadhab asrMadhab;
  final Map<String, int> prayerTimeOffsets;

  const AdhanSettingModel({
    this.isFullAdhan = true,
    this.isAllPrayersEnabled = true,
    this.isAnaOsalyEnabled = true,
    this.anaOsalyLanguage = 'ar',
    this.selectedSoundId = 'makkah',
    this.prayerSoundIds = const {},
    this.customMessageAr = 'حچتي',
    this.customMessageEn = 'I am praying',
    this.isPreAdhanReminderEnabled = true,
    this.preAdhanReminderMinutes = 5,
    this.prayerPreAdhanReminderMinutes = const {},
    this.isSalawatReminderEnabled = true,
    this.asrMadhab = AsrMadhab.shafi,
    this.prayerTimeOffsets = const {},
  });

  String get activeMessage =>
      anaOsalyLanguage == 'en' ? customMessageEn : customMessageAr;

  String getSoundForPrayer(PrayerType type) {
    return prayerSoundIds[type.name] ?? selectedSoundId;
  }

  int getPreAdhanReminderMinutesForPrayer(PrayerType type) {
    return prayerPreAdhanReminderMinutes[type.name] ?? preAdhanReminderMinutes;
  }

  int getTimeOffsetForPrayer(PrayerType type) {
    return prayerTimeOffsets[type.name] ?? 0;
  }

  AdhanSettingModel copyWith({
    bool? isFullAdhan,
    bool? isAllPrayersEnabled,
    bool? isAnaOsalyEnabled,
    String? anaOsalyLanguage,
    String? selectedSoundId,
    Map<String, String>? prayerSoundIds,
    String? customMessageAr,
    String? customMessageEn,
    bool? isPreAdhanReminderEnabled,
    int? preAdhanReminderMinutes,
    Map<String, int>? prayerPreAdhanReminderMinutes,
    bool? isSalawatReminderEnabled,
    AsrMadhab? asrMadhab,
    Map<String, int>? prayerTimeOffsets,
  }) {
    return AdhanSettingModel(
      isFullAdhan: isFullAdhan ?? this.isFullAdhan,
      isAllPrayersEnabled: isAllPrayersEnabled ?? this.isAllPrayersEnabled,
      isAnaOsalyEnabled: isAnaOsalyEnabled ?? this.isAnaOsalyEnabled,
      anaOsalyLanguage: anaOsalyLanguage ?? this.anaOsalyLanguage,
      selectedSoundId: selectedSoundId ?? this.selectedSoundId,
      prayerSoundIds: prayerSoundIds ?? this.prayerSoundIds,
      customMessageAr: customMessageAr ?? this.customMessageAr,
      customMessageEn: customMessageEn ?? this.customMessageEn,
      isPreAdhanReminderEnabled:
          isPreAdhanReminderEnabled ?? this.isPreAdhanReminderEnabled,
      preAdhanReminderMinutes:
          preAdhanReminderMinutes ?? this.preAdhanReminderMinutes,
      prayerPreAdhanReminderMinutes:
          prayerPreAdhanReminderMinutes ?? this.prayerPreAdhanReminderMinutes,
      isSalawatReminderEnabled:
          isSalawatReminderEnabled ?? this.isSalawatReminderEnabled,
      asrMadhab: asrMadhab ?? this.asrMadhab,
      prayerTimeOffsets: prayerTimeOffsets ?? this.prayerTimeOffsets,
    );
  }

  @override
  List<Object?> get props => [
    isFullAdhan,
    isAllPrayersEnabled,
    isAnaOsalyEnabled,
    anaOsalyLanguage,
    selectedSoundId,
    prayerSoundIds,
    customMessageAr,
    customMessageEn,
    isPreAdhanReminderEnabled,
    preAdhanReminderMinutes,
    prayerPreAdhanReminderMinutes,
    isSalawatReminderEnabled,
    asrMadhab,
    prayerTimeOffsets,
  ];
}
