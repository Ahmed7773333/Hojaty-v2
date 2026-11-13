import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/local/user_hive_helper.dart';
import '../../../../core/utils/local_notification_service.dart';
import '../../../../data/mocks/home_mock_data.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/hijri_calendar_helper.dart';
import '../../data/models/occasion_item_model.dart';
import '../../data/models/prayer_time_model.dart';
import '../../data/models/prayers_helper.dart';
import '../../data/models/ramadan_check_response_model.dart';
import '../../domain/usecases/get_banners_use_case.dart';
import '../../domain/usecases/get_homelayout.dart';
import '../../domain/usecases/occasions_use_cases.dart';
import 'homelayout_event.dart';
import 'homelayout_state.dart';

class HomelayoutBloc extends Bloc<HomelayoutEvent, HomelayoutState> {
  static Future<String> getPrayerCityName(String language, {Dio? dio}) async {
    final client = dio ?? Dio();
    final separator = language == 'ar' ? '، ' : ', ';

    // 1. Try BigDataCloud reverse geocode client (supports Arabic, English, and other languages natively)
    try {
      final response = await client.get(
        'https://api.bigdatacloud.net/data/reverse-geocode-client?localityLanguage=$language',
        options: Options(
          sendTimeout: const Duration(seconds: 4),
          receiveTimeout: const Duration(seconds: 4),
        ),
      );
      if (response.statusCode == 200 && response.data is Map) {
        final data = response.data as Map;
        final city = (data['city'] as String?)?.isNotEmpty == true
            ? data['city'] as String
            : (data['locality'] as String?)?.isNotEmpty == true
                ? data['locality'] as String
                : data['principalSubdivision'] as String?;
        final country = data['countryName'] as String?;
        if (city != null &&
            city.isNotEmpty &&
            country != null &&
            country.isNotEmpty) {
          final resolvedName = '$city$separator$country';
          log('BigDataCloud city name: $resolvedName');
          UserHiveHelper.setCachedPrayerCityName(resolvedName);
          return resolvedName;
        }
      }
    } catch (_) {}

    // 2. Fallback to ip-api
    try {
      final response = await client.get(
        'http://ip-api.com/json/?lang=$language',
        options: Options(
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );
      if (response.statusCode == 200 && response.data is Map) {
        final city = response.data['city'] as String?;
        final country = response.data['country'] as String?;
        if (city != null &&
            city.isNotEmpty &&
            country != null &&
            country.isNotEmpty) {
          final resolvedName = '$city$separator$country';
          log('ip-api city name: $resolvedName');
          UserHiveHelper.setCachedPrayerCityName(resolvedName);
          return resolvedName;
        }
      }
    } catch (_) {}

    return UserHiveHelper.getCachedPrayerCityName();
  }

  final GetHomelayoutUseCase? getHomelayout;
  final GetRamadanCheckUseCase? getRamadanCheck;
  final GetOccasionsListUseCase? getOccasionsList;
  final SyncOccasionsDataUseCase? syncOccasionsData;
  final GetBannersUseCase? getBanners;

  HomelayoutBloc({
    this.getHomelayout,
    this.getRamadanCheck,
    this.getOccasionsList,
    this.syncOccasionsData,
    this.getBanners,
  }) : super(
         HomelayoutState(
           status: HomelayoutStatus.success,
           prayerTimes: const [],
           notifications: HomeMockData.notifications,
           banners: HomeMockData.banners,
           adhanSettings: HomeMockData.defaultAdhanSettings,
           ramadanCheckData: RamadanCheckData.fallback(language: 'ar'),
           occasionsList: HijriCalendarHelper.calculateOccasions(
             RamadanCheckData.fallback(language: 'ar').hijriDate,
             language: 'ar',
           ),
           nextOccasion: HijriCalendarHelper.calculateOccasions(
             RamadanCheckData.fallback(language: 'ar').hijriDate,
             language: 'ar',
           ).firstOrNull,
           activeHijriMonth: 3,
           activeHijriYear: 1448,
           activeGregorianMonth: DateTime.now().month,
           activeGregorianYear: DateTime.now().year,
         ),
       ) {
    on<LoadHomelayoutEvent>(_onLoad);
    on<LoadOccasionsDataEvent>(_onLoadOccasions);
    on<SyncOccasionsDataEvent>(_onSyncOccasions);
    on<NavigateHijriMonthEvent>(_onNavigateHijriMonth);
    on<NavigateGregorianMonthEvent>(_onNavigateGregorianMonth);
    on<ResetHijriMonthToCurrentEvent>(_onResetHijriMonth);
    on<ResetGregorianMonthToCurrentEvent>(_onResetGregorianMonth);
    on<NavigatePrayerDayEvent>(_onNavigatePrayerDay);
    on<ResetPrayerDayToTodayEvent>(_onResetPrayerDayToToday);
    on<RefreshPrayerTimesEvent>(_onRefreshPrayerTimes);
    on<ChangeBottomNavTabEvent>(_onChangeTab);
    on<TogglePrayerNotificationEvent>(_onTogglePrayerNotification);
    on<ToggleAllPrayersNotificationEvent>(_onToggleAllPrayersNotification);
    on<ChangeAdhanTypeEvent>(_onChangeAdhanType);
    on<ToggleAnaOsalyEvent>(_onToggleAnaOsaly);
    on<ChangeAnaOsalyLanguageEvent>(_onChangeAnaOsalyLanguage);
    on<ChangeAnaOsalyCustomMessageEvent>(_onChangeAnaOsalyCustomMessage);
    on<DeleteNotificationEvent>(_onDeleteNotification);
    on<MarkAllNotificationsReadEvent>(_onMarkAllNotificationsRead);
    on<UpdatePrayerWindowTimeEvent>(_onUpdatePrayerWindowTime);
    on<SendTestNotificationEvent>(_onSendTestNotification);
    on<SendTestPreAdhanNotificationEvent>(_onSendTestPreAdhanNotification);
    on<TogglePreAdhanReminderEvent>(_onTogglePreAdhanReminder);
    on<ChangePreAdhanReminderMinutesEvent>(_onChangePreAdhanReminderMinutes);
    on<TogglePrayerAlertsEvent>(_onTogglePrayerAlerts);
    on<ToggleOccasionsNotificationsEvent>(_onToggleOccasionsNotifications);
    on<ToggleGeneralNotificationsEvent>(_onToggleGeneralNotifications);
    on<ToggleAthkarNotificationsEvent>(_onToggleAthkarNotifications);
    on<SelectAdhanSoundEvent>(_onSelectAdhanSound);
    on<UpdatePrayerCityNameEvent>(_onUpdatePrayerCityName);
  }

  // ---------------------------------------------------------------------------
  // Prayer Times Calculation Helper
  // ---------------------------------------------------------------------------

  ({
    List<PrayerTimeModel> prayerTimes,
    DateTime selectedDate,
    DateTime nextTime,
    PrayerType nextType,
    String nextName,
    DateTime previousTime,
    double progress,
  })
  _computePrayerState({required int dayOffset, required String language}) {
    const helper = PrayersHelper(coordinates: GeoCoordinates.cairo);
    final now = DateTime.now();
    final targetDate = now.add(Duration(days: dayOffset));

    final notifOverrides = <PrayerType, bool>{};
    final windowOverrides = <PrayerType, ({String? start, String? end})>{};

    for (final type in PrayerType.values) {
      notifOverrides[type] = UserHiveHelper.getPrayerNotification(
        type.name,
        defaultValue: true,
      );
      final win = UserHiveHelper.getPrayerWindow(type.name);
      if (win != null) {
        windowOverrides[type] = (start: win['start'], end: win['end']);
      }
    }

    final prayersList = helper.generatePrayerList(
      date: targetDate,
      now: now,
      notificationOverrides: notifOverrides,
      windowOverrides: windowOverrides,
    );

    final nextInfo = helper.getNextPrayerInfo(now);
    final nextName = PrayersHelper.getPrayerName(
      nextInfo.nextType,
      language: language,
    );
    final progress = PrayersHelper.calculatePrayerProgress(
      now: now,
      previousTime: nextInfo.previousTime,
      nextTime: nextInfo.nextTime,
    );

    return (
      prayerTimes: prayersList,
      selectedDate: targetDate,
      nextTime: nextInfo.nextTime,
      nextType: nextInfo.nextType,
      nextName: nextName,
      previousTime: nextInfo.previousTime,
      progress: progress,
    );
  }

  // ---------------------------------------------------------------------------
  // Event Handlers
  // ---------------------------------------------------------------------------

  FutureOr<void> _onLoad(
    LoadHomelayoutEvent event,
    Emitter<HomelayoutState> emit,
  ) async {
    final user = UserHiveHelper.getUser();
    final lang = user?.language ?? 'ar';

    // 1. Compute prayer times instantly and emit without waiting for network
    final prayerData = _computePrayerState(dayOffset: 0, language: lang);
    final initialCityName = UserHiveHelper.getCachedPrayerCityName();

    if (getRamadanCheck != null && getOccasionsList != null) {
      final ramadan = await getRamadanCheck!(language: lang);
      final occasions = await getOccasionsList!(language: lang);

      emit(
        state.copyWith(
          status: HomelayoutStatus.success,
          prayerTimes: prayerData.prayerTimes,
          selectedPrayerDayOffset: 0,
          selectedPrayerDate: prayerData.selectedDate,
          nextPrayerTime: prayerData.nextTime,
          nextPrayerType: prayerData.nextType,
          nextPrayerName: prayerData.nextName,
          prayerCityName: initialCityName,
          previousPrayerTime: prayerData.previousTime,
          prayerProgress: prayerData.progress,
          notifications: HomeMockData.notifications,
          adhanSettings: HomeMockData.defaultAdhanSettings.copyWith(
            isAnaOsalyEnabled: UserHiveHelper.getAnaOsalyEnabled(
              defaultValue: HomeMockData.defaultAdhanSettings.isAnaOsalyEnabled,
            ),
            anaOsalyLanguage: UserHiveHelper.getAnaOsalyLanguage(
              defaultValue: HomeMockData.defaultAdhanSettings.anaOsalyLanguage,
            ),
            selectedSoundId: UserHiveHelper.getSelectedAdhanSound(),
            customMessageAr: UserHiveHelper.getAnaOsalyCustomMessageAr(),
            customMessageEn: UserHiveHelper.getAnaOsalyCustomMessageEn(),
            isPreAdhanReminderEnabled: UserHiveHelper.getPreAdhanReminderEnabled(
              defaultValue:
                  HomeMockData.defaultAdhanSettings.isPreAdhanReminderEnabled,
            ),
            preAdhanReminderMinutes: UserHiveHelper.getPreAdhanReminderMinutes(
              defaultValue:
                  HomeMockData.defaultAdhanSettings.preAdhanReminderMinutes,
            ),
          ),
          currentLanguage: lang,
          ramadanCheckData: ramadan,
          occasionsList: occasions,
          nextOccasion: occasions.isNotEmpty ? occasions.first : null,
          activeHijriMonth: ramadan.hijriDate.monthNumber,
          activeHijriYear: ramadan.hijriDate.yearNumber,
        ),
      );

      _scheduleNotifications(prayerData.prayerTimes, occasions, lang);
    } else {
      emit(
        state.copyWith(
          status: HomelayoutStatus.success,
          prayerTimes: prayerData.prayerTimes,
          selectedPrayerDayOffset: 0,
          selectedPrayerDate: prayerData.selectedDate,
          nextPrayerTime: prayerData.nextTime,
          nextPrayerType: prayerData.nextType,
          nextPrayerName: prayerData.nextName,
          prayerCityName: initialCityName,
          previousPrayerTime: prayerData.previousTime,
          prayerProgress: prayerData.progress,
          notifications: HomeMockData.notifications,
          adhanSettings: HomeMockData.defaultAdhanSettings.copyWith(
            isAnaOsalyEnabled: UserHiveHelper.getAnaOsalyEnabled(
              defaultValue: HomeMockData.defaultAdhanSettings.isAnaOsalyEnabled,
            ),
            anaOsalyLanguage: UserHiveHelper.getAnaOsalyLanguage(
              defaultValue: HomeMockData.defaultAdhanSettings.anaOsalyLanguage,
            ),
            selectedSoundId: UserHiveHelper.getSelectedAdhanSound(),
            customMessageAr: UserHiveHelper.getAnaOsalyCustomMessageAr(),
            customMessageEn: UserHiveHelper.getAnaOsalyCustomMessageEn(),
            isPreAdhanReminderEnabled: UserHiveHelper.getPreAdhanReminderEnabled(
              defaultValue:
                  HomeMockData.defaultAdhanSettings.isPreAdhanReminderEnabled,
            ),
            preAdhanReminderMinutes: UserHiveHelper.getPreAdhanReminderMinutes(
              defaultValue:
                  HomeMockData.defaultAdhanSettings.preAdhanReminderMinutes,
            ),
          ),
        ),
      );
      _scheduleNotifications(prayerData.prayerTimes, state.occasionsList, lang);
    }

    // 2. Refresh geolocated city name in background
    unawaited(
      getPrayerCityName(lang).then((cityName) {
        if (!isClosed && cityName.isNotEmpty) {
          add(UpdatePrayerCityNameEvent(cityName));
        }
      }),
    );

    // 3. Fetch banners and background sync without blocking prayer times
    if (getBanners != null) {
      try {
        final banners = await getBanners!(language: lang);
        if (banners.isNotEmpty && !isClosed) {
          emit(state.copyWith(banners: banners));
        }
      } catch (_) {}
    }

    if (syncOccasionsData != null && getRamadanCheck != null && getOccasionsList != null) {
      await syncOccasionsData!();
      final updatedRamadan = await getRamadanCheck!(language: lang);
      final updatedOccasions = await getOccasionsList!(language: lang);
      if (!isClosed) {
        emit(
          state.copyWith(
            currentLanguage: lang,
            ramadanCheckData: updatedRamadan,
            occasionsList: updatedOccasions,
            nextOccasion: updatedOccasions.isNotEmpty
                ? updatedOccasions.first
                : null,
            activeHijriMonth: updatedRamadan.hijriDate.monthNumber,
            activeHijriYear: updatedRamadan.hijriDate.yearNumber,
          ),
        );
        _scheduleNotifications(state.prayerTimes, updatedOccasions, lang);
      }
    }
  }

  void _onUpdatePrayerCityName(
    UpdatePrayerCityNameEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    emit(state.copyWith(prayerCityName: event.cityName));
  }

  void _scheduleNotifications(
    List<PrayerTimeModel> prayers,
    List<OccasionItemModel> occasions,
    String language,
  ) {
    if (UserHiveHelper.getPrayerAlertsEnabled()) {
      LocalNotificationService.schedulePrayerNotifications(
        prayers: prayers,
        isFullAdhan: state.adhanSettings.isFullAdhan,
        language: language,
        soundId: state.adhanSettings.selectedSoundId,
        isPreReminderEnabled: state.adhanSettings.isPreAdhanReminderEnabled,
        preReminderMinutes: state.adhanSettings.preAdhanReminderMinutes,
      );
    }
    if (UserHiveHelper.getOccasionsNotificationsEnabled()) {
      LocalNotificationService.scheduleOccasionsNotifications(
        occasions: occasions,
        language: language,
      );
    }
  }

  FutureOr<void> _onLoadOccasions(
    LoadOccasionsDataEvent event,
    Emitter<HomelayoutState> emit,
  ) async {
    final lang = event.language ?? UserHiveHelper.getUser()?.language ?? 'ar';
    final cachedCityName = UserHiveHelper.getCachedPrayerCityName();
    final prayerData = _computePrayerState(
      dayOffset: state.selectedPrayerDayOffset,
      language: lang,
    );

    final banners = getBanners != null
        ? await getBanners!(language: lang)
        : state.banners;

    if (getRamadanCheck != null && getOccasionsList != null) {
      final ramadan = await getRamadanCheck!(language: lang);
      final occasions = await getOccasionsList!(language: lang);
      emit(
        state.copyWith(
          currentLanguage: lang,
          prayerTimes: prayerData.prayerTimes,
          selectedPrayerDate: prayerData.selectedDate,
          nextPrayerTime: prayerData.nextTime,
          nextPrayerType: prayerData.nextType,
          nextPrayerName: prayerData.nextName,
          prayerCityName: cachedCityName.isNotEmpty ? cachedCityName : state.prayerCityName,
          previousPrayerTime: prayerData.previousTime,
          prayerProgress: prayerData.progress,
          banners: banners.isNotEmpty ? banners : state.banners,
          ramadanCheckData: ramadan,
          occasionsList: occasions,
          nextOccasion: occasions.isNotEmpty ? occasions.first : null,
          activeHijriMonth: ramadan.hijriDate.monthNumber,
          activeHijriYear: ramadan.hijriDate.yearNumber,
        ),
      );
      _scheduleNotifications(prayerData.prayerTimes, occasions, lang);
    } else {
      emit(
        state.copyWith(
          currentLanguage: lang,
          prayerTimes: prayerData.prayerTimes,
          selectedPrayerDate: prayerData.selectedDate,
          nextPrayerTime: prayerData.nextTime,
          nextPrayerType: prayerData.nextType,
          nextPrayerName: prayerData.nextName,
          prayerCityName: cachedCityName.isNotEmpty ? cachedCityName : state.prayerCityName,
          previousPrayerTime: prayerData.previousTime,
          prayerProgress: prayerData.progress,
          banners: banners.isNotEmpty ? banners : state.banners,
        ),
      );
      _scheduleNotifications(prayerData.prayerTimes, state.occasionsList, lang);
    }

    unawaited(
      getPrayerCityName(lang).then((cityName) {
        if (!isClosed && cityName.isNotEmpty) {
          add(UpdatePrayerCityNameEvent(cityName));
        }
      }),
    );
  }

  FutureOr<void> _onSyncOccasions(
    SyncOccasionsDataEvent event,
    Emitter<HomelayoutState> emit,
  ) async {
    if (syncOccasionsData != null &&
        getRamadanCheck != null &&
        getOccasionsList != null) {
      await syncOccasionsData!();
      final lang = state.currentLanguage;
      final ramadan = await getRamadanCheck!(language: lang);
      final occasions = await getOccasionsList!(language: lang);
      final banners = getBanners != null
          ? await getBanners!(language: lang)
          : state.banners;
      emit(
        state.copyWith(
          ramadanCheckData: ramadan,
          occasionsList: occasions,
          banners: banners.isNotEmpty ? banners : state.banners,
          nextOccasion: occasions.isNotEmpty ? occasions.first : null,
          activeHijriMonth: ramadan.hijriDate.monthNumber,
          activeHijriYear: ramadan.hijriDate.yearNumber,
        ),
      );
      _scheduleNotifications(state.prayerTimes, occasions, lang);
    }
  }

  void _onNavigateHijriMonth(
    NavigateHijriMonthEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    int newMonth = state.activeHijriMonth + event.delta;
    int newYear = state.activeHijriYear;
    if (newMonth > 12) {
      newMonth = 1;
      newYear += 1;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear -= 1;
    }
    emit(state.copyWith(activeHijriMonth: newMonth, activeHijriYear: newYear));
  }

  void _onNavigateGregorianMonth(
    NavigateGregorianMonthEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    int newMonth = state.activeGregorianMonth + event.delta;
    int newYear = state.activeGregorianYear;
    if (newMonth > 12) {
      newMonth = 1;
      newYear += 1;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear -= 1;
    }
    emit(
      state.copyWith(
        activeGregorianMonth: newMonth,
        activeGregorianYear: newYear,
      ),
    );
  }

  void _onResetHijriMonth(
    ResetHijriMonthToCurrentEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    final hijri = state.ramadanCheckData?.hijriDate;
    emit(
      state.copyWith(
        activeHijriMonth: hijri?.monthNumber ?? 3,
        activeHijriYear: hijri?.yearNumber ?? 1448,
      ),
    );
  }

  void _onResetGregorianMonth(
    ResetGregorianMonthToCurrentEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    final now = DateTime.now();
    emit(
      state.copyWith(
        activeGregorianMonth: now.month,
        activeGregorianYear: now.year,
      ),
    );
  }

  void _onNavigatePrayerDay(
    NavigatePrayerDayEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    final newOffset = (state.selectedPrayerDayOffset + event.delta).clamp(
      -15,
      15,
    );
    final prayerData = _computePrayerState(
      dayOffset: newOffset,
      language: state.currentLanguage,
    );

    emit(
      state.copyWith(
        selectedPrayerDayOffset: newOffset,
        selectedPrayerDate: prayerData.selectedDate,
        prayerTimes: prayerData.prayerTimes,
        nextPrayerTime: prayerData.nextTime,
        nextPrayerType: prayerData.nextType,
        nextPrayerName: prayerData.nextName,
        previousPrayerTime: prayerData.previousTime,
        prayerProgress: prayerData.progress,
      ),
    );
  }

  void _onResetPrayerDayToToday(
    ResetPrayerDayToTodayEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    final prayerData = _computePrayerState(
      dayOffset: 0,
      language: state.currentLanguage,
    );

    emit(
      state.copyWith(
        selectedPrayerDayOffset: 0,
        selectedPrayerDate: prayerData.selectedDate,
        prayerTimes: prayerData.prayerTimes,
        nextPrayerTime: prayerData.nextTime,
        nextPrayerType: prayerData.nextType,
        nextPrayerName: prayerData.nextName,
        previousPrayerTime: prayerData.previousTime,
        prayerProgress: prayerData.progress,
      ),
    );
  }

  void _onRefreshPrayerTimes(
    RefreshPrayerTimesEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    final prayerData = _computePrayerState(
      dayOffset: state.selectedPrayerDayOffset,
      language: state.currentLanguage,
    );

    emit(
      state.copyWith(
        prayerTimes: prayerData.prayerTimes,
        selectedPrayerDate: prayerData.selectedDate,
        nextPrayerTime: prayerData.nextTime,
        nextPrayerType: prayerData.nextType,
        nextPrayerName: prayerData.nextName,
        previousPrayerTime: prayerData.previousTime,
        prayerProgress: prayerData.progress,
      ),
    );
  }

  void _onChangeTab(
    ChangeBottomNavTabEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    emit(state.copyWith(currentTabIndex: event.tabIndex));
  }

  void _onTogglePrayerNotification(
    TogglePrayerNotificationEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    final updatedList = state.prayerTimes.map((item) {
      if (item.type == event.prayerType) {
        final newStatus = !item.isNotificationEnabled;
        UserHiveHelper.setPrayerNotification(event.prayerType.name, newStatus);
        return item.copyWith(isNotificationEnabled: newStatus);
      }
      return item;
    }).toList();

    emit(state.copyWith(prayerTimes: updatedList));

    if (UserHiveHelper.getPrayerAlertsEnabled()) {
      LocalNotificationService.schedulePrayerNotifications(
        prayers: updatedList,
        isFullAdhan: state.adhanSettings.isFullAdhan,
        language: state.currentLanguage,
        soundId: state.adhanSettings.selectedSoundId,
        isPreReminderEnabled: state.adhanSettings.isPreAdhanReminderEnabled,
        preReminderMinutes: state.adhanSettings.preAdhanReminderMinutes,
      );
    }
  }

  void _onToggleAllPrayersNotification(
    ToggleAllPrayersNotificationEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    for (final type in PrayerType.values) {
      UserHiveHelper.setPrayerNotification(type.name, event.isEnabled);
    }
    final updatedList = state.prayerTimes.map((item) {
      return item.copyWith(isNotificationEnabled: event.isEnabled);
    }).toList();

    emit(
      state.copyWith(
        prayerTimes: updatedList,
        adhanSettings: state.adhanSettings.copyWith(
          isAllPrayersEnabled: event.isEnabled,
        ),
      ),
    );

    if (event.isEnabled) {
      LocalNotificationService.schedulePrayerNotifications(
        prayers: updatedList,
        isFullAdhan: state.adhanSettings.isFullAdhan,
        language: state.currentLanguage,
        soundId: state.adhanSettings.selectedSoundId,
        isPreReminderEnabled: state.adhanSettings.isPreAdhanReminderEnabled,
        preReminderMinutes: state.adhanSettings.preAdhanReminderMinutes,
      );
    } else {
      LocalNotificationService.cancelPrayerNotifications();
    }
  }

  void _onChangeAdhanType(
    ChangeAdhanTypeEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    emit(
      state.copyWith(
        adhanSettings: state.adhanSettings.copyWith(
          isFullAdhan: event.isFullAdhan,
        ),
      ),
    );

    if (UserHiveHelper.getPrayerAlertsEnabled()) {
      LocalNotificationService.schedulePrayerNotifications(
        prayers: state.prayerTimes,
        isFullAdhan: event.isFullAdhan,
        language: state.currentLanguage,
        soundId: state.adhanSettings.selectedSoundId,
        isPreReminderEnabled: state.adhanSettings.isPreAdhanReminderEnabled,
        preReminderMinutes: state.adhanSettings.preAdhanReminderMinutes,
      );
    }
  }

  void _onToggleAnaOsaly(
    ToggleAnaOsalyEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    UserHiveHelper.setAnaOsalyEnabled(event.isEnabled);
    emit(
      state.copyWith(
        adhanSettings: state.adhanSettings.copyWith(
          isAnaOsalyEnabled: event.isEnabled,
        ),
      ),
    );
  }

  void _onChangeAnaOsalyLanguage(
    ChangeAnaOsalyLanguageEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    UserHiveHelper.setAnaOsalyLanguage(event.language);
    emit(
      state.copyWith(
        adhanSettings: state.adhanSettings.copyWith(
          anaOsalyLanguage: event.language,
        ),
      ),
    );
  }

  void _onChangeAnaOsalyCustomMessage(
    ChangeAnaOsalyCustomMessageEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    final lang = event.language ?? state.adhanSettings.anaOsalyLanguage;
    if (lang == 'en') {
      UserHiveHelper.setAnaOsalyCustomMessageEn(event.message);
      emit(
        state.copyWith(
          adhanSettings: state.adhanSettings.copyWith(
            customMessageEn: event.message,
          ),
        ),
      );
    } else {
      UserHiveHelper.setAnaOsalyCustomMessageAr(event.message);
      emit(
        state.copyWith(
          adhanSettings: state.adhanSettings.copyWith(
            customMessageAr: event.message,
          ),
        ),
      );
    }
  }

  void _onDeleteNotification(
    DeleteNotificationEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    final updatedList = state.notifications
        .where((item) => item.id != event.notificationId)
        .toList();
    emit(state.copyWith(notifications: updatedList));
  }

  void _onMarkAllNotificationsRead(
    MarkAllNotificationsReadEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    final updatedList = state.notifications.map((item) {
      return item.copyWith(isRead: true);
    }).toList();
    emit(state.copyWith(notifications: updatedList));
  }

  void _onUpdatePrayerWindowTime(
    UpdatePrayerWindowTimeEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    PrayerTimeModel? currentItem;
    for (final item in state.prayerTimes) {
      if (item.type == event.prayerType) {
        currentItem = item;
        break;
      }
    }

    final newStart = event.startWindow ?? currentItem?.startWindow;
    final newEnd = event.endWindow ?? currentItem?.endWindow;

    UserHiveHelper.setPrayerWindow(
      event.prayerType.name,
      start: newStart,
      end: newEnd,
    );

    final updatedList = state.prayerTimes.map((item) {
      if (item.type == event.prayerType) {
        return item.copyWith(
          startWindow: newStart ?? item.startWindow,
          endWindow: newEnd ?? item.endWindow,
        );
      }
      return item;
    }).toList();
    emit(state.copyWith(prayerTimes: updatedList));
  }

  void _onSendTestNotification(
    SendTestNotificationEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    LocalNotificationService.showTestNotification(
      isFullAdhan: state.adhanSettings.isFullAdhan,
      language: state.currentLanguage,
    );
  }

  void _onTogglePrayerAlerts(
    TogglePrayerAlertsEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    UserHiveHelper.setPrayerAlertsEnabled(event.isEnabled);
    if (event.isEnabled) {
      LocalNotificationService.schedulePrayerNotifications(
        prayers: state.prayerTimes,
        isFullAdhan: state.adhanSettings.isFullAdhan,
        language: state.currentLanguage,
        soundId: state.adhanSettings.selectedSoundId,
        isPreReminderEnabled: state.adhanSettings.isPreAdhanReminderEnabled,
        preReminderMinutes: state.adhanSettings.preAdhanReminderMinutes,
      );
    } else {
      LocalNotificationService.cancelPrayerNotifications();
    }
  }

  void _onTogglePreAdhanReminder(
    TogglePreAdhanReminderEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    UserHiveHelper.setPreAdhanReminderEnabled(event.isEnabled);
    emit(
      state.copyWith(
        adhanSettings: state.adhanSettings.copyWith(
          isPreAdhanReminderEnabled: event.isEnabled,
        ),
      ),
    );

    if (UserHiveHelper.getPrayerAlertsEnabled()) {
      LocalNotificationService.schedulePrayerNotifications(
        prayers: state.prayerTimes,
        isFullAdhan: state.adhanSettings.isFullAdhan,
        language: state.currentLanguage,
        soundId: state.adhanSettings.selectedSoundId,
        isPreReminderEnabled: event.isEnabled,
        preReminderMinutes: state.adhanSettings.preAdhanReminderMinutes,
      );
    }
  }

  void _onChangePreAdhanReminderMinutes(
    ChangePreAdhanReminderMinutesEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    UserHiveHelper.setPreAdhanReminderMinutes(event.minutes);
    emit(
      state.copyWith(
        adhanSettings: state.adhanSettings.copyWith(
          preAdhanReminderMinutes: event.minutes,
        ),
      ),
    );

    if (UserHiveHelper.getPrayerAlertsEnabled()) {
      LocalNotificationService.schedulePrayerNotifications(
        prayers: state.prayerTimes,
        isFullAdhan: state.adhanSettings.isFullAdhan,
        language: state.currentLanguage,
        soundId: state.adhanSettings.selectedSoundId,
        isPreReminderEnabled: state.adhanSettings.isPreAdhanReminderEnabled,
        preReminderMinutes: event.minutes,
      );
    }
  }

  void _onSendTestPreAdhanNotification(
    SendTestPreAdhanNotificationEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    LocalNotificationService.showTestPreAdhanNotification(
      language: state.currentLanguage,
      minutes: state.adhanSettings.preAdhanReminderMinutes,
    );
  }

  void _onToggleOccasionsNotifications(
    ToggleOccasionsNotificationsEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    UserHiveHelper.setOccasionsNotificationsEnabled(event.isEnabled);
    if (event.isEnabled) {
      LocalNotificationService.scheduleOccasionsNotifications(
        occasions: state.occasionsList,
        language: state.currentLanguage,
      );
    } else {
      LocalNotificationService.cancelOccasionNotifications();
    }
  }

  void _onToggleGeneralNotifications(
    ToggleGeneralNotificationsEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    UserHiveHelper.setGeneralNotificationsEnabled(event.isEnabled);
  }

  void _onToggleAthkarNotifications(
    ToggleAthkarNotificationsEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    UserHiveHelper.setAthkarNotificationsEnabled(event.isEnabled);
  }

  void _onSelectAdhanSound(
    SelectAdhanSoundEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    UserHiveHelper.setSelectedAdhanSound(event.soundId);
    emit(
      state.copyWith(
        adhanSettings: state.adhanSettings.copyWith(
          selectedSoundId: event.soundId,
        ),
      ),
    );

    LocalNotificationService.showTestNotification(
      isFullAdhan: state.adhanSettings.isFullAdhan,
      language: state.currentLanguage,
      soundId: event.soundId,
    );

    if (UserHiveHelper.getPrayerAlertsEnabled()) {
      LocalNotificationService.schedulePrayerNotifications(
        prayers: state.prayerTimes,
        isFullAdhan: state.adhanSettings.isFullAdhan,
        language: state.currentLanguage,
        soundId: event.soundId,
        isPreReminderEnabled: state.adhanSettings.isPreAdhanReminderEnabled,
        preReminderMinutes: state.adhanSettings.preAdhanReminderMinutes,
      );
    }
  }
}

// =========================================================================
// ARCHIVED ORIGINAL HOMELAYOUT BLOC
// =========================================================================
// class HomelayoutBloc extends Bloc<HomelayoutEvent, HomelayoutState> {
//   final GetHomelayoutUseCase? getHomelayout;
//   final GetRamadanCheckUseCase? getRamadanCheck;
//   final GetOccasionsListUseCase? getOccasionsList;
//   final SyncOccasionsDataUseCase? syncOccasionsData;
//   ...
// }
