import 'package:equatable/equatable.dart';
import '../../data/models/adhan_setting_model.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/notification_item_model.dart';
import '../../data/models/occasion_item_model.dart';
import '../../data/models/prayer_time_model.dart';
import '../../data/models/ramadan_check_response_model.dart';

enum HomelayoutStatus { initial, loading, success, failure }

class HomelayoutState extends Equatable {
  final HomelayoutStatus status;
  final int currentTabIndex;
  final List<PrayerTimeModel> prayerTimes;
  final int selectedPrayerDayOffset;
  final DateTime? selectedPrayerDate;
  final DateTime? nextPrayerTime;
  final PrayerType? nextPrayerType;
  final String nextPrayerName;
  final DateTime? previousPrayerTime;
  final double prayerProgress;
  final String prayerCityName;
  final AdhanSettingModel adhanSettings;
  final List<NotificationItemModel> notifications;
  final List<BannerModel> banners;
  final RamadanCheckData? ramadanCheckData;
  final List<OccasionItemModel> occasionsList;
  final OccasionItemModel? nextOccasion;
  final String currentLanguage;
  final int activeHijriMonth;
  final int activeHijriYear;
  final int activeGregorianMonth;
  final int activeGregorianYear;
  final String? errorMessage;

  const HomelayoutState({
    this.status = HomelayoutStatus.initial,
    this.currentTabIndex = 0,
    this.prayerTimes = const [],
    this.selectedPrayerDayOffset = 0,
    this.selectedPrayerDate,
    this.nextPrayerTime,
    this.nextPrayerType,
    this.nextPrayerName = '',
    this.previousPrayerTime,
    this.prayerProgress = 0.0,
    this.prayerCityName = '',
    this.adhanSettings = const AdhanSettingModel(),
    this.notifications = const [],
    this.banners = const [],
    this.ramadanCheckData,
    this.occasionsList = const [],
    this.nextOccasion,
    this.currentLanguage = 'ar',
    this.activeHijriMonth = 3,
    this.activeHijriYear = 1448,
    this.activeGregorianMonth = 8,
    this.activeGregorianYear = 2026,
    this.errorMessage,
  });

  HomelayoutState copyWith({
    HomelayoutStatus? status,
    int? currentTabIndex,
    List<PrayerTimeModel>? prayerTimes,
    int? selectedPrayerDayOffset,
    DateTime? selectedPrayerDate,
    DateTime? nextPrayerTime,
    PrayerType? nextPrayerType,
    String? nextPrayerName,
    DateTime? previousPrayerTime,
    double? prayerProgress,
    String? prayerCityName,
    AdhanSettingModel? adhanSettings,
    List<NotificationItemModel>? notifications,
    List<BannerModel>? banners,
    RamadanCheckData? ramadanCheckData,
    List<OccasionItemModel>? occasionsList,
    OccasionItemModel? nextOccasion,
    String? currentLanguage,
    int? activeHijriMonth,
    int? activeHijriYear,
    int? activeGregorianMonth,
    int? activeGregorianYear,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomelayoutState(
      status: status ?? this.status,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      selectedPrayerDayOffset:
          selectedPrayerDayOffset ?? this.selectedPrayerDayOffset,
      selectedPrayerDate: selectedPrayerDate ?? this.selectedPrayerDate,
      nextPrayerTime: nextPrayerTime ?? this.nextPrayerTime,
      nextPrayerType: nextPrayerType ?? this.nextPrayerType,
      nextPrayerName: nextPrayerName ?? this.nextPrayerName,
      previousPrayerTime: previousPrayerTime ?? this.previousPrayerTime,
      prayerProgress: prayerProgress ?? this.prayerProgress,
      prayerCityName: prayerCityName ?? this.prayerCityName,
      adhanSettings: adhanSettings ?? this.adhanSettings,
      notifications: notifications ?? this.notifications,
      banners: banners ?? this.banners,
      ramadanCheckData: ramadanCheckData ?? this.ramadanCheckData,
      occasionsList: occasionsList ?? this.occasionsList,
      nextOccasion: nextOccasion ?? this.nextOccasion,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      activeHijriMonth: activeHijriMonth ?? this.activeHijriMonth,
      activeHijriYear: activeHijriYear ?? this.activeHijriYear,
      activeGregorianMonth: activeGregorianMonth ?? this.activeGregorianMonth,
      activeGregorianYear: activeGregorianYear ?? this.activeGregorianYear,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentTabIndex,
        prayerTimes,
        selectedPrayerDayOffset,
        selectedPrayerDate,
        nextPrayerTime,
        nextPrayerType,
        nextPrayerName,
        previousPrayerTime,
        prayerProgress,
        prayerCityName,
        adhanSettings,
        notifications,
        banners,
        ramadanCheckData,
        occasionsList,
        nextOccasion,
        currentLanguage,
        activeHijriMonth,
        activeHijriYear,
        activeGregorianMonth,
        activeGregorianYear,
        errorMessage,
      ];
}


// =========================================================================
// ARCHIVED PREVIOUS HOMELAYOUT STATE
// =========================================================================
// class HomelayoutState extends Equatable {
//   final HomelayoutStatus status;
//   final int currentTabIndex;
//   final List<PrayerTimeModel> prayerTimes;
//   final AdhanSettingModel adhanSettings;
//   final List<NotificationItemModel> notifications;
//   final String? errorMessage;
//
//   const HomelayoutState({
//     this.status = HomelayoutStatus.initial,
//     this.currentTabIndex = 0,
//     this.prayerTimes = const [],
//     this.adhanSettings = const AdhanSettingModel(),
//     this.notifications = const [],
//     this.errorMessage,
//   });
//
//   HomelayoutState copyWith({
//     HomelayoutStatus? status,
//     int? currentTabIndex,
//     List<PrayerTimeModel>? prayerTimes,
//     AdhanSettingModel? adhanSettings,
//     List<NotificationItemModel>? notifications,
//     String? errorMessage,
//     bool clearError = false,
//   }) {
//     return HomelayoutState(
//       status: status ?? this.status,
//       currentTabIndex: currentTabIndex ?? this.currentTabIndex,
//       prayerTimes: prayerTimes ?? this.prayerTimes,
//       adhanSettings: adhanSettings ?? this.adhanSettings,
//       notifications: notifications ?? this.notifications,
//       errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//         status,
//         currentTabIndex,
//         prayerTimes,
//         adhanSettings,
//         notifications,
//         errorMessage,
//       ];
// }
