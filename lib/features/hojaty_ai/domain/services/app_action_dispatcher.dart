import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/config/theme/app_theme_mode.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/features/hojaty_ai/data/datasources/hojaty_tool_registry.dart';
import 'package:hojaty/features/hojaty_ai/data/models/ai_tool_call_model.dart';
import 'package:hojaty/features/homelayout/data/models/athkar_category_model.dart';
import 'package:hojaty/features/homelayout/data/models/athkar_detail_args.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayers_helper.dart';
import 'package:hojaty/features/quran/constants/quran_constants.dart';
import 'package:hojaty/features/quran/data/datasources/quran_checkpoint_local_data_source.dart';
import 'package:hojaty/features/quran/data/models/quran_checkpoint_model.dart';
import 'package:hojaty/features/radio/data/models/surah_audio_args.dart';
import 'package:hojaty/features/radio/services/radio_audio_player_service.dart';

class AppActionNavigationEvent extends Equatable {
  final String routeName;
  final Object? arguments;

  const AppActionNavigationEvent({
    required this.routeName,
    this.arguments,
  });

  @override
  List<Object?> get props => [routeName, arguments];
}

class AppActionDispatcher {
  final RadioAudioPlayerService _audioPlayerService;
  final QuranCheckpointLocalDataSource _checkpointDataSource;

  final StreamController<AppActionNavigationEvent> _navigationEventController =
      StreamController<AppActionNavigationEvent>.broadcast();

  AppActionDispatcher({
    RadioAudioPlayerService? audioPlayerService,
    QuranCheckpointLocalDataSource? checkpointDataSource,
  })  : _audioPlayerService = audioPlayerService ?? RadioAudioPlayerService(),
        _checkpointDataSource =
            checkpointDataSource ?? const QuranCheckpointLocalDataSource();

  Stream<AppActionNavigationEvent> get navigationEvents =>
      _navigationEventController.stream;

