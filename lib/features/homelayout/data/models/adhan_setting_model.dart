import 'package:equatable/equatable.dart';

class AdhanSettingModel extends Equatable {
  final bool isFullAdhan;
  final bool isAllPrayersEnabled;
  final bool isAnaOsalyEnabled;
  final String anaOsalyLanguage;
  final String selectedSoundId;
  final String customMessageAr;
  final String customMessageEn;

  const AdhanSettingModel({
    this.isFullAdhan = true,
    this.isAllPrayersEnabled = true,
    this.isAnaOsalyEnabled = true,
    this.anaOsalyLanguage = 'ar',
    this.selectedSoundId = 'makkah',
    this.customMessageAr = 'حچتي',
    this.customMessageEn = 'I am praying',
  });

  String get activeMessage =>
      anaOsalyLanguage == 'en' ? customMessageEn : customMessageAr;

  AdhanSettingModel copyWith({
    bool? isFullAdhan,
    bool? isAllPrayersEnabled,
    bool? isAnaOsalyEnabled,
    String? anaOsalyLanguage,
    String? selectedSoundId,
    String? customMessageAr,
    String? customMessageEn,
  }) {
    return AdhanSettingModel(
      isFullAdhan: isFullAdhan ?? this.isFullAdhan,
      isAllPrayersEnabled: isAllPrayersEnabled ?? this.isAllPrayersEnabled,
      isAnaOsalyEnabled: isAnaOsalyEnabled ?? this.isAnaOsalyEnabled,
      anaOsalyLanguage: anaOsalyLanguage ?? this.anaOsalyLanguage,
      selectedSoundId: selectedSoundId ?? this.selectedSoundId,
      customMessageAr: customMessageAr ?? this.customMessageAr,
      customMessageEn: customMessageEn ?? this.customMessageEn,
    );
  }

  @override
  List<Object?> get props => [
    isFullAdhan,
    isAllPrayersEnabled,
    isAnaOsalyEnabled,
    anaOsalyLanguage,
    selectedSoundId,
    customMessageAr,
    customMessageEn,
  ];
}
