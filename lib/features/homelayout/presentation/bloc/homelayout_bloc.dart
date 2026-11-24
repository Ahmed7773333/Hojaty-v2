import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/core/utils/local_notification_service.dart';
import 'package:hojaty/core/utils/location_service.dart';
import 'package:hojaty/data/mocks/home_mock_data.dart';
import 'package:hojaty/features/homelayout/data/datasources/local/occasions_local_data_source_impl.dart';
import 'package:hojaty/features/homelayout/data/models/adhan_setting_model.dart';
import 'package:hojaty/features/homelayout/data/models/hijri_calendar_helper.dart';
import 'package:hojaty/features/homelayout/data/models/hijri_date_model.dart';
import 'package:hojaty/features/homelayout/data/models/occasion_item_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayers_helper.dart';
import 'package:hojaty/features/homelayout/data/models/ramadan_check_response_model.dart';
import 'package:hojaty/features/homelayout/domain/entities/active_adhkar_window.dart';
import 'package:hojaty/features/homelayout/domain/usecases/get_banners_use_case.dart';
import 'package:hojaty/features/homelayout/domain/usecases/get_homelayout.dart';
import 'package:hojaty/features/homelayout/domain/usecases/occasions_use_cases.dart';
import 'package:hojaty/features/homelayout/domain/usecases/resolve_active_adhkar_usecase.dart';
import 'package:hojaty/features/homelayout/domain/usecases/sync_prayer_widget_use_case.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_event.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_state.dart';