  Future<AiToolActionResultModel> dispatch(AiToolCallModel toolCall) async {
    try {
      switch (toolCall.name) {
        case HojatyToolRegistry.toolPlayQuranAudio:
          return await _handlePlayQuranAudio(toolCall.arguments);

        case HojatyToolRegistry.toolGetPrayerTimes:
          return await _handleGetPrayerTimes(toolCall.arguments);

        case HojatyToolRegistry.toolOpenQuranReader:
          return await _handleOpenQuranReader(toolCall.arguments);

        case HojatyToolRegistry.toolConfigurePrayerAlerts:
          return await _handleConfigurePrayerAlerts(toolCall.arguments);

        case HojatyToolRegistry.toolOpenAthkarCategory:
          return await _handleOpenAthkarCategory(toolCall.arguments);

        case HojatyToolRegistry.toolControlSebhaCounter:
          return await _handleControlSebhaCounter(toolCall.arguments);

        case HojatyToolRegistry.toolManageQuranBookmark:
          return await _handleManageQuranBookmark(toolCall.arguments);

        case HojatyToolRegistry.toolOpenHadithReader:
          return await _handleOpenHadithReader(toolCall.arguments);

        case HojatyToolRegistry.toolOpenQiblaCompass:
          return await _handleOpenQiblaCompass(toolCall.arguments);

        case HojatyToolRegistry.toolUpdateAppPreferences:
          return await _handleUpdateAppPreferences(toolCall.arguments);

        default:
          return AiToolActionResultModel(
            toolName: toolCall.name,
            arguments: toolCall.arguments,
            isSuccess: false,
            errorMessage: 'أداة غير معروفة: ${toolCall.name}',
          );
      }
    } catch (e, st) {
      debugPrint('AppActionDispatcher error executing ${toolCall.name}: $e\n$st');
      return AiToolActionResultModel(
        toolName: toolCall.name,
        arguments: toolCall.arguments,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  // 1. Tool: Play Quran Audio or Live Radio
  Future<AiToolActionResultModel> _handlePlayQuranAudio(
    Map<String, dynamic> args,
  ) async {
    final isLiveStream = args['isLiveStream'] as bool? ?? false;
    final streamType = (args['streamType'] as String? ?? '').toLowerCase();

    if (isLiveStream) {
      String streamUrl = 'https://stream.radiojar.com/8s5u8tpdtwzuv';
      String title = 'إذاعة القرآن الكريم - القاهرة';

      if (streamType.contains('makkah') || streamType.contains('مكة')) {
        streamUrl = 'https://stream.radiojar.com/0t5u8tpdtwzuv';
        title = 'إذاعة القرآن الكريم - مكة المكرمة';
      } else if (streamType.contains('madinah') || streamType.contains('المدينة')) {
        streamUrl = 'https://stream.radiojar.com/4t5u8tpdtwzuv';
        title = 'إذاعة القرآن الكريم - المدينة المنورة';
      }

      await _audioPlayerService.playUrl(
        url: streamUrl,
        reciterName: title,
      );

      return AiToolActionResultModel(
        toolName: HojatyToolRegistry.toolPlayQuranAudio,
        arguments: args,
        result: {'type': 'live_stream', 'title': title, 'streamUrl': streamUrl},
        displayText: 'تم تشغيل $title الآن في الخلفية.',
      );
    }

    // Surah recitation
    int surahNumber = 1;
    final rawNumber = args['surahNumber'];
    if (rawNumber is num) {
      surahNumber = rawNumber.toInt().clamp(1, 114);
    } else if (args['surahName'] != null) {
      final name = args['surahName'].toString().trim();
      final match = QuranConstants.surahMap.values.firstWhere(
        (s) => s.name.contains(name) || name.contains(s.name),
        orElse: () => QuranConstants.surahMap[1]!,
      );
      surahNumber = match.number;
    }

    final surahInfo = QuranConstants.surahMap[surahNumber] ??
        QuranConstants.surahMap[1]!;

    String reciterName = args['reciterName'] as String? ?? 'عبد الباسط عبد الصمد';
    String serverUrl = 'https://server7.mp3quran.net/basit/';

    if (reciterName.contains('الحصري') || reciterName.contains('husr')) {
      reciterName = 'محمود خليل الحصري';
      serverUrl = 'https://server13.mp3quran.net/husr/';
    } else if (reciterName.contains('المنشاوي') || reciterName.contains('minsh')) {
      reciterName = 'محمد صديق المنشاوي';
      serverUrl = 'https://server10.mp3quran.net/minsh/';
    } else if (reciterName.contains('العفاسي') || reciterName.contains('afs')) {
      reciterName = 'مشاري راشد العفاسي';
      serverUrl = 'https://server10.mp3quran.net/afs/';
    }

    final surahArgs = SurahAudioArgs(
      surahNumber: surahInfo.number,
      surahNameAr: surahInfo.name,
      surahNameEn: surahInfo.englishName,
      reciterName: reciterName,
      reciterLetter: reciterName.isNotEmpty ? reciterName[0] : 'ع',
      serverUrl: serverUrl,
    );

    await _audioPlayerService.playSurahSequence(args: surahArgs);

    return AiToolActionResultModel(
      toolName: HojatyToolRegistry.toolPlayQuranAudio,
      arguments: args,
      result: {
        'type': 'surah',
        'surahNumber': surahInfo.number,
        'surahName': surahInfo.name,
        'reciterName': reciterName,
        'audioUrl': surahArgs.audioUrl,
      },
      displayText:
          'تم تشغيل سورة ${surahInfo.name} بصوت الشيخ $reciterName الآن في الخلفية.',
    );
  }

  // 2. Tool: Get Prayer Times & Countdown
  Future<AiToolActionResultModel> _handleGetPrayerTimes(
    Map<String, dynamic> args,
  ) async {
    final cityName = args['cityName'] as String? ?? '';
    final dateOffset = (args['dateOffsetDays'] as num?)?.toInt() ?? 0;
    final targetDate = DateTime.now().add(Duration(days: dateOffset));

    GeoCoordinates coords = UserHiveHelper.getCachedCoordinates();
    final String resolvedCity = cityName.isNotEmpty
        ? cityName
        : UserHiveHelper.getCachedPrayerCityName(defaultValue: 'القاهرة');

    if (cityName.contains('الإسكندرية') || cityName.contains('alexandria')) {
      coords = GeoCoordinates.alexandria;
    } else if (cityName.contains('الجيزة') || cityName.contains('giza')) {
      coords = GeoCoordinates.giza;
    } else if (cityName.contains('مكة') || cityName.contains('makkah')) {
      coords = GeoCoordinates.makkah;
    } else if (cityName.contains('المدينة') || cityName.contains('madinah')) {
      coords = GeoCoordinates.madinah;
    }

    final prayersHelper = PrayersHelper(
      coordinates: coords,
      parameters: CalculationParameters.forCoordinates(coords),
    );

    final prayerDateTimes = prayersHelper.getPrayerDateTimes(targetDate);
    final sunriseTime = prayersHelper.getSunriseDateTime(targetDate);

    final timeFormatter = DateFormat('hh:mm a', 'ar');
    final formattedTimes = <String, String>{
      'الفجر': timeFormatter.format(prayerDateTimes[PrayerType.fajr]!),
      'الشروق': timeFormatter.format(sunriseTime),
      'الظهر': timeFormatter.format(prayerDateTimes[PrayerType.dhuhr]!),
      'العصر': timeFormatter.format(prayerDateTimes[PrayerType.asr]!),
      'المغرب': timeFormatter.format(prayerDateTimes[PrayerType.maghrib]!),
      'العشاء': timeFormatter.format(prayerDateTimes[PrayerType.isha]!),
    };

    // Calculate next prayer countdown using PrayersHelper built-in logic
    final nextInfo = prayersHelper.getNextPrayerInfo(DateTime.now());
    final nextTime = nextInfo.nextTime;
    final nextType = nextInfo.nextType ?? PrayerType.fajr;
    final nextPrayerArabicName = nextInfo.isSunrise
        ? 'الشروق'
        : _getPrayerArabicName(nextType);

    final diff = nextTime.difference(DateTime.now());
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    final remainingText = hours > 0
        ? '$hours ساعة و $minutes دقيقة'
        : '$minutes دقيقة';

    return AiToolActionResultModel(
      toolName: HojatyToolRegistry.toolGetPrayerTimes,
      arguments: args,
      result: {
        'city': resolvedCity,
        'date': DateFormat('yyyy-MM-dd').format(targetDate),
        'times': formattedTimes,
        'nextPrayer': nextPrayerArabicName,
        'nextPrayerTime': timeFormatter.format(nextTime),
        'remaining': remainingText,
      },
      displayText:
          'مواقيت الصلاة في $resolvedCity اليوم: الفجر ${formattedTimes['الفجر']}، الظهر ${formattedTimes['الظهر']}، العصر ${formattedTimes['العصر']}، المغرب ${formattedTimes['المغرب']}، العشاء ${formattedTimes['العشاء']}. المتبقي على صلاة $nextPrayerArabicName هو $remainingText.',
    );
  }

  // 3. Tool: Open Quran Reader
  Future<AiToolActionResultModel> _handleOpenQuranReader(
    Map<String, dynamic> args,
  ) async {
    int pageNumber = 1;
    final rawPage = args['pageNumber'];
    final rawSurah = args['surahNumber'];
    final rawVerse = args['verseIndex'];

    if (rawPage is num) {
      pageNumber = rawPage.toInt().clamp(1, 604);
    } else if (rawSurah is num) {
      final surah = QuranConstants.surahMap[rawSurah.toInt().clamp(1, 114)];
      if (surah != null) {
        pageNumber = surah.pageNumber;
      }
    }

    final verseIndex = rawVerse is num ? rawVerse.toInt() : null;

    _navigationEventController.add(
      AppActionNavigationEvent(
        routeName: AppRoutes.quranReader,
        arguments: {
          'initialPage': pageNumber,
          'highlightVerseIndex': verseIndex,
        },
      ),
    );

    return AiToolActionResultModel(
      toolName: HojatyToolRegistry.toolOpenQuranReader,
      arguments: args,
      result: {
        'pageNumber': pageNumber,
        'highlightVerseIndex': verseIndex,
      },
      displayText: 'تم فتح المصحف الشريف عند صفحة $pageNumber.',
    );
  }

  // 4. Tool: Configure Prayer Alerts
  Future<AiToolActionResultModel> _handleConfigurePrayerAlerts(
    Map<String, dynamic> args,
  ) async {
    final prayerName = (args['prayerName'] as String? ?? 'all').toLowerCase();
    final enabled = args['enabled'] as bool? ?? true;
    final preMinutes = (args['preReminderMinutes'] as num?)?.toInt();
    final soundId = args['soundId'] as String?;

    if (prayerName == 'all') {
      UserHiveHelper.setPrayerAlertsEnabled(enabled);
      if (preMinutes != null) {
        UserHiveHelper.setPreAdhanReminderMinutes(preMinutes);
      }
      if (soundId != null) {
        UserHiveHelper.setAllPrayersAdhanSound(soundId);
      }
    } else {
      UserHiveHelper.setPrayerNotification(prayerName, enabled);
      if (preMinutes != null) {
        UserHiveHelper.setPrayerPreAdhanReminderMinutes(prayerName, preMinutes);
      }
      if (soundId != null) {
        UserHiveHelper.setPrayerAdhanSound(prayerName, soundId);
      }
    }

    final arabicPrayer = _normalizePrayerNameArabic(prayerName);

    return AiToolActionResultModel(
      toolName: HojatyToolRegistry.toolConfigurePrayerAlerts,
      arguments: args,
      result: {
        'prayerName': prayerName,
        'enabled': enabled,
        'preReminderMinutes': preMinutes,
        'soundId': soundId,
      },
      displayText:
          'تم تحديث إعدادات تنبيهات $arabicPrayer بنجاح (التنبيه: ${enabled ? 'مفعل' : 'معطل'}${preMinutes != null ? '، قبل الأذان بـ $preMinutes دقائق' : ''}).',
    );
  }

  // 5. Tool: Open Athkar Category
  Future<AiToolActionResultModel> _handleOpenAthkarCategory(
    Map<String, dynamic> args,
  ) async {
    final categoryTypeStr = (args['categoryType'] as String? ?? 'morning').toLowerCase();
    final title = args['categoryTitle'] as String? ?? 'أذكار المسلم';

    AthkarCategoryType catType = AthkarCategoryType.morning;
    String arabicTitle = 'أذكار الصباح';

    if (categoryTypeStr.contains('evening') || categoryTypeStr.contains('مساء')) {
      catType = AthkarCategoryType.evening;
      arabicTitle = 'أذكار المساء';
    } else if (categoryTypeStr.contains('sleep') || categoryTypeStr.contains('نوم')) {
      catType = AthkarCategoryType.sleep;
      arabicTitle = 'أذكار النوم';
    } else if (categoryTypeStr.contains('prayer') || categoryTypeStr.contains('صلاة')) {
      catType = AthkarCategoryType.afterPrayer;
      arabicTitle = 'أذكار بعد الصلاة';
    } else if (categoryTypeStr.contains('istikhara') || categoryTypeStr.contains('استخارة')) {
      catType = AthkarCategoryType.istikhara;
      arabicTitle = 'دعاء الاستخارة';
    }

    _navigationEventController.add(
      AppActionNavigationEvent(
        routeName: AppRoutes.athkarDetail,
        arguments: AthkarDetailArgs(
          title: title.isNotEmpty && title != 'أذكار المسلم' ? title : arabicTitle,
          categoryType: catType,
        ),
      ),
    );

    return AiToolActionResultModel(
      toolName: HojatyToolRegistry.toolOpenAthkarCategory,
      arguments: args,
      result: {'category': arabicTitle, 'type': catType.name},
      displayText: 'تم فتح $arabicTitle.',
    );
  }

  // 6. Tool: Control Sebha Counter
  Future<AiToolActionResultModel> _handleControlSebhaCounter(
    Map<String, dynamic> args,
  ) async {
    final action = (args['action'] as String? ?? 'get').toLowerCase();
    final count = (args['count'] as num?)?.toInt();
    final dhikr = args['dhikrPhrase'] as String? ?? 'التسبيح';

    if (action == 'open_screen') {
      _navigationEventController.add(
        const AppActionNavigationEvent(routeName: AppRoutes.sebha),
      );
      return AiToolActionResultModel(
        toolName: HojatyToolRegistry.toolControlSebhaCounter,
        arguments: args,
        result: const {'action': 'opened'},
        displayText: 'تم فتح السبحة الإلكترونية.',
      );
    }

    if (action == 'reset') {
      UserHiveHelper.setSebhaCounter(0);
      return AiToolActionResultModel(
        toolName: HojatyToolRegistry.toolControlSebhaCounter,
        arguments: args,
        result: const {'counter': 0},
        displayText: 'تم تصفير عداد السبحة الإلكترونية بنجاح (العدد الحالي: 0).',
      );
    }

    if (action == 'set_count' && count != null) {
      UserHiveHelper.setSebhaCounter(count);
      return AiToolActionResultModel(
        toolName: HojatyToolRegistry.toolControlSebhaCounter,
        arguments: args,
        result: {'counter': count},
        displayText: 'تم تسجيل $count تسبيحة في السبحة الإلكترونية لـ ($dhikr).',
      );
    }

    final currentCount = UserHiveHelper.getSebhaCounter();
    return AiToolActionResultModel(
      toolName: HojatyToolRegistry.toolControlSebhaCounter,
      arguments: args,
      result: {'counter': currentCount},
      displayText: 'العدد المسجل حالياً في السبحة هو: $currentCount تسبيحة.',
    );
  }

  // 7. Tool: Manage Quran Bookmark
  Future<AiToolActionResultModel> _handleManageQuranBookmark(
    Map<String, dynamic> args,
  ) async {
    final action = (args['action'] as String? ?? 'save').toLowerCase();

    if (action == 'get_latest') {
      final bookmarks = await _checkpointDataSource.getAll();
      if (bookmarks.isNotEmpty) {
        final latest = bookmarks.first;
        return AiToolActionResultModel(
          toolName: HojatyToolRegistry.toolManageQuranBookmark,
          arguments: args,
          result: {
            'pageNumber': latest.pageNumber,
            'verseIndex': latest.verseIndex,
            'surahName': latest.surahName,
          },
          displayText:
              'آخر موضع حفظ كان في سورة ${latest.surahName} (صفحة ${latest.pageNumber}، آية ${latest.verseIndex}).',
        );
      }
      return AiToolActionResultModel(
        toolName: HojatyToolRegistry.toolManageQuranBookmark,
        arguments: args,
        displayText: 'لا توجد علامات حفظ مسجلة حالياً في المصحف.',
      );
    }

    // Save checkpoint
    final pageNumber = (args['pageNumber'] as num?)?.toInt() ?? 1;
    final verseIndex = (args['verseIndex'] as num?)?.toInt() ?? 1;
    final surahName = args['surahName'] as String? ?? 'سورة من القرآن';

    final checkpoint = QuranCheckpointModel(
      pageNumber: pageNumber,
      verseIndex: verseIndex,
      verseNumber: verseIndex,
      verseContent: 'علامة حفظ عند آية $verseIndex',
      verseContentEmaly: 'علامة حفظ عند اية $verseIndex',
      surahName: surahName,
      createdAt: DateTime.now(),
    );

    await _checkpointDataSource.save(checkpoint);

    return AiToolActionResultModel(
      toolName: HojatyToolRegistry.toolManageQuranBookmark,
      arguments: args,
      result: {
        'pageNumber': pageNumber,
        'verseIndex': verseIndex,
        'surahName': surahName,
      },
      displayText:
          'تم حفظ علامة الوقف عند صفحة $pageNumber (آية $verseIndex من $surahName) بنجاح.',
    );
  }

  // 8. Tool: Open Hadith Reader
  Future<AiToolActionResultModel> _handleOpenHadithReader(
    Map<String, dynamic> args,
  ) async {
    _navigationEventController.add(
      const AppActionNavigationEvent(routeName: AppRoutes.books),
    );

    final bookId = args['bookId'] as String? ?? 'صحيح البخاري';

    return AiToolActionResultModel(
      toolName: HojatyToolRegistry.toolOpenHadithReader,
      arguments: args,
      result: {'bookId': bookId},
      displayText: 'تم فتح قسم المكتبة والكتب الإسلامية لعرض $bookId.',
    );
  }

  // 9. Tool: Open Qibla Compass
  Future<AiToolActionResultModel> _handleOpenQiblaCompass(
    Map<String, dynamic> args,
  ) async {
    _navigationEventController.add(
      const AppActionNavigationEvent(routeName: AppRoutes.qibla),
    );

    return AiToolActionResultModel(
      toolName: HojatyToolRegistry.toolOpenQiblaCompass,
      arguments: args,
      result: const {
        'bearing': 136.0,
        'direction': 'جنوب شرق',
      },
      displayText:
          'تم فتح بوصلة القبلة. اتجاه القبلة من مصر نحو مكة المكرمة هو تقريباً 136° جنوب شرق.',
    );
  }

  // 10. Tool: Update App Preferences
  Future<AiToolActionResultModel> _handleUpdateAppPreferences(
    Map<String, dynamic> args,
  ) async {
    final themeStr = (args['themeMode'] as String? ?? '').toLowerCase();
    final quietMode = args['enableAnaOsalyQuiet'] as bool?;

    final updates = <String>[];

    if (themeStr.isNotEmpty) {
      if (themeStr.contains('dark') || themeStr.contains('داكن')) {
        UserHiveHelper.setThemeMode(AppThemeMode.dark);
        updates.add('تفعيل الوضع الداكن');
      } else if (themeStr.contains('amoled') || themeStr.contains('أسود')) {
        UserHiveHelper.setThemeMode(AppThemeMode.amoled);
        updates.add('تفعيل وضع أموليد شديد السواد');
      } else if (themeStr.contains('light') || themeStr.contains('فاتح')) {
        UserHiveHelper.setThemeMode(AppThemeMode.light);
        updates.add('تفعيل الوضع الفاتح');
      }
    }

    if (quietMode != null) {
      UserHiveHelper.setAnaOsalyEnabled(quietMode);
      updates.add(quietMode ? 'تفعيل وضع أنا أصلي الهادئ' : 'تعطيل وضع أنا أصلي');
    }

    final summary = updates.isNotEmpty ? updates.join(' و ') : 'تحديث الإعدادات';

    return AiToolActionResultModel(
      toolName: HojatyToolRegistry.toolUpdateAppPreferences,
      arguments: args,
      result: {'updated': updates},
      displayText: 'تم $summary بنجاح.',
    );
  }

  String _getPrayerArabicName(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return 'الفجر';
      case PrayerType.dhuhr:
        return 'الظهر';
      case PrayerType.asr:
        return 'العصر';
      case PrayerType.maghrib:
        return 'المغرب';
      case PrayerType.isha:
        return 'العشاء';
    }
  }

  String _normalizePrayerNameArabic(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return 'صلاة الفجر';
      case 'dhuhr':
        return 'صلاة الظهر';
      case 'asr':
        return 'صلاة العصر';
      case 'maghrib':
        return 'صلاة المغرب';
      case 'isha':
        return 'صلاة العشاء';
      case 'all':
        return 'جميع الصلوات';
      default:
        return 'الصلاة';
    }
  }

  void dispose() {
    _navigationEventController.close();
  }
}