class HomelayoutBloc extends Bloc<HomelayoutEvent, HomelayoutState> {
  static Future<String> getPrayerCityName(
    String language, {
    double? latitude,
    double? longitude,
    Dio? dio,
  }) async {
    final client = dio ?? Dio();
    final separator = language == 'ar' ? '، ' : ', ';
    final latParam = latitude != null ? '&latitude=$latitude' : '';
    final lngParam = longitude != null ? '&longitude=$longitude' : '';

    // 1. Try BigDataCloud reverse geocode client (supports Arabic, English, and other languages natively)
    try {
      final response = await client.get(
        'https://api.bigdatacloud.net/data/reverse-geocode-client?localityLanguage=$language$latParam$lngParam',
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
  final ResolveActiveAdhkarUseCase resolveActiveAdhkar;
  final SyncPrayerWidgetUseCase? syncPrayerWidget;

  Timer? _adhkarBoundaryTimer;

  HomelayoutBloc({
    this.getHomelayout,
    this.getRamadanCheck,
    this.getOccasionsList,
    this.syncOccasionsData,
    this.getBanners,
    ResolveActiveAdhkarUseCase? resolveActiveAdhkar,
    this.syncPrayerWidget,
  }) : resolveActiveAdhkar =
           resolveActiveAdhkar ?? const ResolveActiveAdhkarUseCase(),
       super(
         HomelayoutState(
           status: HomelayoutStatus.success,
           notifications: HomeMockData.notifications,
           banners: HomeMockData.banners,
           ramadanCheckData:
               OccasionsLocalDataSourceImpl.getCachedRamadanCheckSync(
                 language: 'ar',
               ) ??
               RamadanCheckData.fallback(language: 'ar'),
           occasionsList: HijriCalendarHelper.calculateOccasions(
             (OccasionsLocalDataSourceImpl.getCachedRamadanCheckSync(
                       language: 'ar',
                     ) ??
                     RamadanCheckData.fallback(language: 'ar'))
                 .hijriDate,
             language: 'ar',
           ),
           nextOccasion: HijriCalendarHelper.calculateOccasions(
             (OccasionsLocalDataSourceImpl.getCachedRamadanCheckSync(
                       language: 'ar',
                     ) ??
                     RamadanCheckData.fallback(language: 'ar'))
                 .hijriDate,
             language: 'ar',
           ).firstOrNull,
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
    on<SelectPrayerAdhanSoundEvent>(_onSelectPrayerAdhanSound);
    on<UpdatePrayerCityNameEvent>(_onUpdatePrayerCityName);
    on<CheckLocationUpdateEvent>(_onCheckLocationUpdate);
    on<SelectPrayerCityEvent>(_onSelectPrayerCity);
    on<ToggleSalawatReminderEvent>(_onToggleSalawatReminder);
    on<RefreshActiveAdhkarEvent>(_onRefreshActiveAdhkar);
    on<ChangeAsrMadhabEvent>(_onChangeAsrMadhab);
    on<ChangePrayerTimeOffsetEvent>(_onChangePrayerTimeOffset);
    on<ResetPrayerTimeOffsetsEvent>(_onResetPrayerTimeOffsets);
  }

  @override
  Future<void> close() {
    _adhkarBoundaryTimer?.cancel();
    _adhkarBoundaryTimer = null;
    return super.close();
  }

  ActiveAdhkarWindow _resolveAndScheduleActiveAdhkar({
    GeoCoordinates? coordinates,
  }) {
    final now = DateTime.now();
    final coords = coordinates ?? UserHiveHelper.getCachedCoordinates();
    final params = UserHiveHelper.getPrayerCalculationParameters(coords);
    final window = resolveActiveAdhkar(
      now: now,
      coordinates: coords,
      parameters: params,
    );

    _adhkarBoundaryTimer?.cancel();
    if (!isClosed) {
      final rawDelay =
          window.nextBoundary.difference(now) + const Duration(seconds: 1);
      final delay = rawDelay < const Duration(seconds: 1)
          ? const Duration(seconds: 1)
          : rawDelay;
      _adhkarBoundaryTimer = Timer(delay, () {
        if (!isClosed) {
          add(const RefreshActiveAdhkarEvent());
        }
      });
    }

    return window;
  }

  // ---------------------------------------------------------------------------
  // Prayer Times Calculation Helper
  // ---------------------------------------------------------------------------

  ({
    List<PrayerTimeModel> prayerTimes,
    DateTime sunriseTime,
    DateTime selectedDate,
    DateTime nextTime,
    PrayerType? nextType,
    String nextName,
    DateTime previousTime,
    double progress,
  })
  _computePrayerState({
    required int dayOffset,
    required String language,
    GeoCoordinates? coordinates,
  }) {
    final coords = coordinates ?? UserHiveHelper.getCachedCoordinates();
    final params = UserHiveHelper.getPrayerCalculationParameters(coords);
    final helper = PrayersHelper(coordinates: coords, parameters: params);
    final now = DateTime.now();
    final targetDate = now.add(Duration(days: dayOffset));
    final sunriseTime = helper.getSunriseDateTime(targetDate);

    final notifOverrides = <PrayerType, bool>{};
    final windowOverrides = <PrayerType, ({String? start, String? end})>{};

    for (final type in PrayerType.values) {
      notifOverrides[type] = UserHiveHelper.getPrayerNotification(
        type.name,
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
    final nextName = nextInfo.isSunrise
        ? (language == 'ar' ? 'الشروق' : 'Sunrise')
        : (nextInfo.nextType != null
            ? PrayersHelper.getPrayerName(
                nextInfo.nextType!,
                language: language,
              )
            : '');
    final progress = PrayersHelper.calculatePrayerProgress(
      now: now,
      previousTime: nextInfo.previousTime,
      nextTime: nextInfo.nextTime,
    );

    return (
      prayerTimes: prayersList,
      sunriseTime: sunriseTime,
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
    final activeAdhkar = _resolveAndScheduleActiveAdhkar();
    final initialCityName = UserHiveHelper.getCachedPrayerCityName();

    if (getRamadanCheck != null && getOccasionsList != null) {
      final ramadan = await getRamadanCheck!(language: lang);
      final occasions = await getOccasionsList!(language: lang);

      emit(
        state.copyWith(
          status: HomelayoutStatus.success,
          prayerTimes: prayerData.prayerTimes,
          sunriseTime: prayerData.sunriseTime,
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
            prayerSoundIds: UserHiveHelper.getAllPrayerAdhanSounds(),
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
            prayerPreAdhanReminderMinutes:
                UserHiveHelper.getAllPrayerPreAdhanReminderMinutes(
              defaultMinutes:
                  HomeMockData.defaultAdhanSettings.preAdhanReminderMinutes,
            ),
            isSalawatReminderEnabled: UserHiveHelper.getSalawatReminderEnabled(),
            asrMadhab: UserHiveHelper.getAsrMadhab(),
            prayerTimeOffsets: UserHiveHelper.getAllPrayerTimeOffsets(),
          ),
          currentLanguage: lang,
          ramadanCheckData: ramadan,
          occasionsList: occasions,
          nextOccasion: occasions.isNotEmpty ? occasions.first : null,
          activeHijriMonth: ramadan.hijriDate.monthNumber,
          activeHijriYear: ramadan.hijriDate.yearNumber,
          activeAdhkar: activeAdhkar,
        ),
      );

      _scheduleNotifications(prayerData.prayerTimes, occasions, lang);
      _syncHomeWidget(
        language: lang,
        locationName: initialCityName,
        hijriDate: ramadan.hijriDate,
      );
    } else {
      emit(
        state.copyWith(
          status: HomelayoutStatus.success,
          prayerTimes: prayerData.prayerTimes,
          sunriseTime: prayerData.sunriseTime,
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
            prayerSoundIds: UserHiveHelper.getAllPrayerAdhanSounds(),
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
            prayerPreAdhanReminderMinutes:
                UserHiveHelper.getAllPrayerPreAdhanReminderMinutes(
              defaultMinutes:
                  HomeMockData.defaultAdhanSettings.preAdhanReminderMinutes,
            ),
            isSalawatReminderEnabled: UserHiveHelper.getSalawatReminderEnabled(),
            asrMadhab: UserHiveHelper.getAsrMadhab(),
            prayerTimeOffsets: UserHiveHelper.getAllPrayerTimeOffsets(),
          ),
          activeAdhkar: activeAdhkar,
        ),
      );
      _scheduleNotifications(prayerData.prayerTimes, state.occasionsList, lang);
      _syncHomeWidget(language: lang, locationName: initialCityName);
    }

    // 2. Trigger smart background location update check
    add(const CheckLocationUpdateEvent());

    // 3. Refresh geolocated city name only if not already cached
    if (initialCityName.isEmpty) {
      final cachedCoords = UserHiveHelper.getCachedCoordinates();
      unawaited(
        getPrayerCityName(
          lang,
          latitude: cachedCoords.latitude,
          longitude: cachedCoords.longitude,
        ).then((cityName) {
          if (!isClosed && cityName.isNotEmpty) {
            add(UpdatePrayerCityNameEvent(cityName));
          }
        }),
      );
    }

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
        _syncHomeWidget(
          language: lang,
          hijriDate: updatedRamadan.hijriDate,
        );
      }
    }
  }

  void _syncHomeWidget({
    String? language,
    String? locationName,
    HijriDateModel? hijriDate,
    GeoCoordinates? coordinates,
  }) {
    final useCase = syncPrayerWidget;
    if (useCase == null) return;
    unawaited(
      useCase(
        language: language ?? state.currentLanguage,
        locationName: locationName ?? state.prayerCityName,
        hijriDate: hijriDate ?? state.ramadanCheckData?.hijriDate,
        coordinates: coordinates,
      ),
    );
  }

  void _onUpdatePrayerCityName(
    UpdatePrayerCityNameEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    emit(state.copyWith(prayerCityName: event.cityName));
    _syncHomeWidget(locationName: event.cityName);
  }

  Future<void> _onCheckLocationUpdate(
    CheckLocationUpdateEvent event,
    Emitter<HomelayoutState> emit,
  ) async {
    final newCoords = await LocationService.getCurrentLocation(force: event.force);
    if (newCoords != null) {
      final prayerData = _computePrayerState(
        dayOffset: state.selectedPrayerDayOffset,
        language: state.currentLanguage,
        coordinates: newCoords,
      );
      final activeAdhkar = _resolveAndScheduleActiveAdhkar(
        coordinates: newCoords,
      );

      _scheduleNotifications(
        prayerData.prayerTimes,
        state.occasionsList,
        state.currentLanguage,
      );

      final cityName = await getPrayerCityName(
        state.currentLanguage,
        latitude: newCoords.latitude,
        longitude: newCoords.longitude,
      );

      final resolvedCity = cityName.isNotEmpty ? cityName : state.prayerCityName;
      emit(
        state.copyWith(
          prayerTimes: prayerData.prayerTimes,
          sunriseTime: prayerData.sunriseTime,
          prayerCityName: resolvedCity,
          selectedPrayerDate: prayerData.selectedDate,
          nextPrayerTime: prayerData.nextTime,
          nextPrayerType: prayerData.nextType,
          nextPrayerName: prayerData.nextName,
          previousPrayerTime: prayerData.previousTime,
          prayerProgress: prayerData.progress,
          activeAdhkar: activeAdhkar,
        ),
      );
      _syncHomeWidget(locationName: resolvedCity, coordinates: newCoords);
    }
  }

  void _onSelectPrayerCity(
    SelectPrayerCityEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    UserHiveHelper.setCachedPrayerCityName(event.cityName);
    UserHiveHelper.setCachedCoordinates(
      event.coordinates.latitude,
      event.coordinates.longitude,
    );

    final prayerData = _computePrayerState(
      dayOffset: state.selectedPrayerDayOffset,
      language: state.currentLanguage,
      coordinates: event.coordinates,
    );
    final activeAdhkar = _resolveAndScheduleActiveAdhkar(
      coordinates: event.coordinates,
    );

    _scheduleNotifications(
      prayerData.prayerTimes,
      state.occasionsList,
      state.currentLanguage,
    );

    emit(
      state.copyWith(
        prayerCityName: event.cityName,
        prayerTimes: prayerData.prayerTimes,
        sunriseTime: prayerData.sunriseTime,
        selectedPrayerDate: prayerData.selectedDate,
        nextPrayerTime: prayerData.nextTime,
        nextPrayerType: prayerData.nextType,
        nextPrayerName: prayerData.nextName,
        previousPrayerTime: prayerData.previousTime,
        prayerProgress: prayerData.progress,
        activeAdhkar: activeAdhkar,
      ),
    );
    _syncHomeWidget(
      locationName: event.cityName,
      coordinates: event.coordinates,
    );
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
        prayerPreReminderMinutes:
            state.adhanSettings.prayerPreAdhanReminderMinutes,
      );
    }
    if (UserHiveHelper.getOccasionsNotificationsEnabled()) {
      LocalNotificationService.scheduleOccasionsNotifications(
        occasions: occasions,
        language: language,
      );
    }
    final isSalawatEnabled = UserHiveHelper.getSalawatReminderEnabled();
    if (isSalawatEnabled) {
      LocalNotificationService.scheduleSalawatNotification(
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
          sunriseTime: prayerData.sunriseTime,
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
      _syncHomeWidget(
        language: lang,
        locationName: cachedCityName.isNotEmpty
            ? cachedCityName
            : state.prayerCityName,
        hijriDate: ramadan.hijriDate,
      );
    } else {
      emit(
        state.copyWith(
          currentLanguage: lang,
          prayerTimes: prayerData.prayerTimes,
          sunriseTime: prayerData.sunriseTime,
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
      _syncHomeWidget(
        language: lang,
        locationName: cachedCityName.isNotEmpty
            ? cachedCityName
            : state.prayerCityName,
      );
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
      _syncHomeWidget(language: lang, hijriDate: ramadan.hijriDate);
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
        sunriseTime: prayerData.sunriseTime,
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
        sunriseTime: prayerData.sunriseTime,
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
    final activeAdhkar = _resolveAndScheduleActiveAdhkar();

    emit(
      state.copyWith(
        prayerTimes: prayerData.prayerTimes,
        sunriseTime: prayerData.sunriseTime,
        selectedPrayerDate: prayerData.selectedDate,
        nextPrayerTime: prayerData.nextTime,
        nextPrayerType: prayerData.nextType,
        nextPrayerName: prayerData.nextName,
        previousPrayerTime: prayerData.previousTime,
        prayerProgress: prayerData.progress,
        activeAdhkar: activeAdhkar,
      ),
    );
    _syncHomeWidget();
  }

  void _onRefreshActiveAdhkar(
    RefreshActiveAdhkarEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    final activeAdhkar = _resolveAndScheduleActiveAdhkar();
    if (state.selectedPrayerDayOffset == 0) {
      final prayerData = _computePrayerState(
        dayOffset: 0,
        language: state.currentLanguage,
      );
      emit(
        state.copyWith(
          prayerTimes: prayerData.prayerTimes,
          sunriseTime: prayerData.sunriseTime,
          selectedPrayerDate: prayerData.selectedDate,
          nextPrayerTime: prayerData.nextTime,
          nextPrayerType: prayerData.nextType,
          nextPrayerName: prayerData.nextName,
          previousPrayerTime: prayerData.previousTime,
          prayerProgress: prayerData.progress,
          activeAdhkar: activeAdhkar,
        ),
      );
    } else {
      emit(state.copyWith(activeAdhkar: activeAdhkar));
    }
  }

  void _onChangeAsrMadhab(
    ChangeAsrMadhabEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    UserHiveHelper.setAsrMadhab(event.madhab);
    _recomputePrayersAfterSettingChange(
      emit,
      updatedAdhanSettings: state.adhanSettings.copyWith(asrMadhab: event.madhab),
    );
  }

  void _onChangePrayerTimeOffset(
    ChangePrayerTimeOffsetEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    final clamped = event.offsetMinutes.clamp(-30, 30);
    UserHiveHelper.setPrayerTimeOffset(event.prayerType.name, clamped);
    final updatedOffsets = Map<String, int>.from(
      state.adhanSettings.prayerTimeOffsets,
    )..[event.prayerType.name] = clamped;

    _recomputePrayersAfterSettingChange(
      emit,
      updatedAdhanSettings: state.adhanSettings.copyWith(
        prayerTimeOffsets: updatedOffsets,
      ),
    );
  }

  void _onResetPrayerTimeOffsets(
    ResetPrayerTimeOffsetsEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    UserHiveHelper.resetAllPrayerTimeOffsets();
    _recomputePrayersAfterSettingChange(
      emit,
      updatedAdhanSettings: state.adhanSettings.copyWith(
        prayerTimeOffsets: UserHiveHelper.getAllPrayerTimeOffsets(),
      ),
    );
  }

  void _recomputePrayersAfterSettingChange(
    Emitter<HomelayoutState> emit, {
    required AdhanSettingModel updatedAdhanSettings,
  }) {
    final prayerData = _computePrayerState(
      dayOffset: state.selectedPrayerDayOffset,
      language: state.currentLanguage,
    );
    final activeAdhkar = _resolveAndScheduleActiveAdhkar();

    emit(
      state.copyWith(
        adhanSettings: updatedAdhanSettings,
        prayerTimes: prayerData.prayerTimes,
        sunriseTime: prayerData.sunriseTime,
        selectedPrayerDate: prayerData.selectedDate,
        nextPrayerTime: prayerData.nextTime,
        nextPrayerType: prayerData.nextType,
        nextPrayerName: prayerData.nextName,
        previousPrayerTime: prayerData.previousTime,
        prayerProgress: prayerData.progress,
        activeAdhkar: activeAdhkar,
      ),
    );

    _scheduleNotifications(
      prayerData.prayerTimes,
      state.occasionsList,
      state.currentLanguage,
    );
    _syncHomeWidget();
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
        prayerPreReminderMinutes:
            state.adhanSettings.prayerPreAdhanReminderMinutes,
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
        prayerPreReminderMinutes:
            state.adhanSettings.prayerPreAdhanReminderMinutes,
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
        prayerPreReminderMinutes:
            state.adhanSettings.prayerPreAdhanReminderMinutes,
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
    _syncHomeWidget();
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
        prayerPreReminderMinutes:
            state.adhanSettings.prayerPreAdhanReminderMinutes,
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
        prayerPreReminderMinutes:
            state.adhanSettings.prayerPreAdhanReminderMinutes,
      );
    }
  }

  void _onChangePreAdhanReminderMinutes(
    ChangePreAdhanReminderMinutesEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    final updatedMap = Map<String, int>.from(
      state.adhanSettings.prayerPreAdhanReminderMinutes,
    );

    if (event.prayerType == null) {
      UserHiveHelper.setPreAdhanReminderMinutes(event.minutes);
      const prayerNames = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
      for (final p in prayerNames) {
        UserHiveHelper.setPrayerPreAdhanReminderMinutes(p, event.minutes);
        updatedMap[p] = event.minutes;
      }
      emit(
        state.copyWith(
          adhanSettings: state.adhanSettings.copyWith(
            preAdhanReminderMinutes: event.minutes,
            prayerPreAdhanReminderMinutes: updatedMap,
          ),
        ),
      );
    } else {
      UserHiveHelper.setPrayerPreAdhanReminderMinutes(
        event.prayerType!.name,
        event.minutes,
      );
      updatedMap[event.prayerType!.name] = event.minutes;
      emit(
        state.copyWith(
          adhanSettings: state.adhanSettings.copyWith(
            prayerPreAdhanReminderMinutes: updatedMap,
          ),
        ),
      );
    }

    if (UserHiveHelper.getPrayerAlertsEnabled()) {
      LocalNotificationService.schedulePrayerNotifications(
        prayers: state.prayerTimes,
        isFullAdhan: state.adhanSettings.isFullAdhan,
        language: state.currentLanguage,
        soundId: state.adhanSettings.selectedSoundId,
        isPreReminderEnabled: state.adhanSettings.isPreAdhanReminderEnabled,
        preReminderMinutes: state.adhanSettings.preAdhanReminderMinutes,
        prayerPreReminderMinutes: updatedMap,
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

  void _onToggleSalawatReminder(
    ToggleSalawatReminderEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    UserHiveHelper.setSalawatReminderEnabled(event.enabled);
    emit(
      state.copyWith(
        adhanSettings: state.adhanSettings.copyWith(
          isSalawatReminderEnabled: event.enabled,
        ),
      ),
    );
    final lang = UserHiveHelper.getUser()?.language ?? 'ar';
    if (event.enabled) {
      LocalNotificationService.scheduleSalawatNotification(
        language: lang,
      );
    } else {
      LocalNotificationService.cancelSalawatNotification();
    }
  }

  void _onSelectAdhanSound(
    SelectAdhanSoundEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    UserHiveHelper.setAllPrayersAdhanSound(event.soundId);
    final updatedMap = UserHiveHelper.getAllPrayerAdhanSounds();
    emit(
      state.copyWith(
        adhanSettings: state.adhanSettings.copyWith(
          selectedSoundId: event.soundId,
          prayerSoundIds: updatedMap,
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
        prayerPreReminderMinutes:
            state.adhanSettings.prayerPreAdhanReminderMinutes,
      );
    }
  }

  void _onSelectPrayerAdhanSound(
    SelectPrayerAdhanSoundEvent event,
    Emitter<HomelayoutState> emit,
  ) {
    final updatedMap = Map<String, String>.from(state.adhanSettings.prayerSoundIds);
    if (event.prayerType == null) {
      UserHiveHelper.setAllPrayersAdhanSound(event.soundId);
      const prayerNames = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
      for (final p in prayerNames) {
        updatedMap[p] = event.soundId;
      }
      emit(
        state.copyWith(
          adhanSettings: state.adhanSettings.copyWith(
            selectedSoundId: event.soundId,
            prayerSoundIds: updatedMap,
          ),
        ),
      );
    } else {
      UserHiveHelper.setPrayerAdhanSound(event.prayerType!.name, event.soundId);
      updatedMap[event.prayerType!.name] = event.soundId;
      emit(
        state.copyWith(
          adhanSettings: state.adhanSettings.copyWith(
            prayerSoundIds: updatedMap,
          ),
        ),
      );
    }

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
        prayerPreReminderMinutes:
            state.adhanSettings.prayerPreAdhanReminderMinutes,
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
